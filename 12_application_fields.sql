--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 지원서 학력 / 경력 / 자격 입력 항목 확대
--
-- 학력사항 : 구분(고등학교 / 대학교(4년제) / 대학교(2년제) / 대학원(석사) / 대학원(박사)),
--           최종학력 표시, 소재지 추가
-- 경력사항 : 직급/직위, 근로형태, 퇴사사유 추가
--           (기존 DEPT_POSITION 은 '근무부서' 칸으로 계속 쓴다. 예전에 '부서/직위' 로 적은 값은 그대로 남는다.)
-- 자격사항 : 특기사항 추가
--
-- 기존 지원서 데이터는 건드리지 않는다. 새 칸은 모두 비어 있고(FINAL_YN 만 'N'), 예전 코드와도 함께 동작한다.
--
-- ★ 순서: 반드시 이 스크립트를 먼저 실행하고, 그 다음에 새 애플리케이션을 배포한다.
--   새 코드는 이 컬럼들을 읽고 쓰므로, 컬럼이 없는 상태로 배포하면 지원서 작성 / 조회 화면에서 오류가 난다.
--
-- 실행 : tbsql YSHR/비밀번호@tibero @12_application_fields.sql
--------------------------------------------------------------------------------

-- 1. 학력사항 ------------------------------------------------------------------
ALTER TABLE TB_APP_EDUCATION ADD (
    FINAL_YN         CHAR(1)        DEFAULT 'N' NOT NULL,   -- 최종학력 여부 (Y / N)
    SCHOOL_LOCATION  VARCHAR2(200)                          -- 학교 소재지
);
-- '대학교(4년제)', '대학원(석사)' 처럼 길어진 구분 값이 바이트 기준으로도 들어가도록 넓힌다.
ALTER TABLE TB_APP_EDUCATION MODIFY (SCHOOL_TYPE VARCHAR2(40));

COMMENT ON COLUMN TB_APP_EDUCATION.SCHOOL_TYPE     IS '구분: 고등학교 / 대학교(4년제) / 대학교(2년제) / 대학원(석사) / 대학원(박사) (이전 값: 대학교, 대학원)';
COMMENT ON COLUMN TB_APP_EDUCATION.GRAD_STATUS     IS '상태: 졸업 / 졸업예정 / 재학 / 수료 / 휴학 / 중퇴';
COMMENT ON COLUMN TB_APP_EDUCATION.FINAL_YN        IS '최종학력 여부 (Y 는 한 지원서에 한 줄만)';
COMMENT ON COLUMN TB_APP_EDUCATION.SCHOOL_LOCATION IS '학교 소재지';

-- 2. 경력사항 ------------------------------------------------------------------
ALTER TABLE TB_APP_CAREER ADD (
    POSITION_NAME  VARCHAR2(100),                           -- 직급 / 직위
    EMP_FORM       VARCHAR2(30),                            -- 근로형태 (정규직 / 계약직 / ...)
    LEAVE_REASON   VARCHAR2(500)                            -- 퇴사사유 (재직중이면 NULL)
);

COMMENT ON COLUMN TB_APP_CAREER.DEPT_POSITION IS '근무부서 (이전에는 부서/직위를 함께 적었다)';
COMMENT ON COLUMN TB_APP_CAREER.POSITION_NAME IS '직급 / 직위';
COMMENT ON COLUMN TB_APP_CAREER.EMP_FORM      IS '근로형태: 정규직 / 계약직 / 파견직 / 인턴 / 아르바이트 / 기타';
COMMENT ON COLUMN TB_APP_CAREER.LEAVE_REASON  IS '퇴사사유';

-- 3. 자격 / 어학 ---------------------------------------------------------------
ALTER TABLE TB_APP_CERT ADD (
    NOTE  VARCHAR2(500)                                     -- 특기사항
);

COMMENT ON COLUMN TB_APP_CERT.ISSUER IS '발행기관';
COMMENT ON COLUMN TB_APP_CERT.NOTE   IS '특기사항';

COMMIT;

--------------------------------------------------------------------------------
-- 확인 (모두 행이 나와야 한다: 학력 2, 경력 3, 자격 1)
--   SELECT TABLE_NAME, COLUMN_NAME FROM USER_TAB_COLUMNS
--    WHERE (TABLE_NAME = 'TB_APP_EDUCATION' AND COLUMN_NAME IN ('FINAL_YN', 'SCHOOL_LOCATION'))
--       OR (TABLE_NAME = 'TB_APP_CAREER'    AND COLUMN_NAME IN ('POSITION_NAME', 'EMP_FORM', 'LEAVE_REASON'))
--       OR (TABLE_NAME = 'TB_APP_CERT'      AND COLUMN_NAME = 'NOTE');
--
-- 되돌리기 (입력된 내용도 함께 사라진다)
--   ALTER TABLE TB_APP_EDUCATION DROP (FINAL_YN, SCHOOL_LOCATION);
--   ALTER TABLE TB_APP_CAREER    DROP (POSITION_NAME, EMP_FORM, LEAVE_REASON);
--   ALTER TABLE TB_APP_CERT      DROP (NOTE);
--------------------------------------------------------------------------------