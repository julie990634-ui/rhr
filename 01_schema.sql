--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 스키마
-- DBMS   : Tibero
-- SCHEMA : YSHR
--
-- 실행   : tbsql YSHR/비밀번호@tibero @01_schema.sql
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 1. 채용공고
--------------------------------------------------------------------------------
CREATE TABLE TB_RECRUIT (
    RECRUIT_ID    NUMBER(10)      NOT NULL,           -- 공고 일련번호
    TITLE         VARCHAR2(300)   NOT NULL,           -- 공고 제목
    CONTENT       CLOB,                               -- 공고 본문 (HTML)
    EMP_TYPE      VARCHAR2(30),                       -- 고용형태 : 정규직 / 계약직 / 인턴
    DEPT_NAME     VARCHAR2(200),                      -- 모집 부서
    START_DT      DATE            NOT NULL,           -- 접수 시작일
    END_DT        DATE            NOT NULL,           -- 접수 마감일
    STEP_NAME     VARCHAR2(100),                      -- 진행단계 표시 (예: 2단계-인적성검사)
    CLOSED_YN     CHAR(1)         DEFAULT 'N' NOT NULL, -- 강제 종료 여부
    VIEW_CNT      NUMBER(10)      DEFAULT 0  NOT NULL, -- 조회수
    USE_YN        CHAR(1)         DEFAULT 'Y' NOT NULL, -- 노출 여부
    REG_ID        VARCHAR2(50),                       -- 등록자
    REG_DT        DATE            DEFAULT SYSDATE NOT NULL,
    UPD_ID        VARCHAR2(50),
    UPD_DT        DATE,
    CONSTRAINT PK_TB_RECRUIT PRIMARY KEY (RECRUIT_ID)
);

COMMENT ON TABLE  TB_RECRUIT             IS '채용공고';
COMMENT ON COLUMN TB_RECRUIT.RECRUIT_ID  IS '공고 일련번호';
COMMENT ON COLUMN TB_RECRUIT.TITLE       IS '공고 제목';
COMMENT ON COLUMN TB_RECRUIT.CONTENT     IS '공고 본문(HTML)';
COMMENT ON COLUMN TB_RECRUIT.EMP_TYPE    IS '고용형태';
COMMENT ON COLUMN TB_RECRUIT.DEPT_NAME   IS '모집부서';
COMMENT ON COLUMN TB_RECRUIT.START_DT    IS '접수시작일';
COMMENT ON COLUMN TB_RECRUIT.END_DT      IS '접수마감일';
COMMENT ON COLUMN TB_RECRUIT.STEP_NAME   IS '진행단계';
COMMENT ON COLUMN TB_RECRUIT.CLOSED_YN   IS '강제종료여부';
COMMENT ON COLUMN TB_RECRUIT.USE_YN      IS '노출여부';

-- 목록/검색 성능용 인덱스
CREATE INDEX IX_TB_RECRUIT_01 ON TB_RECRUIT (USE_YN, END_DT DESC);
CREATE INDEX IX_TB_RECRUIT_02 ON TB_RECRUIT (USE_YN, START_DT DESC);

CREATE SEQUENCE SEQ_TB_RECRUIT START WITH 1 INCREMENT BY 1 NOCACHE;


--------------------------------------------------------------------------------
-- 2. 공지사항
--------------------------------------------------------------------------------
CREATE TABLE TB_NOTICE (
    NOTICE_ID     NUMBER(10)      NOT NULL,           -- 공지 일련번호
    TITLE         VARCHAR2(300)   NOT NULL,           -- 제목
    CONTENT       CLOB,                               -- 본문 (HTML)
    NOTICE_DT     DATE            NOT NULL,           -- 게시일
    TOP_YN        CHAR(1)         DEFAULT 'N' NOT NULL, -- 상단 고정 여부
    VIEW_CNT      NUMBER(10)      DEFAULT 0  NOT NULL, -- 조회수
    USE_YN        CHAR(1)         DEFAULT 'Y' NOT NULL, -- 노출 여부
    REG_ID        VARCHAR2(50),
    REG_DT        DATE            DEFAULT SYSDATE NOT NULL,
    UPD_ID        VARCHAR2(50),
    UPD_DT        DATE,
    CONSTRAINT PK_TB_NOTICE PRIMARY KEY (NOTICE_ID)
);

COMMENT ON TABLE  TB_NOTICE            IS '공지사항';
COMMENT ON COLUMN TB_NOTICE.NOTICE_ID  IS '공지 일련번호';
COMMENT ON COLUMN TB_NOTICE.TITLE      IS '제목';
COMMENT ON COLUMN TB_NOTICE.CONTENT    IS '본문(HTML)';
COMMENT ON COLUMN TB_NOTICE.NOTICE_DT  IS '게시일';
COMMENT ON COLUMN TB_NOTICE.TOP_YN     IS '상단고정여부';
COMMENT ON COLUMN TB_NOTICE.USE_YN     IS '노출여부';

CREATE INDEX IX_TB_NOTICE_01 ON TB_NOTICE (USE_YN, TOP_YN DESC, NOTICE_DT DESC);

CREATE SEQUENCE SEQ_TB_NOTICE START WITH 1 INCREMENT BY 1 NOCACHE;


--------------------------------------------------------------------------------
-- 3. 자주하는질문 (FAQ)
--------------------------------------------------------------------------------
CREATE TABLE TB_FAQ (
    FAQ_ID        NUMBER(10)      NOT NULL,           -- FAQ 일련번호
    CATEGORY      VARCHAR2(50)    NOT NULL,           -- 분류 : 지원방법 / 서류 / 전형 / 기타
    QUESTION      VARCHAR2(500)   NOT NULL,           -- 질문
    ANSWER        CLOB,                               -- 답변 (HTML)
    SORT_NO       NUMBER(5)       DEFAULT 0  NOT NULL, -- 정렬순서
    VIEW_CNT      NUMBER(10)      DEFAULT 0  NOT NULL,
    USE_YN        CHAR(1)         DEFAULT 'Y' NOT NULL,
    REG_ID        VARCHAR2(50),
    REG_DT        DATE            DEFAULT SYSDATE NOT NULL,
    UPD_ID        VARCHAR2(50),
    UPD_DT        DATE,
    CONSTRAINT PK_TB_FAQ PRIMARY KEY (FAQ_ID)
);

COMMENT ON TABLE  TB_FAQ           IS '자주하는질문';
COMMENT ON COLUMN TB_FAQ.FAQ_ID    IS 'FAQ 일련번호';
COMMENT ON COLUMN TB_FAQ.CATEGORY  IS '분류';
COMMENT ON COLUMN TB_FAQ.QUESTION  IS '질문';
COMMENT ON COLUMN TB_FAQ.ANSWER    IS '답변(HTML)';
COMMENT ON COLUMN TB_FAQ.SORT_NO   IS '정렬순서';
COMMENT ON COLUMN TB_FAQ.USE_YN    IS '노출여부';

CREATE INDEX IX_TB_FAQ_01 ON TB_FAQ (USE_YN, CATEGORY, SORT_NO);

CREATE SEQUENCE SEQ_TB_FAQ START WITH 1 INCREMENT BY 1 NOCACHE;


COMMIT;
