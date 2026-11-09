-- ------------------------------------------------------------------------------
-- 보안 이벤트
--
-- 마스터접근제어 > 보안현황이 집계하는 원천 기록이다. 아래 상황이 한 건씩 쌓인다.
--   WEBSHELL  JSP 직접 호출 등 웹셸 침해 의심 요청
--   ABNORMAL  비정상 요청 (404 탐색, 400 형식 위반, 500 서버 오류)
--   UNAUTH    로그인 없이 관리자 화면에 접근했거나, 권한 밖 경로를 호출
--   PASSWORD  패스워드 인증 실패 (관리자 로그인, 지원자 본인 조회)
--
-- 기록이 실패해도 원래 요청은 그대로 처리된다(애플리케이션이 예외를 삼킨다).
-- 이 스크립트를 실행하지 않으면 보안현황 화면은 "이벤트 테이블이 없다"는 안내만 보여 준다.
-- ------------------------------------------------------------------------------
CREATE SEQUENCE SEQ_TB_SECURITY_EVENT START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE TB_SECURITY_EVENT (
    EVENT_ID    NUMBER(12)      NOT NULL,
    EVENT_TYPE  VARCHAR2(20)    NOT NULL,
    SUB_TYPE    VARCHAR2(30),
    SRC_IP      VARCHAR2(45),
    REQ_PATH    VARCHAR2(300),
    DETAIL      VARCHAR2(200),
    OCCUR_DT    DATE            DEFAULT SYSDATE NOT NULL,
    ACK_YN      CHAR(1)         DEFAULT 'N' NOT NULL,
    ACK_BY      VARCHAR2(30),
    ACK_DT      DATE,
    CONSTRAINT PK_TB_SECURITY_EVENT PRIMARY KEY (EVENT_ID),
    CONSTRAINT CK_TB_SECURITY_EVENT_ACK CHECK (ACK_YN IN ('Y', 'N'))
);

CREATE INDEX IDX_SECURITY_EVENT_DT ON TB_SECURITY_EVENT (OCCUR_DT);
CREATE INDEX IDX_SECURITY_EVENT_IP ON TB_SECURITY_EVENT (SRC_IP, OCCUR_DT);

COMMENT ON TABLE  TB_SECURITY_EVENT            IS '보안 이벤트 (보안현황 집계 원천)';
COMMENT ON COLUMN TB_SECURITY_EVENT.EVENT_ID   IS '이벤트 번호';
COMMENT ON COLUMN TB_SECURITY_EVENT.EVENT_TYPE IS '유형: WEBSHELL / ABNORMAL / UNAUTH / PASSWORD';
COMMENT ON COLUMN TB_SECURITY_EVENT.SUB_TYPE   IS '세부 유형 (예: NOT_FOUND, ADMIN_LOGIN)';
COMMENT ON COLUMN TB_SECURITY_EVENT.SRC_IP     IS '출발지 IP';
COMMENT ON COLUMN TB_SECURITY_EVENT.REQ_PATH   IS '요청 경로 (쿼리스트링 제외)';
COMMENT ON COLUMN TB_SECURITY_EVENT.DETAIL     IS '부가 정보 (응답 코드, 시도한 계정 등)';
COMMENT ON COLUMN TB_SECURITY_EVENT.OCCUR_DT   IS '발생 시각';
COMMENT ON COLUMN TB_SECURITY_EVENT.ACK_YN     IS '확인 처리 여부';
COMMENT ON COLUMN TB_SECURITY_EVENT.ACK_BY     IS '확인한 담당자';
COMMENT ON COLUMN TB_SECURITY_EVENT.ACK_DT     IS '확인 시각';
