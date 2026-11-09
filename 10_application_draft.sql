-- ------------------------------------------------------------------------------
-- 지원서 임시저장
--
-- 지원자가 다 채우지 않고 중간에 저장해 두었다가 나중에 이어서 쓸 수 있게 한다.
-- STATUS 에 'DRAFT' 값을 새로 쓴다 (컬럼 자체에 CHECK 제약이 없어 스키마 변경은
-- 필요 없다). 임시저장 상태에서는 생년월일 / 이메일도 비어 있을 수 있으므로
-- NOT NULL 제약을 없앤다. 최종제출 시점에는 애플리케이션 쪽 검증이 두 값을
-- 그대로 필수로 요구하므로 데이터 품질에는 영향이 없다.
-- ------------------------------------------------------------------------------
ALTER TABLE TB_APPLICATION MODIFY (BIRTH_DT NULL);
ALTER TABLE TB_APPLICATION MODIFY (EMAIL NULL);

COMMENT ON COLUMN TB_APPLICATION.STATUS IS 'DRAFT(임시저장) / RECEIVED / SCREENING / PASSED / FAILED';
