--실습 1 emp 테이블을 이용하여 deptno에 따라 부서명을 변경해서 다음과 같이 조회되는 쿼리를 작성하세요.

SELECT EMPNO ,ENAME,
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
    
FROM emp;

SELECT 
    DECODE(deptno,  10,'ACCOUNTING'
                    20,'RESEARCH'
                    30,'SALES'
                    40,'OPERATIONS'
FROM emp;
----실습 2 emp 테이블을 이용하여 hiredate 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
--(생년을 기준으로 하나 여기서는 hiredate를 기준으로 한다.)
--1. TO_CHAR(SYSDATE, 'YYYY')
--> 올해년도 구분( 0:짝수년, 1:홀수년)


SELECT empno, ename, hiredate,
        CASE
            WHEN     MOD(TO_NUMBER(TO_CHAR(hiredate, 'yy')), 2) = 1
            
            THEN '건강검진 대상자'        
            ELSE '건강검진 비대상자'
        END CONTACT_TO_DOCTOR
FROM emp;
--내년도(2020) 건강검진 대상자를 조회하는 쿼리를 작성해보세요.

SELECT empno, ename, hiredate,
        CASE
            WHEN    MOD(TO_NUMBER(TO_CHAR(hiredate,'yy')), 2) =
                    MOD(TO_CHAR(TO_DATE('2020','YYYY'),'YY'),2) --MOD(2020,2)/(SYSDATE,'YYYY')+1
            THEN '건겅검진 대상자'
            ELSE '건간검진 비대상자'
        END contact_to_doctor
FROM emp;

--실습 3 emp 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
--(생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다.)

SELECT userid, usernm, alias, reg_dt,
    CASE
        WHEN reg_dt IN NULL THEN '건강검진 비대상자'
        ELSE '건강검진 대상자'
        
    END CONTACTTODOCTOR
    
FROM users;

SELECT userid, usernm, alias, reg_dt,
        CASE
        WHEN    MOD (TO_CHAR(reg_dt,'YYYY'), 2)
                = MOD (TO_CHAR(SYSDATE,'YYYY'),2)
            THEN'건강검진 대상자'
            ELSE'건강검진 비대상자'
        END CONTACT_TO_DOCTOR
        
FROM users;

--GROUP FUNCTION
--특정 컬럼이나, 표현을 기준으로 여러행의 값을 한행의 결과로 생성
--COUNT-건수,SUM-합계,AVG-평균,MAX-최대값,MIN-최소값
--전체 직원을 대상으로

SELECT  MAX(sal) max_sal       --가장 높은 급여
        ,MIN(sal) min_sal       --가장 남은 급여
        ,ROUND(AVG(sal), 2) avg_sal --전 직원의 급여 평균
        ,SUM(sal) sum_sal       --전 직원의 급여 합계
        ,COUNT(sal) count_sal   --급여 건수(null이 아닌 값이면 1건)
        ,COUNT(mgr) count_mgr   --직원의 관리자 건수(KING의 경우 MGR가 없다)
        ,COUNT(*) count_row ---------특정 컬럽의 건수가 아니라 행의 갯수를 알고 싶을때 사용
        
FROM emp;

--부서번호별 그룹함수 적용

SELECT  deptno
        ,MAX(sal) max_sal       --부서에서 가장 높은 급여
        ,MIN(sal) min_sal       --부서에서 가장 남은 급여
        ,ROUND(AVG(sal), 2) avg_sal --부서 직원의 급여 평균
        ,SUM(sal) sum_sal       --부서 직원의 급여 합계
        ,COUNT(sal) count_sal   --부서 급여 건수(null이 아닌 값이면 1건)
        ,COUNT(mgr) count_mgr   --부서 직원의 관리자 건수(KING의 경우 MGR가 없다)
        ,COUNT(*) count_row      --부서의 조직원수
        

FROM emp
GROUP BY depno;

--SELECT 절에는 GROUP BY 절에 표현된 컬럼 이외의 컬림이 올 수 없다.
--논리적으로 성립이 되지 않음(여러명의 직원 정보를 한건의 데이터로 그루핑
--단, 예외적으로 상수값들은 SELECT절에 표현이 가능하다
SELECT  deptno, STSDATE 
        ,MAX(sal) max_sal       --가장 높은 급여
        ,MIN(sal) min_sal       --가장 남은 급여
        ,ROUND(AVG(sal), 2) avg_sal --전 직원의 급여 평균
        ,SUM(sal) sum_sal       --전 직원의 급여 합계
        ,COUNT(sal) count_sal   --급여 건수(null이 아닌 값이면 1건)
        ,COUNT(mgr) count_mgr   --직원의 관리자 건수(KING의 경우 MGR가 없다)
        ,COUNT(*) count_row ---------특정 컬럽의 건수가 아니라 행의 갯수를 알고 싶을때 사용
        
FROM emp
GROUP BY depno;

--그룹함수에서는 NULL 컬럼은 계산이 제외된다
--emp테이블에서 comm컬럼이 null이 아닌 데이터는 4건이 존대, 9건은 ㅜㅕㅣㅣ)
SELECT  COUNT(comm) count_comm
        ,SUM(comm) sum_comm
        ,SUM(sal) sum_sal
        ,SUM(sal + comm) tot_sal_sum
        ,SUM(sal + NVL(comm,0)) tot_sal_sum
FROM emp;

--WHERE 절에느 GROUP 함수를 표현 할 수 없다.
--부서별 최대 급여 구하기
--deptno,최대 급여
SELECT deptno
    ,MAX(sal) m_sal
FROM emp
WHERE MAX(sal) >= 3000--ORA-00934 WHERE 절에는 GROUP함수가 올 수 없다.
GROUP BY deptno;

SELECT deptno
    ,MAX(sal) m_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) >= 3000;

------실습1

SELECT 
    MAX(sal)
    ,MIN(sal)
    ,ROUND(AVG(sal), 2)
    ,SUM(sal)
    ,COUNT(sal)
    ,COUNT(mgr)
    ,COUNT(*)
FROM emp;

----실습2


SELECT deptno,
    MAX(sal)
    ,MIN(sal)
    ,ROUND(AVG(sal), 2)
    ,SUM(sal)
    ,COUNT(sal)
    ,COUNT(mgr)
    ,COUNT(*)
FROM emp
GROUP BY deptno;

----실습3
SELECT DECODE(deptno,10, 'ACCOUNTING',20,'RESEARCH',30,'SALES')
    ,MAX(sal)
    ,MIN(sal)
    ,ROUND(AVG(sal), 2)
    ,SUM(sal)
    ,COUNT(sal)
    ,COUNT(mgr)
    ,COUNT(*)
FROM emp
GROUP BY deptno;

----실습4
SELECT TO_CHAR(hiredate,'YYYYMM') AS hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');

----실습5
SELECT TO_CHAR(hiredate,'YYYY') AS hire_yyyy
    ,COUNT(*)cnt
    
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY');
----실습6
SELECT COUNT(deptno) AS cnt
FROM dept;

----실습7
SELECT COUNT(COUNT(deptno)) AS cnt
FROM emp
GROUP BY deptno;

--JOIN
--1.테이블 구조변경(컬럼 추가)
--2.추가된 컬럼에 값을 update
--dname 컬럼을 emp 테이블에 추가
DESC emp;
DESC dept;

--컬럼 추가(dname, VARCHAR2(14))
ALTER TABLE emp ADD (dname VARCHAR2(14));
DESC emp;

SELECT *
FROM emp;

UPDATE emp SET dname = CASE
                            WHEN deptno = 10 THEN 'ACCOUNTING'
                            WHEN deptno = 20 THEN 'RESEARCH'
                            WHEN deptno = 30 THEN 'SALES'
                        END;
                        
SELECT empno, ename, deptno, dname
FROM emp;

--SALES --> MARKET SALES
-- 총 6건의 데이터 변경이 필요하다
-- 값의 중복이 있는 형태(반 정규형)

--UPDATE emp SET dname = 'MARLET SALES'
--WHERE dname = 'SALES';

--emp테이블, deat 테이블 조인
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
