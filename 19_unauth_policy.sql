-- ------------------------------------------------------------------------------
-- 비인가(미인증) 접근 정책
--
-- 마스터접근제어 > 비인가접근 > 비인가 접근 정책이 쓴다. 15_access_block.sql 과 16_webshell.sql
-- (TB_SECURITY_SETTING)을 먼저 실행해야 하고, 비인가 접근 이력은 14 · 16 스크립트의 TB_SECURITY_EVENT 를 쓴다.
--   TB_UNAUTH_PATH  전체 차단 모드에서 로그인 없이도 호출할 수 있는 경로(개별 허용).
--                   경로 끝에 /* 를 붙이면 그 아래 모두를 뜻한다. ALLOW_IPS 가 비어 있으면 모든 IP 허용이다.
--
-- 모드(unauth.mode: ALLOW_ALL / DENY_ALL)는 TB_SECURITY_SETTING 에 저장되며 값이 없으면 전체 허용이다.
-- 전체 허용 모드에서는 아무 것도 막지 않으므로 이 스크립트를 실행하기 전에도 사이트는 평소처럼 동작한다.
--
-- 아래 INSERT 는 공개 화면(공고 · 공지 · FAQ · 지원서 작성)을 개별 허용으로 미리 등록한다. 전체 차단 모드로
-- 바꿔도 지원자가 쓰는 화면이 막히지 않게 하려는 것이며, 필요 없는 항목은 화면에서 지우면 된다.
-- 관리자 화면(/admin) · 로그인 관문 · 정적 자원(/resources) · 시작 화면은 목록과 무관하게 항상 열려 있다.
-- ------------------------------------------------------------------------------
CREATE SEQUENCE SEQ_TB_UNAUTH_PATH START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE TB_UNAUTH_PATH (
    PATH_ID     NUMBER(10)      NOT NULL,
    REQ_PATH    VARCHAR2(300)   NOT NULL,
    ALLOW_IPS   VARCHAR2(1000),
    CREATED_BY  VARCHAR2(30),
    CREATED_DT  DATE            DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_TB_UNAUTH_PATH PRIMARY KEY (PATH_ID),
    CONSTRAINT UK_TB_UNAUTH_PATH UNIQUE (REQ_PATH)
);

COMMENT ON TABLE  TB_UNAUTH_PATH            IS '비인가(미인증) 개별 허용 경로';
COMMENT ON COLUMN TB_UNAUTH_PATH.PATH_ID    IS '경로 번호';
COMMENT ON COLUMN TB_UNAUTH_PATH.REQ_PATH   IS '허용 경로 (소문자, 끝에 /* 이면 하위 전체)';
COMMENT ON COLUMN TB_UNAUTH_PATH.ALLOW_IPS  IS '허용 IP · IPv4 대역(콤마로 구분). 비어 있으면 모든 IP';
COMMENT ON COLUMN TB_UNAUTH_PATH.CREATED_BY IS '등록한 담당자';
COMMENT ON COLUMN TB_UNAUTH_PATH.CREATED_DT IS '등록 시각';

INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/recruit/list.do', 'system');
INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/recruit/view/*', 'system');
INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/notice/list.do', 'system');
INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/notice/view/*', 'system');
INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/faq/list.do', 'system');
INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/apply/verify/*', 'system');
INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/apply/form/*', 'system');
INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/apply/form.do', 'system');
INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/apply/save.do', 'system');
INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/apply/done.do', 'system');
INSERT INTO TB_UNAUTH_PATH (PATH_ID, REQ_PATH, CREATED_BY) VALUES (SEQ_TB_UNAUTH_PATH.NEXTVAL, '/apply/draft/*', 'system');
COMMIT;
