-- ------------------------------------------------------------------------------
-- 외부 SSO 연동 (인증 관문별 제공 정책과 호출 이력)
--
-- 마스터접근제어 > 외부 SSO연동이 쓴다. 15_access_block.sql 과 16_webshell.sql (TB_SECURITY_SETTING)을
-- 먼저 실행해야 한다.
--   TB_SSO_GATE_POLICY  관문별 제공 정책: ALLOW_ALL(전체 허용) / ALLOW_IP(허용 IP 만) / BLOCK(차단).
--                       행이 없는 관문은 전체 허용이다.
--   TB_SSO_CALL         관문 호출 이력. 정책으로 막은 건(BLOCK)과 인증에 실패한 건(FAIL)은 건별로 보관하고,
--                       정상 호출(ALLOW)은 모니터링 용도로 최근 2,000건만 남긴다.
--
-- 자동 차단 옵션(sso.autoBlock / sso.autoSec / sso.autoCnt)은 TB_SECURITY_SETTING 에 저장된다.
--
-- 이 스크립트를 실행하지 않으면 외부 SSO연동 화면은 "테이블이 없다"는 안내만 보여 주고,
-- 관문은 평소처럼 모두 열려 있다(요청은 막히지 않는다).
-- ------------------------------------------------------------------------------
CREATE TABLE TB_SSO_GATE_POLICY (
    GATE_KEY    VARCHAR2(30)    NOT NULL,
    POLICY      VARCHAR2(10)    NOT NULL,
    ALLOW_IPS   VARCHAR2(1000),
    UPDATED_BY  VARCHAR2(30),
    UPDATED_DT  DATE            DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_TB_SSO_GATE_POLICY PRIMARY KEY (GATE_KEY),
    CONSTRAINT CK_TB_SSO_GATE_POLICY CHECK (POLICY IN ('ALLOW_ALL', 'ALLOW_IP', 'BLOCK'))
);

COMMENT ON TABLE  TB_SSO_GATE_POLICY            IS '인증 관문별 제공 정책';
COMMENT ON COLUMN TB_SSO_GATE_POLICY.GATE_KEY   IS '관문 구분 (admin-login 등)';
COMMENT ON COLUMN TB_SSO_GATE_POLICY.POLICY     IS 'ALLOW_ALL(전체 허용) / ALLOW_IP(허용 IP 만) / BLOCK(차단)';
COMMENT ON COLUMN TB_SSO_GATE_POLICY.ALLOW_IPS  IS 'ALLOW_IP 일 때 허용하는 IP · IPv4 대역(콤마로 구분)';
COMMENT ON COLUMN TB_SSO_GATE_POLICY.UPDATED_BY IS '바꾼 담당자';
COMMENT ON COLUMN TB_SSO_GATE_POLICY.UPDATED_DT IS '바꾼 시각';

CREATE SEQUENCE SEQ_TB_SSO_CALL START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE TB_SSO_CALL (
    CALL_ID     NUMBER(12)      NOT NULL,
    OCCUR_DT    DATE            DEFAULT SYSDATE NOT NULL,
    GATE_KEY    VARCHAR2(30)    NOT NULL,
    RESULT      VARCHAR2(10)    NOT NULL,
    SRC_IP      VARCHAR2(45),
    REQ_PATH    VARCHAR2(300),
    ACCOUNT     VARCHAR2(30),
    HTTP_METHOD VARCHAR2(10),
    NOTE        VARCHAR2(500),
    REQ_HEADER  VARCHAR2(1000),
    ACK_YN      CHAR(1)         DEFAULT 'N' NOT NULL,
    ACK_BY      VARCHAR2(30),
    ACK_DT      DATE,
    CONSTRAINT PK_TB_SSO_CALL PRIMARY KEY (CALL_ID),
    CONSTRAINT CK_TB_SSO_CALL_RESULT CHECK (RESULT IN ('ALLOW', 'FAIL', 'BLOCK')),
    CONSTRAINT CK_TB_SSO_CALL_ACK CHECK (ACK_YN IN ('Y', 'N'))
);

CREATE INDEX IDX_SSO_CALL_DT   ON TB_SSO_CALL (OCCUR_DT);
CREATE INDEX IDX_SSO_CALL_GATE ON TB_SSO_CALL (GATE_KEY, OCCUR_DT);
CREATE INDEX IDX_SSO_CALL_IP   ON TB_SSO_CALL (SRC_IP, OCCUR_DT);

COMMENT ON TABLE  TB_SSO_CALL             IS '인증 관문 호출 이력';
COMMENT ON COLUMN TB_SSO_CALL.CALL_ID     IS '이력 번호';
COMMENT ON COLUMN TB_SSO_CALL.OCCUR_DT    IS '호출 시각';
COMMENT ON COLUMN TB_SSO_CALL.GATE_KEY    IS '관문 구분';
COMMENT ON COLUMN TB_SSO_CALL.RESULT      IS 'ALLOW(허용) / FAIL(허용했으나 인증 실패) / BLOCK(정책으로 차단)';
COMMENT ON COLUMN TB_SSO_CALL.SRC_IP      IS '출발지 IP';
COMMENT ON COLUMN TB_SSO_CALL.REQ_PATH    IS '요청 경로';
COMMENT ON COLUMN TB_SSO_CALL.ACCOUNT     IS '인증을 시도한 계정 (아이디 형식이 아니면 비움)';
COMMENT ON COLUMN TB_SSO_CALL.HTTP_METHOD IS 'HTTP 메서드';
COMMENT ON COLUMN TB_SSO_CALL.NOTE        IS '사유 · 조치 내역';
COMMENT ON COLUMN TB_SSO_CALL.REQ_HEADER  IS '요청 헤더 요약 (쿠키 · 인증 헤더 값은 ***)';
COMMENT ON COLUMN TB_SSO_CALL.ACK_YN      IS '확인 처리 여부 (Y/N)';
COMMENT ON COLUMN TB_SSO_CALL.ACK_BY      IS '확인한 담당자';
COMMENT ON COLUMN TB_SSO_CALL.ACK_DT      IS '확인 시각';
