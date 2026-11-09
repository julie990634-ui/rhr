--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 공고별 자기소개서 문항
--
-- 04_application.sql 에서는 자기소개서를 TB_APPLICATION 의 고정 3개 컬럼
-- (ESSAY_MOTIVE / ESSAY_GROWTH / ESSAY_STRENGTH) 으로 두었다.
-- 공고마다 문항을 다르게 쓰려면 문항을 데이터로 관리해야 하므로,
-- 문항 정의 테이블과 답변 테이블로 분리한다.
--
-- 실행 : tbsql YSHR/비밀번호@tibero @05_essay_question.sql
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 1. 공고별 자기소개서 문항
--------------------------------------------------------------------------------
CREATE TABLE TB_RECRUIT_ESSAY (
    ESSAY_ID      NUMBER(12)      NOT NULL,           -- 문항 일련번호
    RECRUIT_ID    NUMBER(10)      NOT NULL,           -- 대상 공고
    SORT_NO       NUMBER(3)       DEFAULT 0 NOT NULL, -- 문항 순서
    QUESTION      VARCHAR2(500)   NOT NULL,           -- 문항
    GUIDE         VARCHAR2(1000),                     -- 작성 안내 문구
    MAX_LENGTH    NUMBER(5)       DEFAULT 3000 NOT NULL, -- 글자수 상한
    REQUIRED_YN   CHAR(1)         DEFAULT 'Y' NOT NULL,  -- 필수 작성 여부
    REG_ID        VARCHAR2(50),
    REG_DT        DATE            DEFAULT SYSDATE NOT NULL,
    UPD_ID        VARCHAR2(50),
    UPD_DT        DATE,
    CONSTRAINT PK_TB_RECRUIT_ESSAY PRIMARY KEY (ESSAY_ID),
    CONSTRAINT FK_TB_RECRUIT_ESSAY FOREIGN KEY (RECRUIT_ID)
        REFERENCES TB_RECRUIT (RECRUIT_ID) ON DELETE CASCADE
);

COMMENT ON TABLE  TB_RECRUIT_ESSAY             IS '공고별 자기소개서 문항';
COMMENT ON COLUMN TB_RECRUIT_ESSAY.QUESTION    IS '문항';
COMMENT ON COLUMN TB_RECRUIT_ESSAY.GUIDE       IS '작성 안내 문구';
COMMENT ON COLUMN TB_RECRUIT_ESSAY.MAX_LENGTH  IS '글자수 상한';
COMMENT ON COLUMN TB_RECRUIT_ESSAY.REQUIRED_YN IS '필수 작성 여부';

CREATE INDEX IX_TB_RECRUIT_ESSAY_01 ON TB_RECRUIT_ESSAY (RECRUIT_ID, SORT_NO);
CREATE SEQUENCE SEQ_TB_RECRUIT_ESSAY START WITH 1 INCREMENT BY 1 NOCACHE;


--------------------------------------------------------------------------------
-- 2. 지원서의 자기소개서 답변
--
-- QUESTION 을 답변 쪽에도 복사해 둔다(스냅샷).
-- 담당자가 나중에 문항을 고치더라도, 지원자가 '무엇을 보고 답했는지' 는
-- 그대로 남아야 한다. RECRUIT_ESSAY_ID 는 참고용이라 외래키를 걸지 않는다.
-- 문항을 지웠다는 이유로 이미 접수된 답변이 사라지면 안 되기 때문이다.
--------------------------------------------------------------------------------
CREATE TABLE TB_APP_ESSAY (
    APP_ESSAY_ID     NUMBER(12)     NOT NULL,
    APP_ID           NUMBER(12)     NOT NULL,
    RECRUIT_ESSAY_ID NUMBER(12),                      -- 작성 당시 문항 번호 (참고용)
    SORT_NO          NUMBER(3)      DEFAULT 0 NOT NULL,
    QUESTION         VARCHAR2(500)  NOT NULL,         -- 작성 당시 문항 (스냅샷)
    CONTENT          CLOB,
    CONSTRAINT PK_TB_APP_ESSAY PRIMARY KEY (APP_ESSAY_ID),
    CONSTRAINT FK_TB_APP_ESSAY FOREIGN KEY (APP_ID)
        REFERENCES TB_APPLICATION (APP_ID) ON DELETE CASCADE
);

COMMENT ON TABLE  TB_APP_ESSAY          IS '지원서 - 자기소개서 답변';
COMMENT ON COLUMN TB_APP_ESSAY.QUESTION IS '작성 당시 문항 스냅샷. 문항이 수정돼도 보존된다';

CREATE INDEX IX_TB_APP_ESSAY_01 ON TB_APP_ESSAY (APP_ID, SORT_NO);
CREATE SEQUENCE SEQ_TB_APP_ESSAY START WITH 1 INCREMENT BY 1 NOCACHE;


--------------------------------------------------------------------------------
-- 3. 기존 지원서의 자기소개서를 옮긴다
--
-- 04_application.sql 로 만든 고정 3개 컬럼에 이미 들어 있는 내용을
-- 새 답변 테이블로 복사한다. 내용이 비어 있는 문항은 옮기지 않는다.
--------------------------------------------------------------------------------
INSERT INTO TB_APP_ESSAY (APP_ESSAY_ID, APP_ID, RECRUIT_ESSAY_ID, SORT_NO, QUESTION, CONTENT)
SELECT SEQ_TB_APP_ESSAY.NEXTVAL, APP_ID, NULL, 0, '지원동기 및 입사 후 포부', ESSAY_MOTIVE
  FROM TB_APPLICATION
 WHERE ESSAY_MOTIVE IS NOT NULL;

INSERT INTO TB_APP_ESSAY (APP_ESSAY_ID, APP_ID, RECRUIT_ESSAY_ID, SORT_NO, QUESTION, CONTENT)
SELECT SEQ_TB_APP_ESSAY.NEXTVAL, APP_ID, NULL, 1, '성장과정 및 가치관', ESSAY_GROWTH
  FROM TB_APPLICATION
 WHERE ESSAY_GROWTH IS NOT NULL;

INSERT INTO TB_APP_ESSAY (APP_ESSAY_ID, APP_ID, RECRUIT_ESSAY_ID, SORT_NO, QUESTION, CONTENT)
SELECT SEQ_TB_APP_ESSAY.NEXTVAL, APP_ID, NULL, 2, '직무 관련 역량과 경험', ESSAY_STRENGTH
  FROM TB_APPLICATION
 WHERE ESSAY_STRENGTH IS NOT NULL;


--------------------------------------------------------------------------------
-- 4. 기존 공고에 기본 문항 3개를 넣어 준다
--
-- 문항이 하나도 없는 공고는 애플리케이션이 기본 문항으로 대체하지만,
-- 담당자가 화면에서 바로 손볼 수 있도록 실제 행으로 만들어 둔다.
--------------------------------------------------------------------------------
INSERT INTO TB_RECRUIT_ESSAY (ESSAY_ID, RECRUIT_ID, SORT_NO, QUESTION, GUIDE, MAX_LENGTH, REQUIRED_YN, REG_ID)
SELECT SEQ_TB_RECRUIT_ESSAY.NEXTVAL, RECRUIT_ID, 0,
       '지원동기 및 입사 후 포부',
       '지원하게 된 계기와 입사 후 이루고 싶은 목표를 구체적으로 작성해 주세요.',
       3000, 'Y', 'admin'
  FROM TB_RECRUIT;

INSERT INTO TB_RECRUIT_ESSAY (ESSAY_ID, RECRUIT_ID, SORT_NO, QUESTION, GUIDE, MAX_LENGTH, REQUIRED_YN, REG_ID)
SELECT SEQ_TB_RECRUIT_ESSAY.NEXTVAL, RECRUIT_ID, 1,
       '성장과정 및 가치관',
       '성장 과정에서 형성된 가치관과 그것이 드러난 경험을 작성해 주세요.',
       3000, 'N', 'admin'
  FROM TB_RECRUIT;

INSERT INTO TB_RECRUIT_ESSAY (ESSAY_ID, RECRUIT_ID, SORT_NO, QUESTION, GUIDE, MAX_LENGTH, REQUIRED_YN, REG_ID)
SELECT SEQ_TB_RECRUIT_ESSAY.NEXTVAL, RECRUIT_ID, 2,
       '직무 관련 역량과 경험',
       '지원 분야와 관련된 역량을 보여 줄 수 있는 경험을 작성해 주세요.',
       3000, 'N', 'admin'
  FROM TB_RECRUIT;


COMMIT;


--------------------------------------------------------------------------------
-- 5. 옮긴 뒤 기존 컬럼 제거
--
-- ★ 위 3번이 제대로 옮겨졌는지 확인한 뒤에 따로 실행할 것.
--   아래 쿼리로 건수가 맞는지 먼저 본다.
--
--   SELECT (SELECT COUNT(*) FROM TB_APPLICATION WHERE ESSAY_MOTIVE IS NOT NULL)
--        + (SELECT COUNT(*) FROM TB_APPLICATION WHERE ESSAY_GROWTH IS NOT NULL)
--        + (SELECT COUNT(*) FROM TB_APPLICATION WHERE ESSAY_STRENGTH IS NOT NULL) AS 원본,
--          (SELECT COUNT(*) FROM TB_APP_ESSAY) AS 이관본
--     FROM DUAL;
--
-- 건수가 같으면 아래를 실행한다. 애플리케이션은 이 컬럼들을 더 이상 읽지 않는다.
--
-- ALTER TABLE TB_APPLICATION DROP COLUMN ESSAY_MOTIVE;
-- ALTER TABLE TB_APPLICATION DROP COLUMN ESSAY_GROWTH;
-- ALTER TABLE TB_APPLICATION DROP COLUMN ESSAY_STRENGTH;
-- COMMIT;
--------------------------------------------------------------------------------
