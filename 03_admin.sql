--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 관리자 계정
--
-- 실행 : tbsql YSHR/비밀번호@tibero @03_admin.sql
--------------------------------------------------------------------------------

CREATE TABLE TB_ADMIN (
    ADMIN_ID       VARCHAR2(50)    NOT NULL,           -- 로그인 아이디
    ADMIN_NAME     VARCHAR2(100)   NOT NULL,           -- 담당자 이름
    PASSWORD       VARCHAR2(300)   NOT NULL,           -- pbkdf2$반복수$솔트$해시
    ROLE_CD        VARCHAR2(20)    DEFAULT 'ADMIN' NOT NULL,
    USE_YN         CHAR(1)         DEFAULT 'Y' NOT NULL, -- 계정 사용 여부
    FAIL_CNT       NUMBER(3)       DEFAULT 0  NOT NULL, -- 연속 로그인 실패 횟수
    LAST_LOGIN_DT  DATE,                               -- 마지막 로그인 시각
    REG_DT         DATE            DEFAULT SYSDATE NOT NULL,
    UPD_DT         DATE,
    CONSTRAINT PK_TB_ADMIN PRIMARY KEY (ADMIN_ID)
);

COMMENT ON TABLE  TB_ADMIN               IS '관리자 계정';
COMMENT ON COLUMN TB_ADMIN.ADMIN_ID      IS '로그인 아이디';
COMMENT ON COLUMN TB_ADMIN.ADMIN_NAME    IS '담당자 이름';
COMMENT ON COLUMN TB_ADMIN.PASSWORD      IS 'PBKDF2 해시 (평문 저장 금지)';
COMMENT ON COLUMN TB_ADMIN.USE_YN        IS '계정 사용 여부';
COMMENT ON COLUMN TB_ADMIN.FAIL_CNT      IS '연속 로그인 실패 횟수. 5회가 되면 잠김';
COMMENT ON COLUMN TB_ADMIN.LAST_LOGIN_DT IS '마지막 로그인 시각';


--------------------------------------------------------------------------------
-- 초기 계정
--
-- 비밀번호를 이 스크립트(버전관리에 들어간다)에 평문이나 고정 해시로 남기지
-- 않는다. 실행하는 사람이 직접 비밀번호를 정해 해시를 만들고, 아래 INSERT 의
-- <해시> 자리에 그 결과를 붙여 넣는다 (10자 이상, 영문·숫자·특수문자 모두 포함).
--
--   java -cp target/classes kr.ac.yonsei.rhr.common.PasswordEncoder "정한비밀번호"
--
-- 해시는 계정마다 다른 난수 솔트를 쓰므로, 같은 비밀번호라도 실행할 때마다
-- 결과 문자열이 달라지는 것이 정상이다. 아이디는 admin, 로그인 후에는
-- /admin/password.do 에서 비밀번호를 한 번 더 바꾸는 것을 권장한다.
--------------------------------------------------------------------------------
INSERT INTO TB_ADMIN (ADMIN_ID, ADMIN_NAME, PASSWORD, ROLE_CD, USE_YN, FAIL_CNT)
VALUES ('admin', '채용담당자',
        '<PasswordEncoder 로 만든 해시를 여기에 붙여 넣는다>',
        'ADMIN', 'Y', 0);


COMMIT;
