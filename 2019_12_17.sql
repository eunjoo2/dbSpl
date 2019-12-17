--WITH
--WITH 블로 이름 AS (
-- 서브쿼리
-- )
--SELECT *
--FROM 블록이름

--deptno, avg(sal) avg_sal
--해당 부서의 급여평균이 전제 직원의 평균보다 놓은 부서에 한해 조회
SELECT deptno, avg(sal) avg_sal
FROM emp
GROUP BY deptno
HAVING avg(sal)> (SELECT avg(sal) FROM emp);

--WITH 절을 사용하여 위의 쿼리를 작성
WITH dept_sal_avg AS(
        SELECT deptno, avg(sal) avg_sal
        FROM emp
        GROUP BY deptno),
        emp_sal_avg AS(
        SELECT avg(sal) avg_sal FROM emp
        )
SELECT * 
FROM dept_sal_avg
WHERE avg_sal > (SELECT avg_sal FROM emp_sal_avg);

WITH test AS(
    SELECT 1, 'TEST' FROM DUAL UNION ALL
    SELECT 2, 'TEST2' FROM DUAL UNION ALL
    SELECT 3, 'TEST3' FROM DUAL )
SELECT *
FROM test;

--계층쿼리
--달력만들기
--CONNECT BY LEVEL <= N
--테이블의 ROW 건수를 N만큼 반복한다.
-- CONNECT BY LEVEL 절을 사용한 쿼리에서는 
--SELCET 절에서 LEVEL 이라는 특수 컬럼을 사용할 수 있다.
--계층을 표현하는 특수 컬럼으로 1부터 증가하며 ROWNUM과 유사하나 추후
--배우게 될 START WITH, CONNECT BY 절에서 다른 점을 배우게 된다.

--2019년 11월은 30일 까지 존재
--201911
--일자 + 정수 = 정수만큼 미래의 일자
--201911 --> 해당년월의 날짜가 몇일까지 존재 하는가??
SELECT  /*dt,d,iw,dt(d-1),*/
        /*일요일이면 날짜*//*화요일이면 날짜*//*토요일이면 날짜*/
        MAX(DECODE(d, 1,dt))sun,MAX(DECODE(d, 2,dt))mon,MAX(DECODE(d, 3,dt))tue,
        MAX(DECODE(d, 4,dt))wed,MAX(DECODE(d, 5,dt))thu,MAX(DECODE(d, 6,dt))fir,MAX(DECODE(d, 7,dt))sat

FROM
        (SELECT TO_DATE (:yyyymm,'YYYYMM')+(LEVEL-1) dt,
                TO_CHAR(TO_DATE (:yyyymm,'YYYYMM')+(LEVEL-1),'D')d,
                TO_CHAR(TO_DATE (:yyyymm,'YYYYMM')+(LEVEL),'IW')iw
        
        FROM dual
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')), 'dd'))         
GROUP BY dt-(d-1)
ORDER BY dt-(d-1);

------------------------------------학생(지선)------------------------------------------------------

SELECT  iw,
        /*일요일이면 날짜*//*화요일이면 날짜*//*토요일이면 날짜*/
        MAX(DECODE(d, 1,dt))sun,MAX(DECODE(d, 2,dt))mon,MAX(DECODE(d, 3,dt))tue,
        MAX(DECODE(d, 4,dt))wed,MAX(DECODE(d, 5,dt))thu,MAX(DECODE(d, 6,dt))fir,MAX(DECODE(d, 7,dt))sat

FROM
        (SELECT TO_DATE (:yyyymm,'YYYYMM')+(LEVEL-1) dt,
                TO_CHAR(TO_DATE (:yyyymm,'YYYYMM')+(LEVEL-1),'D')d,
                TO_CHAR(TO_DATE (:yyyymm,'YYYYMM')+(LEVEL),'IW')iw
        
        FROM dual
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')), 'dd'))         
GROUP BY iw
ORDER BY sat;

--------------실습

SELECT  iw,
        /*일요일이면 날짜*//*화요일이면 날짜*//*토요일이면 날짜*/
        MAX(DECODE(d, 1,dt))sun,MAX(DECODE(d, 2,dt))mon,MAX(DECODE(d, 3,dt))tue,
        MAX(DECODE(d, 4,dt))wed,MAX(DECODE(d, 5,dt))thu,MAX(DECODE(d, 6,dt))fir,MAX(DECODE(d, 7,dt))sat


FROM
        (SELECT TO_DATE ('201905','YYYYMM')+(LEVEL-1) dt,
                TO_CHAR(TO_DATE ('201905','YYYYMM')+(LEVEL-1),'D')d,
                TO_CHAR(TO_DATE ('201905','YYYYMM')+(LEVEL),'IW')iw
        
        FROM dual
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('201905','yyyymm')), 'dd'))         
GROUP BY iw
ORDER BY sat;



--------달력만들기 복습
SELECT 
        NVL(MIN(DECODE(mm, '01', sales_sum)),0) JAN, NVL(MIN(DECODE(mm, '02',sales_sum)),0) f,
        NVL(MIN(DECODE(mm, '03', sales_sum)),0) MAR, NVL(MIN(DECODE(mm, '04',sales_sum)),0) a,
        NVL(MIN(DECODE(mm, '05', sales_sum)),0) MAY, NVL(MIN(DECODE(mm, '06',sales_sum)),0) j
       
FROM    
        (SELECT TO_CHAR(DT,'mm')mm,SUM(sales) sales_sum
        FROM sales
        GROUP BY TO_CHAR(DT,'mm')
        );

SELECT dept_h.*,LEVER
FROM dept_h
START WITH deptcd = 'dept0' --시작점은 deptcd = 'dept0' --> xx회사 (최상위 조직)
CONNECT BY PRIOR deptcd= P_deptcd
;

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