--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 지원서별 조회 실패 잠금
--
-- 접수번호는 순번이라 짐작하기 쉬워서, IP 별 탐지만으로는 여러 IP 로 흩어 한 지원서의
-- 비밀번호를 계속 맞혀 보는 시도를 막지 못한다. 한 지원서에서 조회용 비밀번호를
-- 연속 5회 틀리면 15분간 그 지원서의 조회를 잠근다. (횟수 / 시간은 애플리케이션 상수)
--   LOGIN_FAIL_CNT : 연속 실패 횟수 (맞게 입력하거나 잠기면 0)
--   LOCK_UNTIL     : 이 시각까지 잠김 (NULL = 잠기지 않음)
--
-- ★ 순서: 새 애플리케이션을 배포하기 직전(또는 직후 바로)에 실행한다.
--   - 옛 애플리케이션은 이 열을 쓰지 않으므로 먼저 실행해도 동작이 달라지지 않는다 (DEFAULT 0).
--     → 가장 안전한 순서는 "이 스크립트 실행 → 새 애플리케이션 배포" 이다.
--   - 새 애플리케이션을 먼저 올리면 열이 없어서 조회 잠금이 동작하지 않고(경고 로그만 남고
--     조회는 계속된다) 비밀번호를 틀려도 잠기지 않는다.
--
-- 실행 : tbsql YSHR/비밀번호@tibero @27_application_login_lock.sql
--------------------------------------------------------------------------------

ALTER TABLE TB_APPLICATION ADD (
    LOGIN_FAIL_CNT  NUMBER(3)  DEFAULT 0 NOT NULL,
    LOCK_UNTIL      DATE
);

COMMENT ON COLUMN TB_APPLICATION.LOGIN_FAIL_CNT IS '조회용 비밀번호 연속 실패 횟수 (맞게 입력하거나 잠기면 0)';
COMMENT ON COLUMN TB_APPLICATION.LOCK_UNTIL     IS '이 시각까지 조회 잠김 (NULL 이면 잠기지 않음)';

--------------------------------------------------------------------------------
-- 확인
--   SELECT COLUMN_NAME, DATA_TYPE FROM USER_TAB_COLUMNS
--    WHERE TABLE_NAME = 'TB_APPLICATION' AND COLUMN_NAME IN ('LOGIN_FAIL_CNT', 'LOCK_UNTIL');
--   → 2건
--
-- 잠긴 지원서 풀기 (담당자가 지원자 요청을 받아 직접 풀 때)
--   UPDATE TB_APPLICATION SET LOGIN_FAIL_CNT = 0, LOCK_UNTIL = NULL WHERE APP_NO = 'A2026-000013-K7Q2';
--   COMMIT;
--   (관리자 화면의 '비밀번호 초기화' 를 쓰면 잠금도 함께 풀린다)
--
-- 조회할 때 휴대폰 인증번호 단계를 잠시 끄기 (문자 발송이 막혔을 때)
--   MERGE INTO TB_SECURITY_SETTING T USING (SELECT 'apply.lookup.otp' AS K FROM DUAL) S
--      ON (T.SETTING_KEY = S.K)
--    WHEN MATCHED THEN UPDATE SET SETTING_VALUE = 'N', UPDATED_BY = 'ops', UPDATED_DT = SYSDATE
--    WHEN NOT MATCHED THEN INSERT (SETTING_KEY, SETTING_VALUE, UPDATED_BY) VALUES (S.K, 'N', 'ops');
--   COMMIT;
--   다시 켜기: SETTING_VALUE 를 'Y' 로 (또는 행 삭제). 값이 없으면 인증을 요구한다.
--
-- 되돌리기
--   ALTER TABLE TB_APPLICATION DROP (LOGIN_FAIL_CNT, LOCK_UNTIL);
--------------------------------------------------------------------------------
