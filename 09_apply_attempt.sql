-- ------------------------------------------------------------------------------
-- 지원 시도 기록
--
-- 휴대폰 인증까지 마치고 지원서 작성 화면에 들어온 사람을 "지원자수"로 센다.
-- 실제로 끝까지 제출했는지는 TB_APPLICATION 건수로 따로 센다(최종제출자수).
-- 같은 사람이 같은 공고에 여러 번 다시 들어와도 한 번만 세지도록
-- (RECRUIT_ID, PHONE) 을 기본키로 둔다.
-- ------------------------------------------------------------------------------
CREATE TABLE TB_APPLY_ATTEMPT (
    RECRUIT_ID  NUMBER(10)      NOT NULL,
    PHONE       VARCHAR2(30)    NOT NULL,
    FIRST_DT    DATE            DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_TB_APPLY_ATTEMPT PRIMARY KEY (RECRUIT_ID, PHONE),
    CONSTRAINT FK_TB_APPLY_ATTEMPT_RCT FOREIGN KEY (RECRUIT_ID)
        REFERENCES TB_RECRUIT (RECRUIT_ID) ON DELETE CASCADE
);

COMMENT ON TABLE TB_APPLY_ATTEMPT IS '지원 시도(휴대폰 인증 완료) 기록 - 총 지원자수 집계용';
COMMENT ON COLUMN TB_APPLY_ATTEMPT.RECRUIT_ID IS '채용공고 번호';
COMMENT ON COLUMN TB_APPLY_ATTEMPT.PHONE      IS '인증을 마친 휴대전화 번호';
COMMENT ON COLUMN TB_APPLY_ATTEMPT.FIRST_DT   IS '처음 인증에 성공한 시각';
