--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 한 공고에는 같은 휴대전화로 한 번만 지원
--
-- 지금까지 같은 공고의 중복 지원은 "성명 + 생년월일" (UK_TB_APPLICATION_DUP) 로만 막았다.
-- 이제는 애플리케이션이 "같은 휴대전화 번호"도 중복으로 보고 막는다.
-- 이 스크립트는 같은 규칙을 DB 에서도 보장하는 UNIQUE 제약이다. (두 사람이 동시에 제출하는
-- 경우처럼 애플리케이션 검사를 비껴가는 순간까지 막아 준다.)
--
-- ★ 이 스크립트는 "선택" 이다. 애플리케이션만 배포해도 중복 지원은 막힌다.
--   이미 같은 공고에 같은 번호로 낸 지원서가 있으면 제약을 만들 수 없다(ORA 중복 오류).
--   그때는 아래 [1] 조회로 중복 건을 먼저 확인해 정리한 뒤 다시 실행한다. 이미 들어 있는 데이터는
--   바뀌지 않으므로 오류가 나도 서비스에는 영향이 없다.
--
-- 실행 : tbsql YSHR/비밀번호@tibero @26_application_phone_unique.sql
--------------------------------------------------------------------------------

-- [1] 같은 공고에 같은 번호로 낸 지원서 (결과가 0건이어야 아래 제약을 만들 수 있다)
SELECT RECRUIT_ID, PHONE, COUNT(*) AS CNT
  FROM TB_APPLICATION
 GROUP BY RECRUIT_ID, PHONE
HAVING COUNT(*) > 1;

-- [2] 제약 추가
ALTER TABLE TB_APPLICATION
  ADD CONSTRAINT UK_TB_APPLICATION_PHONE UNIQUE (RECRUIT_ID, PHONE);

--------------------------------------------------------------------------------
-- 확인
--   SELECT CONSTRAINT_NAME FROM USER_CONSTRAINTS
--    WHERE TABLE_NAME = 'TB_APPLICATION' AND CONSTRAINT_NAME = 'UK_TB_APPLICATION_PHONE';
--
-- 되돌리기
--   ALTER TABLE TB_APPLICATION DROP CONSTRAINT UK_TB_APPLICATION_PHONE;
--------------------------------------------------------------------------------
