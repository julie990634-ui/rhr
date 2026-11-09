-- ------------------------------------------------------------------------------
-- 비정상 요청 탐지
--
-- 마스터접근제어 > 비정상요청탐지가 쓴다. 14_security_event.sql, 16_webshell.sql 을 먼저 실행해야 한다.
--   TB_SECURITY_EVENT  비정상 요청 이력에 필요한 열(판정, 응답 코드, 인증 여부, 집계)을 더한다.
--   TB_LOGIN_IP        최근 로그인에 성공한 (출발지 IP, 계정) 쌍. 한 출발지에서 로그인한 계정이 여럿이면
--                      NAT · 프록시 같은 공유 IP 로 보고 자동 차단을 보류하는 데 쓴다.
--
-- 판정 임계 값은 TB_SECURITY_SETTING (abnormal.* 키)에 저장된다. 값이 없으면 기본값을 쓴다.
-- 이 스크립트를 실행하지 않으면 비정상요청탐지 화면은 "테이블이 없다"는 안내만 보여 주고,
-- 요청은 평소처럼 처리된다.
-- ------------------------------------------------------------------------------
ALTER TABLE TB_SECURITY_EVENT ADD (
    VERDICT     VARCHAR2(12),
    HTTP_STATUS NUMBER(3),
    AUTHED      CHAR(1),
    AGG_CNT     NUMBER(6),
    AGG_PATHS   NUMBER(6),
    AGG_IPS     NUMBER(6)
);

COMMENT ON COLUMN TB_SECURITY_EVENT.VERDICT     IS '비정상 요청 판정: AUTO_BLOCK / HOLD / BUG / WATCH';
COMMENT ON COLUMN TB_SECURITY_EVENT.HTTP_STATUS IS '응답 코드 (404, 400, 405, 414, 500 ...)';
COMMENT ON COLUMN TB_SECURITY_EVENT.AUTHED      IS '로그인 세션이 있는 요청이었는지 (Y/N)';
COMMENT ON COLUMN TB_SECURITY_EVENT.AGG_CNT     IS '집계 창 안에서 이 출발지의 같은 종류 실패 건수';
COMMENT ON COLUMN TB_SECURITY_EVENT.AGG_PATHS   IS '집계 창 안에서 이 출발지가 실패한 서로 다른 경로 수';
COMMENT ON COLUMN TB_SECURITY_EVENT.AGG_IPS     IS '집계 창 안에서 이 경로에서 실패한 서로 다른 출발지 수';

CREATE TABLE TB_LOGIN_IP (
    SRC_IP   VARCHAR2(45)  NOT NULL,
    ACCOUNT  VARCHAR2(30)  NOT NULL,
    LAST_DT  DATE          DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_TB_LOGIN_IP PRIMARY KEY (SRC_IP, ACCOUNT)
);

CREATE INDEX IDX_LOGIN_IP_DT ON TB_LOGIN_IP (LAST_DT);

COMMENT ON TABLE  TB_LOGIN_IP         IS '로그인에 성공한 출발지 IP 와 계정 (공유 IP 판단용)';
COMMENT ON COLUMN TB_LOGIN_IP.SRC_IP  IS '출발지 IP';
COMMENT ON COLUMN TB_LOGIN_IP.ACCOUNT IS '관리자 아이디 또는 지원서 접수번호';
COMMENT ON COLUMN TB_LOGIN_IP.LAST_DT IS '마지막으로 로그인한 시각';
