--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 지원서 병역사항 세분화
--
-- 지원서에 '병역사항' 항목(학력사항 다음)을 따로 두고, 병역구분 외에 군별 / 계급 / 병과 /
-- 복무기간(년, 월)을 받는다. 병역구분은 기존 MILITARY_CD 컬럼을 그대로 쓴다.
--   병역구분 : 군필 / 미필 / 면제 / 의가사제대 / 의병제대   (예전 값 '해당없음' 도 그대로 읽힌다)
--
--   MILITARY_BRANCH : 군별   (직접 입력, 예: 육군)
--   MILITARY_RANK   : 계급   (직접 입력, 예: 병장)
--   MILITARY_SPEC   : 병과   (직접 입력, 예: 보병)
--   MILITARY_YEARS  : 복무기간 - 년
--   MILITARY_MONTHS : 복무기간 - 월
--
-- ★ 순서: 반드시 이 스크립트를 먼저 실행하고, 그 다음에 새 애플리케이션을 배포한다.
--   새 애플리케이션은 이 컬럼들을 지원서 조회에 쓰므로, 컬럼이 없는 상태로 배포하면
--   지원서 화면이 열리지 않는다. (옛 애플리케이션은 이 컬럼을 모르는 채로 정상 동작하므로
--   이 스크립트를 먼저 실행해 두는 것은 안전하다. 새 컬럼은 모두 NULL 허용이다.)
--
-- 실행 : tbsql YSHR/비밀번호@tibero @24_application_military.sql
--------------------------------------------------------------------------------

ALTER TABLE TB_APPLICATION ADD (
    MILITARY_BRANCH  VARCHAR2(50),      -- 군별
    MILITARY_RANK    VARCHAR2(50),      -- 계급
    MILITARY_SPEC    VARCHAR2(50),      -- 병과
    MILITARY_YEARS   NUMBER(2),         -- 복무기간 - 년
    MILITARY_MONTHS  NUMBER(2)          -- 복무기간 - 월
);

COMMENT ON COLUMN TB_APPLICATION.MILITARY_CD     IS '병역구분 (군필/미필/면제/의가사제대/의병제대)';
COMMENT ON COLUMN TB_APPLICATION.MILITARY_BRANCH IS '병역 - 군별';
COMMENT ON COLUMN TB_APPLICATION.MILITARY_RANK   IS '병역 - 계급';
COMMENT ON COLUMN TB_APPLICATION.MILITARY_SPEC   IS '병역 - 병과';
COMMENT ON COLUMN TB_APPLICATION.MILITARY_YEARS  IS '병역 - 복무기간(년)';
COMMENT ON COLUMN TB_APPLICATION.MILITARY_MONTHS IS '병역 - 복무기간(월)';

COMMIT;

--------------------------------------------------------------------------------
-- 확인
--   SELECT COLUMN_NAME, DATA_TYPE FROM USER_TAB_COLUMNS
--    WHERE TABLE_NAME = 'TB_APPLICATION' AND COLUMN_NAME LIKE 'MILITARY%';
--   → 6 행 (MILITARY_CD 포함) 이 나와야 한다.
--
-- 되돌리기 (입력된 병역 세부 정보도 함께 사라진다. 새 애플리케이션을 내린 뒤에 한다)
--   ALTER TABLE TB_APPLICATION DROP (MILITARY_BRANCH, MILITARY_RANK, MILITARY_SPEC,
--                                    MILITARY_YEARS, MILITARY_MONTHS);
--------------------------------------------------------------------------------
