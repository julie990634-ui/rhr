--------------------------------------------------------------------------------
-- 연세대학교 산학협력단 채용시스템 (RHR) - 샘플 데이터
-- 기존 rhr.yonsei.ac.kr 의 공개 목록을 기준으로 구성한 초기 데이터.
--
-- 실행 : tbsql YSHR/비밀번호@tibero @02_sample_data.sql
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 채용공고
--------------------------------------------------------------------------------
INSERT INTO TB_RECRUIT (RECRUIT_ID, TITLE, CONTENT, EMP_TYPE, DEPT_NAME, START_DT, END_DT, STEP_NAME, CLOSED_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_RECRUIT.NEXTVAL,
        '산학협력단 사업기반 계약직원(행정/앵커사업) 채용',
        '<h4>1. 모집분야</h4><p>산학협력단 앵커사업 행정 지원</p><h4>2. 자격요건</h4><p>학사 학위 이상 소지자</p><h4>3. 전형절차</h4><p>서류전형 &rarr; 면접전형 &rarr; 최종합격</p>',
        '계약직', '산학협력단', TO_DATE('2026-09-15','YYYY-MM-DD'), TO_DATE('2026-09-27','YYYY-MM-DD'),
        NULL, 'N', 'Y', 'admin');

INSERT INTO TB_RECRUIT (RECRUIT_ID, TITLE, CONTENT, EMP_TYPE, DEPT_NAME, START_DT, END_DT, STEP_NAME, CLOSED_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_RECRUIT.NEXTVAL,
        '2026학년도 하반기 산학협력단 정규직원(행정) 채용',
        '<h4>1. 모집분야</h4><p>산학협력단 행정 정규직원</p><h4>2. 자격요건</h4><p>학사 학위 이상 소지자로 결격사유가 없는 자</p><h4>3. 전형절차</h4><p>서류전형 &rarr; 인적성검사 &rarr; 면접전형 &rarr; 최종합격</p>',
        '정규직', '산학협력단', TO_DATE('2026-09-01','YYYY-MM-DD'), TO_DATE('2026-09-18','YYYY-MM-DD'),
        NULL, 'N', 'Y', 'admin');

INSERT INTO TB_RECRUIT (RECRUIT_ID, TITLE, CONTENT, EMP_TYPE, DEPT_NAME, START_DT, END_DT, STEP_NAME, CLOSED_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_RECRUIT.NEXTVAL,
        '[기간연장] 2026년 하반기 산학협력단 정규직원(분석) 채용',
        '<h4>1. 모집분야</h4><p>연구장비 분석 담당 정규직원</p><h4>2. 진행현황</h4><p>현재 2단계 인적성검사가 진행 중입니다.</p>',
        '정규직', '연구장비지원센터', TO_DATE('2026-07-01','YYYY-MM-DD'), TO_DATE('2026-08-14','YYYY-MM-DD'),
        '2단계-인적성검사', 'N', 'Y', 'admin');

INSERT INTO TB_RECRUIT (RECRUIT_ID, TITLE, CONTENT, EMP_TYPE, DEPT_NAME, START_DT, END_DT, STEP_NAME, CLOSED_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_RECRUIT.NEXTVAL,
        '연세대학교산학협력단 계약직원(행정) 채용',
        '<h4>1. 모집분야</h4><p>산학협력단 행정 계약직원</p><h4>2. 전형절차</h4><p>서류전형 &rarr; 면접전형</p>',
        '계약직', '산학협력단', TO_DATE('2026-05-02','YYYY-MM-DD'), TO_DATE('2026-05-20','YYYY-MM-DD'),
        NULL, 'Y', 'Y', 'admin');

INSERT INTO TB_RECRUIT (RECRUIT_ID, TITLE, CONTENT, EMP_TYPE, DEPT_NAME, START_DT, END_DT, STEP_NAME, CLOSED_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_RECRUIT.NEXTVAL,
        '2026학년도 산학협력단 정규직원(행정) 채용',
        '<h4>1. 모집분야</h4><p>산학협력단 행정 정규직원</p><h4>2. 전형절차</h4><p>서류전형 &rarr; 인적성검사 &rarr; 면접전형 &rarr; 최종합격</p>',
        '정규직', '산학협력단', TO_DATE('2026-02-10','YYYY-MM-DD'), TO_DATE('2026-02-28','YYYY-MM-DD'),
        NULL, 'Y', 'Y', 'admin');

-- 접수 예정 공고 (상태 표시 확인용)
INSERT INTO TB_RECRUIT (RECRUIT_ID, TITLE, CONTENT, EMP_TYPE, DEPT_NAME, START_DT, END_DT, STEP_NAME, CLOSED_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_RECRUIT.NEXTVAL,
        '2027학년도 상반기 산학협력단 인턴 채용 (예정)',
        '<p>세부 모집요강은 접수 시작일에 공개됩니다.</p>',
        '인턴', '산학협력단', TO_DATE('2026-12-01','YYYY-MM-DD'), TO_DATE('2026-12-20','YYYY-MM-DD'),
        NULL, 'N', 'Y', 'admin');


--------------------------------------------------------------------------------
-- 공지사항
--------------------------------------------------------------------------------
INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '자기소개서 작성시 AI 도구 사용 금지',
        '<p>자기소개서 작성 시 생성형 AI 도구의 사용을 금지합니다. 표절 검증 과정에서 AI 작성이 확인될 경우 불합격 처리될 수 있습니다.</p>',
        TO_DATE('2025-07-23','YYYY-MM-DD'), 'Y', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '교내 정전 작업으로 인한 시스템 중단 안내 (8.16 오후9시 ~ 8.17 오전8시)',
        '<p>교내 정전 작업으로 아래 기간 동안 채용시스템 이용이 중단됩니다.</p><p><strong>중단 기간 : 8월 16일(금) 21:00 ~ 8월 17일(토) 08:00</strong></p>',
        TO_DATE('2019-08-01','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '2019년도 청년 TLO 육성사업 2차 모집 안내',
        '<p>2019년도 청년 TLO 육성사업 2차 모집을 아래와 같이 진행합니다.</p>',
        TO_DATE('2019-05-30','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '청년TLO 육성사업 참여 자격 (졸업생, 수료생) 관련 안내',
        '<p>청년TLO 육성사업 참여 자격에 대한 안내입니다. 졸업생 및 수료생의 참여 가능 여부를 확인하시기 바랍니다.</p>',
        TO_DATE('2019-02-07','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '육아휴직 대체자 채용 지원기간 연장 안내',
        '<p>육아휴직 대체자 채용의 지원 기간이 연장되었습니다.</p>',
        TO_DATE('2018-06-08','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '2017학년도 제2차 직원채용 서류전형 결과 발표',
        '<p>2017학년도 제2차 직원채용 서류전형 결과를 발표합니다. 합격자에게는 개별 안내드립니다.</p>',
        TO_DATE('2017-11-17','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '제2차 직원 채용 진행 안내 (서류 전형 진행 중)',
        '<p>제2차 직원 채용의 서류 전형이 진행 중입니다.</p>',
        TO_DATE('2017-11-06','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '첨부파일 오류시 조치방법',
        '<p>첨부파일 업로드 오류 발생 시 브라우저 캐시를 삭제한 후 재시도하시기 바랍니다.</p>',
        TO_DATE('2017-10-24','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '마감일정 변경 (2017.10.26)',
        '<p>채용 마감 일정이 2017년 10월 26일로 변경되었습니다.</p>',
        TO_DATE('2017-10-13','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '첨부 파일 에러 관련 안내',
        '<p>첨부 파일 관련 오류에 대한 안내입니다.</p>',
        TO_DATE('2016-12-23','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '입사지원 시작일 안내',
        '<p>입사지원 시작일을 안내드립니다.</p>',
        TO_DATE('2016-12-16','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '2017학년도 제1차 산학협력단 직원 채용 안내',
        '<p>2017학년도 제1차 산학협력단 직원 채용을 안내드립니다.</p>',
        TO_DATE('2017-04-14','YYYY-MM-DD'), 'N', 'Y', 'admin');

INSERT INTO TB_NOTICE (NOTICE_ID, TITLE, CONTENT, NOTICE_DT, TOP_YN, USE_YN, REG_ID)
VALUES (SEQ_TB_NOTICE.NEXTVAL, '채용일정 안내',
        '<p>채용 일정을 안내드립니다.</p>',
        TO_DATE('2016-12-21','YYYY-MM-DD'), 'N', 'Y', 'admin');


--------------------------------------------------------------------------------
-- 자주하는질문
--------------------------------------------------------------------------------
INSERT INTO TB_FAQ (FAQ_ID, CATEGORY, QUESTION, ANSWER, SORT_NO, USE_YN, REG_ID)
VALUES (SEQ_TB_FAQ.NEXTVAL, '지원방법', '입사지원은 어떻게 하나요?',
        '<p>채용공고 상세 페이지의 안내에 따라 온라인으로 지원하시면 됩니다. 접수 마감일 18:00 이후에는 지원이 불가합니다.</p>',
        1, 'Y', 'admin');

INSERT INTO TB_FAQ (FAQ_ID, CATEGORY, QUESTION, ANSWER, SORT_NO, USE_YN, REG_ID)
VALUES (SEQ_TB_FAQ.NEXTVAL, '지원방법', '한 번에 여러 공고에 지원할 수 있나요?',
        '<p>동일 채용 회차 내에서는 1개 분야에만 지원 가능합니다. 중복 지원 시 모두 무효 처리됩니다.</p>',
        2, 'Y', 'admin');

INSERT INTO TB_FAQ (FAQ_ID, CATEGORY, QUESTION, ANSWER, SORT_NO, USE_YN, REG_ID)
VALUES (SEQ_TB_FAQ.NEXTVAL, '지원방법', '지원서를 제출한 뒤에 수정할 수 있나요?',
        '<p>접수 기간 중에는 수정이 가능합니다. 다만 접수 마감 이후에는 어떠한 경우에도 수정이 불가합니다.</p>',
        3, 'Y', 'admin');

INSERT INTO TB_FAQ (FAQ_ID, CATEGORY, QUESTION, ANSWER, SORT_NO, USE_YN, REG_ID)
VALUES (SEQ_TB_FAQ.NEXTVAL, '서류', '자기소개서 작성 시 AI 도구를 사용해도 되나요?',
        '<p>사용을 금지합니다. 표절 검증 과정에서 생성형 AI 작성이 확인될 경우 불합격 처리될 수 있습니다.</p>',
        1, 'Y', 'admin');

INSERT INTO TB_FAQ (FAQ_ID, CATEGORY, QUESTION, ANSWER, SORT_NO, USE_YN, REG_ID)
VALUES (SEQ_TB_FAQ.NEXTVAL, '서류', '첨부파일 업로드가 되지 않습니다.',
        '<p>파일 용량(최대 10MB)과 확장자(pdf, hwp, doc, docx, jpg, png)를 확인해 주세요. 그래도 실패한다면 브라우저 캐시를 삭제한 후 재시도하시기 바랍니다.</p>',
        2, 'Y', 'admin');

INSERT INTO TB_FAQ (FAQ_ID, CATEGORY, QUESTION, ANSWER, SORT_NO, USE_YN, REG_ID)
VALUES (SEQ_TB_FAQ.NEXTVAL, '서류', '졸업증명서는 언제 제출하나요?',
        '<p>서류전형 합격자에 한해 면접 시 원본을 지참하여 제출하시면 됩니다.</p>',
        3, 'Y', 'admin');

INSERT INTO TB_FAQ (FAQ_ID, CATEGORY, QUESTION, ANSWER, SORT_NO, USE_YN, REG_ID)
VALUES (SEQ_TB_FAQ.NEXTVAL, '전형', '전형 결과는 어떻게 확인하나요?',
        '<p>각 전형 단계별 결과는 채용시스템 공지사항 게시 및 개별 통지로 안내드립니다.</p>',
        1, 'Y', 'admin');

INSERT INTO TB_FAQ (FAQ_ID, CATEGORY, QUESTION, ANSWER, SORT_NO, USE_YN, REG_ID)
VALUES (SEQ_TB_FAQ.NEXTVAL, '전형', '불합격 사유를 알려주시나요?',
        '<p>개별 전형 결과에 대한 사유는 안내해 드리지 않습니다.</p>',
        2, 'Y', 'admin');

INSERT INTO TB_FAQ (FAQ_ID, CATEGORY, QUESTION, ANSWER, SORT_NO, USE_YN, REG_ID)
VALUES (SEQ_TB_FAQ.NEXTVAL, '기타', '채용 관련 문의는 어디로 하나요?',
        '<p>연세대학교 산학협력단 인사담당으로 문의하시기 바랍니다.</p>',
        1, 'Y', 'admin');

INSERT INTO TB_FAQ (FAQ_ID, CATEGORY, QUESTION, ANSWER, SORT_NO, USE_YN, REG_ID)
VALUES (SEQ_TB_FAQ.NEXTVAL, '기타', '지원 시 제출한 개인정보는 어떻게 처리되나요?',
        '<p>개인정보처리방침에 따라 채용 목적으로만 이용되며, 보유 기간 경과 후 지체 없이 파기합니다.</p>',
        2, 'Y', 'admin');


COMMIT;
