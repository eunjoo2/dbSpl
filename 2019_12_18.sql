   
--201912 : 35,첫주의 일요일:20190929,마지막 날짜:20191102
--일(1),월(2),화(3),수(4),목(5),금(6),토(7)


SELECT LDT - FDT +1
FROM
(SELECT LAST_DAY(TO_DATE (:yyyymm,'YYYYMM'))dt,
        
        LAST_DAY(TO_DATE (:yyyymm,'YYYYMM'))+
        7 - TO_CHAR(LAST_DAY(TO_DATE (:yyyymm,'YYYYMM')),'D')ldt,
        
        TO_DATE(:yyyymm, 'YYYYMM')-
        (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'),'D')-1)fdt
        
        FROM dual);
        
        

SELECT
    MAX(DECODE(d, 1, dt)) 일, MAX(DECODE(d, 2, dt)) 월, MAX(DECODE(d, 3, dt)) 화,
    MAX(DECODE(d, 4, dt)) 수, MAX(DECODE(d, 5, dt)) 목, MAX(DECODE(d, 6, dt)) 금, MAX(DECODE(d, 7, dt)) 토
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') - 
            (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D') -1) + (LEVEL - 1) dt,
            
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') - 
            (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D') -1) + (LEVEL - 1), 'D') d,
            
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') - 
            (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D') -1) + (LEVEL), 'IW') iw
            
    FROM dual
    CONNECT BY LEVEL <=(SELECT LDT-FDT +1
                        FROM  
                          (SELECT LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) dt,
                           LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) +
                           7 - TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'D') ldt,
                           TO_DATE(:yyyymm, 'YYYYMM') -
                           (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D') -1) fdt
                           FROM dual)))
    GROUP BY dt - (d - 1)
    ORDER BY dt - (d - 1);
    
--------학생 과제(박종민)


SELECT
    MAX(NVL(DECODE(d, 1, dt), dt - d + 1)) 일, MAX(NVL(DECODE(d, 2, dt), dt - d + 2)) 월, MAX(NVL(DECODE(d, 3, dt), dt - d + 3)) 화,
    MAX(NVL(DECODE(d, 4, dt), dt - d + 4)) 수, MAX(NVL(DECODE(d, 5, dt), dt - d + 5)) 목, MAX(NVL(DECODE(d, 6, dt), dt - d + 6)) 금, 
    MAX(NVL(DECODE(d, 7, dt), dt - d + 7)) 토
FROM
    (SELECT 
            TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1) dt,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL - 1), 'D') d,
            TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + (LEVEL), 'IW') iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
    GROUP BY dt - (d - 1)
    ORDER BY dt - (d - 1);
    
    
-------------------------------------------------------------
----실습1-2
SELECT dept_h.*,LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0' --시작점은 deptcd = 'dept0' --> xx회사 (최상위 조직)
CONNECT BY PRIOR deptcd= P_deptcd;



SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm,P_DEPTCD
FROM dept_h
START WITH deptcd = 'dept0_02' --시작점은 deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd= P_deptcd;

SELECT *
FROM dept_h;
-- 디자인팀 (dept0_00_0)을 기분으로 상향식 계층쿼리 작성
-- 자기 부서의 부모 부서와 연결을 한다.
--실습3
SELECT deptcd,LPAD(' ', (LEVEL-1)*3) || deptnm deptnm,P_DEPTCD
FROM dept_h
START WITH deptcd ='dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

SELECT deptcd,LPAD(' ', (LEVEL-1)*3) || deptnm deptnm,P_DEPTCD
FROM dept_h
START WITH deptcd ='dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd AND PRIOR deptnm LIKE '디자인%';

--조인 조건은 한컬럼에만 적용가능 한가
SELECT *
FROM tab_a,tab_b
WHERE tab_a.a = tab_b.

SELECT  LPAD('XX회사',15,'*')
        LPAD('XX회사',15,'*')
FROM dual;



/*
    dept0(xx회사)
        dept0_00(디자인부)
            dept0_00_0(디자인팀)
        dept0_01(정보기획부)
            dept0_01_0(기획팀)
                dept0_00_0_0(기획파트)
        dept0_02(정보시스템부)
            dept0_02_0(개발1팀)
            dept0_02_1(개발2팀)
            */

-----실습 4
SELECT*
FROM H_SUM;

SELECT LPAD(' ', (LEVEL-1)*4) || s_id s_id,VALUE
FROM H_SUM
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

------실습 5
SELECT*
FROM no_emp;

SELECT LPAD(' ', (LEVEL-1)*4) || org_cd org_cd ,no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;


-- pruning branch(가지치기)
-- 계층쿼리의 실행순서
-- FROM --> START WITH WITH ~ COMMECT BY __> WHERE
-- 조건을 COMMECT BY 절에 기술한 경우
-- . 조건에 따라 다음 ROW로 연결이 안되고 종료
-- 조건을 WHERE 절에 기술한 경울
-- . START WITH WITH ~ COMMECT BY 절에 의해 계층형을으로 나온 결과에
-- WHERE 절에 기술한 결과 값에 해당하는 데이터만 조회


-- 최상위 노드에서 하향식으로 탐색

-- CONNECT BY 절에 deptnm != '정보기획부'조건을 기술한 경우
SELECT LEVEL lv,deptcd,LPAD(' ', (LEVEL-1)*4) || deptnm deptnm,p_deptcd
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부';

-- WHERE 절에 deptnm != '정보기획부'조건을 기술한 경우
-- 계층 쿼리를 실행하고 나서 최종결과에 WHERE절 조건을 적용
SELECT *
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- 계층쿼리에서 사용가능한 특수 함수
-- CONNECT_BY_ROOT(col) 가장 최상위 row 의 col정보 값을 조회
SELECT deptcd,LPAD(' ', (LEVEL-1)*4) || deptnm deptnm,
        CONNECT_BY_ROOT(deptnm) c_root
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부';


-- 계층쿼리에서 사용가능한 특수 함수
-- CONNECT_BY_ROOT(col) 가장 최상위 row 의 col정보 값을 조회
-- SYS_CONNECT_BY_PATH(col,구분자) : 최상위 row에서 현재 로우까지 col값을
-- 구분자로 연결해준 문자열
--CONNECT_BY_ISLEAF : 해당 ROW가 마지막 노드인지(lesf Node)
SELECT deptcd,LPAD(' ', (LEVEL-1)*4) || deptnm deptnm,
        CONNECT_BY_ROOT(deptnm) c_root,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm,'-'),'-')sys_path,
        CONNECT_BY_ISLEAF isleaf
        
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부';

----실습6
SELECT *
FROM board_test;

SELECT SEQ,LPAD(' ', (LEVEL-1)*4) || TITLE TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER siblings by seq DESC;
---실습 7
SELECT SEQ,LPAD(' ', (LEVEL-1)*4) || TITLE TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER by seq DESC;

--실습 8
SELECT SEQ,LPAD(' ', (LEVEL-1)*4) || TITLE TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER siblings by seq DESC;
--실습8
SELECT SEQ,LPAD(' ', (LEVEL-1)*4) || TITLE TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER siblings by seq DESC;