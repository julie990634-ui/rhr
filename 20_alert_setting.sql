-- ------------------------------------------------------------------------------
-- 보안 알림 설정 (수신자)
--
-- 마스터접근제어 > 알림설정이 쓴다. 16_webshell.sql (TB_SECURITY_SETTING)을 먼저 실행해야 한다.
--   TB_ALERT_RECIPIENT  보안 알림을 받을 담당자(이름 + 메일 주소). 마스터 권한자는 이 목록과 별개로
--                       설정에 따라 항상 수신 대상에 포함된다.
--
-- 알림 방식 · 쿨다운 · 발송 제어 같은 나머지 설정은 TB_SECURITY_SETTING (alert.* 키)에 저장된다.
-- 이 스크립트를 실행하지 않으면 알림설정 화면의 수신자 영역만 "테이블이 없다"는 안내를 보여 준다.
--
-- 현재 이 설정은 저장만 하며 알림을 실제로 발송하지는 않는다.
-- ------------------------------------------------------------------------------
CREATE SEQUENCE SEQ_TB_ALERT_RECIPIENT START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE TB_ALERT_RECIPIENT (
    RECIPIENT_ID NUMBER(10)     NOT NULL,
    RECIPIENT_NAME VARCHAR2(50) NOT NULL,
    EMAIL        VARCHAR2(100)  NOT NULL,
    CREATED_BY   VARCHAR2(30),
    CREATED_DT   DATE           DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_TB_ALERT_RECIPIENT PRIMARY KEY (RECIPIENT_ID),
    CONSTRAINT UK_TB_ALERT_RECIPIENT UNIQUE (EMAIL)
);

COMMENT ON TABLE  TB_ALERT_RECIPIENT                IS '보안 알림 수신자';
COMMENT ON COLUMN TB_ALERT_RECIPIENT.RECIPIENT_ID   IS '수신자 번호';
COMMENT ON COLUMN TB_ALERT_RECIPIENT.RECIPIENT_NAME IS '수신자 이름';
COMMENT ON COLUMN TB_ALERT_RECIPIENT.EMAIL          IS '수신 메일 주소';
COMMENT ON COLUMN TB_ALERT_RECIPIENT.CREATED_BY     IS '등록한 담당자';
COMMENT ON COLUMN TB_ALERT_RECIPIENT.CREATED_DT     IS '등록 시각';
