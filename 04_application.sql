--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 온라인 입사지원
--
-- 지원서 양식 파일을 첨부받지 않고, 지원자가 화면에서 직접 입력한 내용을
-- 그대로 저장한다. 관리자는 저장된 내용을 웹에서 조회한다.
--
-- ★ 주민등록번호는 수집하지 않는다.
--   개인정보보호법 제24조의2 에 따라 고유식별정보는 법령에 근거가 있을 때만
--   처리할 수 있고, 채용 지원 단계에는 그 근거가 없다. 본인 식별은
--   성명 + 생년월일 + 연락처로 충분하다.
--
-- 실행 : tbsql YSHR/비밀번호@tibero @04_application.sql
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 1. 지원서 (마스터)
--------------------------------------------------------------------------------
CREATE TABLE TB_APPLICATION (
    APP_ID          NUMBER(12)      NOT NULL,           -- 지원서 일련번호
    RECRUIT_ID      NUMBER(10)      NOT NULL,           -- 지원한 공고
    APP_NO          VARCHAR2(20)    NOT NULL,           -- 접수번호 (예: A2026-000123)

    -- 인적사항
    APP_NAME        VARCHAR2(60)    NOT NULL,           -- 성명
    BIRTH_DT        DATE            NOT NULL,           -- 생년월일
    GENDER          CHAR(1),                            -- M / F (선택 입력)
    PHONE           VARCHAR2(30)    NOT NULL,           -- 휴대전화
    EMAIL           VARCHAR2(150)   NOT NULL,           -- 이메일
    ZIPCODE         VARCHAR2(10),
    ADDR1           VARCHAR2(300),                      -- 기본주소
    ADDR2           VARCHAR2(300),                      -- 상세주소

    -- 추가 인적사항
    MILITARY_CD     VARCHAR2(20),                       -- 군필 / 미필 / 면제 / 해당없음
    VETERAN_YN      CHAR(1)         DEFAULT 'N' NOT NULL, -- 보훈대상
    DISABLED_YN     CHAR(1)         DEFAULT 'N' NOT NULL, -- 장애인등록

    -- 자기소개서 (고정 3문항)
    ESSAY_MOTIVE    CLOB,                               -- 지원동기 및 입사 후 포부
    ESSAY_GROWTH    CLOB,                               -- 성장과정 및 가치관
    ESSAY_STRENGTH  CLOB,                               -- 직무 관련 역량과 경험

    -- 본인 조회용 비밀번호 (PBKDF2 해시, 평문 저장 금지)
    VIEW_PASSWORD   VARCHAR2(300)   NOT NULL,

    -- 전형 상태 : RECEIVED(접수완료) / SCREENING(서류심사) / PASSED(합격) / FAILED(불합격)
    STATUS          VARCHAR2(20)    DEFAULT 'RECEIVED' NOT NULL,
    ADMIN_MEMO      VARCHAR2(1000),                     -- 담당자 메모 (지원자에게 보이지 않음)

    -- 개인정보 수집·이용 동의
    PRIVACY_AGREE_YN CHAR(1)        DEFAULT 'N' NOT NULL,
    PRIVACY_AGREE_DT DATE,

    SUBMIT_DT       DATE            DEFAULT SYSDATE NOT NULL, -- 최초 제출 시각
    SUBMIT_IP       VARCHAR2(45),                       -- IPv6 까지 담을 수 있는 길이
    REG_DT          DATE            DEFAULT SYSDATE NOT NULL,
    UPD_DT          DATE,

    CONSTRAINT PK_TB_APPLICATION PRIMARY KEY (APP_ID),
    CONSTRAINT UK_TB_APPLICATION_NO UNIQUE (APP_NO),
    -- 같은 공고에 같은 사람이 두 번 지원하지 못하게 DB 차원에서 막는다.
    CONSTRAINT UK_TB_APPLICATION_DUP UNIQUE (RECRUIT_ID, APP_NAME, BIRTH_DT),
    CONSTRAINT FK_TB_APPLICATION_RCT FOREIGN KEY (RECRUIT_ID)
        REFERENCES TB_RECRUIT (RECRUIT_ID)
);

COMMENT ON TABLE  TB_APPLICATION                  IS '입사지원서';
COMMENT ON COLUMN TB_APPLICATION.APP_NO           IS '접수번호. 지원자가 본인 지원서를 찾을 때 쓴다';
COMMENT ON COLUMN TB_APPLICATION.VIEW_PASSWORD    IS '본인 조회용 비밀번호 (PBKDF2 해시)';
COMMENT ON COLUMN TB_APPLICATION.STATUS           IS 'RECEIVED / SCREENING / PASSED / FAILED';
COMMENT ON COLUMN TB_APPLICATION.ADMIN_MEMO       IS '담당자 메모. 지원자 화면에는 노출하지 않는다';
COMMENT ON COLUMN TB_APPLICATION.SUBMIT_IP        IS '제출 IP. 분쟁 대응용';

CREATE INDEX IX_TB_APPLICATION_01 ON TB_APPLICATION (RECRUIT_ID, STATUS);
CREATE INDEX IX_TB_APPLICATION_02 ON TB_APPLICATION (APP_NAME, BIRTH_DT);
CREATE INDEX IX_TB_APPLICATION_03 ON TB_APPLICATION (EMAIL);

CREATE SEQUENCE SEQ_TB_APPLICATION START WITH 1 INCREMENT BY 1 NOCACHE;


--------------------------------------------------------------------------------
-- 2. 학력사항
--------------------------------------------------------------------------------
CREATE TABLE TB_APP_EDUCATION (
    EDU_ID          NUMBER(12)      NOT NULL,
    APP_ID          NUMBER(12)      NOT NULL,
    SORT_NO         NUMBER(3)       DEFAULT 0 NOT NULL, -- 화면 입력 순서
    SCHOOL_TYPE     VARCHAR2(20),                       -- 고등학교 / 대학교 / 대학원
    SCHOOL_NAME     VARCHAR2(200),
    MAJOR           VARCHAR2(200),                      -- 전공
    ENTER_DT        DATE,                               -- 입학년월 (일자는 01 고정)
    GRAD_DT         DATE,                               -- 졸업년월
    GRAD_STATUS     VARCHAR2(20),                       -- 졸업 / 수료 / 재학 / 중퇴
    GPA             VARCHAR2(10),                       -- 학점
    GPA_MAX         VARCHAR2(10),                       -- 기준학점 (4.5 등)
    CONSTRAINT PK_TB_APP_EDUCATION PRIMARY KEY (EDU_ID),
    CONSTRAINT FK_TB_APP_EDUCATION FOREIGN KEY (APP_ID)
        REFERENCES TB_APPLICATION (APP_ID) ON DELETE CASCADE
);

COMMENT ON TABLE TB_APP_EDUCATION IS '지원서 - 학력사항';

CREATE INDEX IX_TB_APP_EDUCATION_01 ON TB_APP_EDUCATION (APP_ID, SORT_NO);
CREATE SEQUENCE SEQ_TB_APP_EDUCATION START WITH 1 INCREMENT BY 1 NOCACHE;


--------------------------------------------------------------------------------
-- 3. 경력사항
--------------------------------------------------------------------------------
CREATE TABLE TB_APP_CAREER (
    CAREER_ID       NUMBER(12)      NOT NULL,
    APP_ID          NUMBER(12)      NOT NULL,
    SORT_NO         NUMBER(3)       DEFAULT 0 NOT NULL,
    COMPANY         VARCHAR2(200),                      -- 회사명
    DEPT_POSITION   VARCHAR2(200),                      -- 부서 / 직위
    START_DT        DATE,                               -- 입사년월
    END_DT          DATE,                               -- 퇴사년월 (재직중이면 NULL)
    WORKING_YN      CHAR(1)         DEFAULT 'N' NOT NULL, -- 재직중 여부
    JOB_DESC        VARCHAR2(1000),                     -- 담당업무
    CONSTRAINT PK_TB_APP_CAREER PRIMARY KEY (CAREER_ID),
    CONSTRAINT FK_TB_APP_CAREER FOREIGN KEY (APP_ID)
        REFERENCES TB_APPLICATION (APP_ID) ON DELETE CASCADE
);

COMMENT ON TABLE TB_APP_CAREER IS '지원서 - 경력사항';

CREATE INDEX IX_TB_APP_CAREER_01 ON TB_APP_CAREER (APP_ID, SORT_NO);
CREATE SEQUENCE SEQ_TB_APP_CAREER START WITH 1 INCREMENT BY 1 NOCACHE;


--------------------------------------------------------------------------------
-- 4. 자격 / 어학
--------------------------------------------------------------------------------
CREATE TABLE TB_APP_CERT (
    CERT_ID         NUMBER(12)      NOT NULL,
    APP_ID          NUMBER(12)      NOT NULL,
    SORT_NO         NUMBER(3)       DEFAULT 0 NOT NULL,
    CERT_TYPE       VARCHAR2(20),                       -- 자격증 / 어학
    CERT_NAME       VARCHAR2(200),                      -- 자격증명 또는 시험명
    ISSUER          VARCHAR2(200),                      -- 발급기관 / 주관기관
    ACQUIRE_DT      DATE,                               -- 취득일 / 응시일
    SCORE           VARCHAR2(50),                       -- 점수 또는 등급
    CONSTRAINT PK_TB_APP_CERT PRIMARY KEY (CERT_ID),
    CONSTRAINT FK_TB_APP_CERT FOREIGN KEY (APP_ID)
        REFERENCES TB_APPLICATION (APP_ID) ON DELETE CASCADE
);

COMMENT ON TABLE TB_APP_CERT IS '지원서 - 자격 / 어학';

CREATE INDEX IX_TB_APP_CERT_01 ON TB_APP_CERT (APP_ID, SORT_NO);
CREATE SEQUENCE SEQ_TB_APP_CERT START WITH 1 INCREMENT BY 1 NOCACHE;


COMMIT;


--------------------------------------------------------------------------------
-- 보유기간 경과분 파기 (참고용)
--
-- 개인정보 수집·이용 동의서에 안내한 보유기간이 지나면 지체 없이 파기해야 한다.
-- 아래는 채용 종료 후 6개월이 지난 지원서를 지우는 예시다.
-- 자식 테이블은 ON DELETE CASCADE 로 함께 지워진다.
-- 운영에서는 스케줄러에 등록해 정기적으로 돌리는 것을 권장한다.
--
-- DELETE FROM TB_APPLICATION
--  WHERE RECRUIT_ID IN (SELECT RECRUIT_ID FROM TB_RECRUIT
--                        WHERE END_DT < ADD_MONTHS(SYSDATE, -6));
-- COMMIT;
--------------------------------------------------------------------------------
