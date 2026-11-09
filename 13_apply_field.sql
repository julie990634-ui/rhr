--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 지원분야
--
-- 관리자가 채용공고를 만들 때 '지원분야' 목록(한 줄에 하나)을 적어 두면, 지원자는 지원서의 성명 옆에서
-- 그중 하나를 고른다. 지원서에는 고른 이름을 그대로 복사해 둔다(나중에 공고의 목록을 고쳐도 이미 낸
-- 지원서의 지원분야는 바뀌지 않는다). 목록을 비워 둔 공고는 지원서에 지원분야 칸이 나타나지 않는다.
--
-- 기존 공고 / 지원서는 건드리지 않는다. 새 컬럼은 모두 NULL 허용이다.
--
-- ★ 순서: 반드시 이 스크립트를 먼저 실행하고, 그 다음에 새 애플리케이션을 배포한다.
--
-- 실행 : tbsql YSHR/비밀번호@tibero @13_apply_field.sql
--------------------------------------------------------------------------------

ALTER TABLE TB_RECRUIT ADD (FIELD_LIST VARCHAR2(2000));
ALTER TABLE TB_APPLICATION ADD (APPLY_FIELD VARCHAR2(100));

COMMENT ON COLUMN TB_RECRUIT.FIELD_LIST      IS '지원분야 목록 (한 줄에 하나, 줄바꿈 구분). 비어 있으면 지원분야를 받지 않는다.';
COMMENT ON COLUMN TB_APPLICATION.APPLY_FIELD IS '지원분야 (지원 당시 공고의 지원분야 이름을 복사해 둔 값)';

COMMIT;

--------------------------------------------------------------------------------
-- 확인 (2 행)
--   SELECT TABLE_NAME, COLUMN_NAME FROM USER_TAB_COLUMNS
--    WHERE (TABLE_NAME = 'TB_RECRUIT' AND COLUMN_NAME = 'FIELD_LIST')
--       OR (TABLE_NAME = 'TB_APPLICATION' AND COLUMN_NAME = 'APPLY_FIELD');
--
-- 되돌리기 (입력된 내용도 함께 사라진다)
--   ALTER TABLE TB_RECRUIT DROP (FIELD_LIST);
--   ALTER TABLE TB_APPLICATION DROP (APPLY_FIELD);
--------------------------------------------------------------------------------