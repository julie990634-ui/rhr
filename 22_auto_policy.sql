-- ------------------------------------------------------------------------------
-- 자동 정책 설정 (수집 → 예고 → 적용 → 복원)
--
-- 마스터접근제어 > 정책관리 > 자동 정책 설정이 쓴다. 15 · 16 · 18 · 19 · 21 스크립트를 먼저 실행해야 한다.
--   TB_AUTO_POLICY_RUN   수집 세대 한 건. 마스터가 [자동 정책 시작]을 누르면 만들어지고
--                        COLLECTING(수집 중) → NOTICED(예고) → APPLIED(적용 완료) 로 흘러간다.
--                        CANCELLED 는 중단 또는 적용 취소(복원)이다. SNAPSHOT 에 적용 직전 상태를 담아 두어
--                        복원할 수 있다.
--   TB_AUTO_POLICY_PATH  수집 기간 동안 로그인 없이 호출된 경로의 집계 (호출마다 한 행씩 쓰지 않고, 서버 메모리에서
--                        모아 1분마다 합산해 저장한다).
--   TB_AUTO_POLICY_LOG   진행 내역 (시작, 예고, 적용, 복원, 재모니터링 종료).
--
-- 이 스크립트를 실행하지 않으면 자동 정책 설정 영역은 "테이블이 없다"는 안내를 보여 주고, 아무 것도 수집하거나
-- 적용하지 않는다. 자동 정책은 기본으로 꺼져 있으며 마스터가 시작해야만 동작한다.
-- ------------------------------------------------------------------------------
CREATE SEQUENCE SEQ_TB_AUTO_POLICY_RUN START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE TB_AUTO_POLICY_RUN (
    RUN_ID          NUMBER(10)      NOT NULL,
    STATE           VARCHAR2(12)    NOT NULL,
    STARTED_DT      DATE            DEFAULT SYSDATE NOT NULL,
    STARTED_BY      VARCHAR2(30),
    PERIOD_DAYS     NUMBER(4)       NOT NULL,
    NOTICE_DAYS     NUMBER(4)       NOT NULL,
    APPLY_MODE      VARCHAR2(6)     NOT NULL,
    BLOCK_UNUSED    CHAR(1)         DEFAULT 'N' NOT NULL,
    PLAN_DT         DATE,
    NOTICED_DT      DATE,
    APPLIED_DT      DATE,
    APPLIED_BY      VARCHAR2(30),
    CANCELLED_DT    DATE,
    CANCELLED_BY    VARCHAR2(30),
    REMONITOR_DONE  CHAR(1)         DEFAULT 'N' NOT NULL,
    SNAPSHOT        VARCHAR2(2000),
    PATHS_ADDED     NUMBER(6),
    PATHS_KEPT      NUMBER(6),
    EXC_SIGNAL      NUMBER(12),
    EXC_EXPIRED     NUMBER(12),
    EXC_ERROR       NUMBER(12),
    EXC_SCAN        NUMBER(12),
    GATES_ALLOW     NUMBER(4),
    GATES_LIMIT     NUMBER(4),
    GATES_BLOCK     NUMBER(4),
    CONSTRAINT PK_TB_AUTO_POLICY_RUN PRIMARY KEY (RUN_ID),
    CONSTRAINT CK_TB_AUTO_POLICY_STATE CHECK (STATE IN ('COLLECTING', 'NOTICED', 'APPLYING', 'APPLIED', 'CANCELLED')),
    CONSTRAINT CK_TB_AUTO_POLICY_MODE CHECK (APPLY_MODE IN ('AUTO', 'MANUAL'))
);

COMMENT ON TABLE  TB_AUTO_POLICY_RUN                IS '자동 정책 수집 세대';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.STATE          IS 'COLLECTING / NOTICED / APPLYING / APPLIED / CANCELLED';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.STARTED_DT     IS '수집 기준 시작 시각';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.PERIOD_DAYS    IS '수집 기간(일)';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.NOTICE_DAYS    IS '적용 며칠 전에 예고하는지';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.APPLY_MODE     IS 'AUTO(자동 적용) / MANUAL(마스터가 직접 적용)';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.BLOCK_UNUSED   IS '호출 이력이 없는 인증 관문을 적용 때 차단할지 (Y/N)';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.PLAN_DT        IS '적용 예정 시각';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.REMONITOR_DONE IS '적용 뒤 재모니터링 종료 안내를 남겼는지 (Y/N)';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.SNAPSHOT       IS '적용 직전 상태 (복원용)';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.PATHS_ADDED    IS '새로 등록한 개별 허용 경로 수';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.PATHS_KEPT     IS '이미 허용되어 있어 그대로 둔 경로 수';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.EXC_SIGNAL     IS '후보 제외: 공격 신호 출발지의 호출 수';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.EXC_EXPIRED    IS '후보 제외: 인증 요구로 돌려보낸 호출 수 (세션 만료)';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.EXC_ERROR      IS '후보 제외: 오류 응답 호출 수';
COMMENT ON COLUMN TB_AUTO_POLICY_RUN.EXC_SCAN       IS '후보 제외: 스캔으로 보이는 호출 수 (404, 지원하지 않는 경로 형식)';

CREATE TABLE TB_AUTO_POLICY_PATH (
    RUN_ID        NUMBER(10)     NOT NULL,
    REQ_PATH      VARCHAR2(300)  NOT NULL,
    OK_HITS       NUMBER(12)     DEFAULT 0 NOT NULL,
    ERR_HITS      NUMBER(12)     DEFAULT 0 NOT NULL,
    EXPIRED_HITS  NUMBER(12)     DEFAULT 0 NOT NULL,
    SIGNAL_HITS   NUMBER(12)     DEFAULT 0 NOT NULL,
    SCAN_HITS     NUMBER(12)     DEFAULT 0 NOT NULL,
    LAST_DT       DATE           DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_TB_AUTO_POLICY_PATH PRIMARY KEY (RUN_ID, REQ_PATH)
);

COMMENT ON TABLE  TB_AUTO_POLICY_PATH              IS '자동 정책 수집: 로그인 없이 호출된 경로 집계';
COMMENT ON COLUMN TB_AUTO_POLICY_PATH.REQ_PATH     IS '경로 (소문자, 숫자 구간은 /* 로 묶음)';
COMMENT ON COLUMN TB_AUTO_POLICY_PATH.OK_HITS      IS '정상 응답 호출 수';
COMMENT ON COLUMN TB_AUTO_POLICY_PATH.ERR_HITS     IS '오류 응답 호출 수 (404 제외)';
COMMENT ON COLUMN TB_AUTO_POLICY_PATH.EXPIRED_HITS IS '인증을 요구하며 돌려보낸 호출 수';
COMMENT ON COLUMN TB_AUTO_POLICY_PATH.SIGNAL_HITS  IS '공격 신호가 있는 출발지의 호출 수';
COMMENT ON COLUMN TB_AUTO_POLICY_PATH.SCAN_HITS    IS '스캔으로 보이는 호출 수 (404, 지원하지 않는 경로 형식)';

CREATE SEQUENCE SEQ_TB_AUTO_POLICY_LOG START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE TB_AUTO_POLICY_LOG (
    LOG_ID   NUMBER(12)     NOT NULL,
    RUN_ID   NUMBER(10)     NOT NULL,
    LOG_DT   DATE           DEFAULT SYSDATE NOT NULL,
    MESSAGE  VARCHAR2(500)  NOT NULL,
    CONSTRAINT PK_TB_AUTO_POLICY_LOG PRIMARY KEY (LOG_ID)
);

CREATE INDEX IDX_AUTO_POLICY_LOG_RUN ON TB_AUTO_POLICY_LOG (RUN_ID, LOG_DT);

COMMENT ON TABLE  TB_AUTO_POLICY_LOG         IS '자동 정책 진행 내역';
COMMENT ON COLUMN TB_AUTO_POLICY_LOG.MESSAGE IS '진행 내용';
