--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 관리자 권한 구분
--
-- 관리자 계정 관리 화면을 열면서 권한을 두 단계로 나눈다.
--
--   SUPER : 계정 관리까지 가능 (시스템 담당자)
--   ADMIN : 공고 / 공지 / FAQ / 지원자 업무만 가능 (채용 담당자)
--
-- 모든 관리자가 서로의 계정을 지울 수 있으면 사고 한 번에 복구가 어려워진다.
--
-- 실행 : tbsql YSHR/비밀번호@tibero @06_admin_role.sql
--------------------------------------------------------------------------------

-- 기존 계정은 모두 일반 관리자로 둔다.
UPDATE TB_ADMIN
   SET ROLE_CD = 'ADMIN'
 WHERE ROLE_CD IS NULL OR ROLE_CD NOT IN ('SUPER', 'ADMIN');

-- 최초 계정을 시스템 담당자로 올린다.
UPDATE TB_ADMIN
   SET ROLE_CD = 'SUPER'
 WHERE ADMIN_ID = 'admin';

COMMENT ON COLUMN TB_ADMIN.ROLE_CD IS 'SUPER(계정 관리 가능) / ADMIN(일반 업무)';

COMMIT;


--------------------------------------------------------------------------------
-- 확인
--
--   SELECT ADMIN_ID, ADMIN_NAME, ROLE_CD, USE_YN, FAIL_CNT FROM TB_ADMIN ORDER BY ADMIN_ID;
--
-- SUPER 계정이 최소 한 개는 있어야 한다. 애플리케이션은 마지막 SUPER 계정을
-- 지우거나 등급을 낮추는 것을 막지만, DB 에서 직접 바꾸면 막을 수 없다.
--------------------------------------------------------------------------------
