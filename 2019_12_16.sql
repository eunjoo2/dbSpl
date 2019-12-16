-- grouponing sets(col1,col2)
-- 다음과 결과가 동일
-- 개발자가 GROUP BY의 기준을 직접 명시한다.
-- ROLLUP과 달리 방향성을 갖지 않는다.
-- GROUPING SETS(col1,col2 ) = GROUPING SETS (col1,col2)

-- GROUP BY col1
-- UNION ALL
-- GROUP BY col1

-- emp 테이블에서 직원의 job(업무)별 굽여(sal)+상여 (comm)합,
--                      deptno(부서)별 급여(sal)+상여(comm)
-- 기존 방식( GROUP FUNCTION) : 2번의 SQL 작성 필요(UNION/ UNION ALL)

SELECT job, null deptno, SUM(sal+NVL(comm,0))sal_comm_sum
FROM emp
GROUP BY job

UNION ALL

SELECT '' , deptno, SUM(sal+NVL(comm,0))sal_comm_sum
FROM emp
GROUP BY deptno;

-- GROUP SETS 구문을 이용하여 위의 SQL을 집합연산을 사용하지 않고
-- 테이블을 한번 읽어서 처리

SELECT job , deptno, SUM(sal+NVL(comm,0))sal_comm_sum
FROM emp
GROUP BY GROUPING SETS (job, deptno);

-- job ,deptno를 그룹으로 한 sal+comm 합
-- mgr를 그룹으로 한 sal+comm합
-- GROUP BY job, deptno
-- UNION ALL
-- GROUP BY mgr
-- --> GROUPING SETS (job, deptno, mgr)

SELECT job, deptno, mgr, SUM(sal+NVL(comm,0))sal_comm_sum
FROM emp
GROUP BY GROUPING SETS ((job,deptno),mgr);

--null값을 확인 하기위해 SELECT 절에 추가 해봄
SELECT job, deptno, mgr, SUM(sal+NVL(comm,0))sal_comm_sum,
        GROUPING(job), GROUPING(deptno),GROUPING (mgr)
FROM emp
GROUP BY GROUPING SETS ((job,deptno),mgr);


--CUBE (col1,col2...)
--나열된 컬럼의 모든 가능한 조합으로 GROUP BY subset을 만들다.
--CUBE에 나열된 컬럼이 2개인 경우 : 가능한 경우 조합 4개
--CUBE에 나열된 컬럼이 3개인 경우 : 가능한 경우 조합 8개
--CUBE에 나열된 컬럼를 2의 제곱tmd 한 결과가 가능한 조합 개수가 된다.(2^n)
-- 컬럽이 조금만 많아져도 가능한 조합이 기하급수적으로 늘어 나기 떄문에 많이 사용하지는 않는다.

--job,deptno를 이용하여 cube 적용
SELECT job, deptno,
        SUM(sal+NVL(comm,0))sal_comm_sum
FROM emp
GROUP BY cube(job,deptno);
--job, deptno
--1,    1   --> GROUP BY job, deptno
--1,    0   --> GROUP BY job
--0,    1   --> GROUP BY deptno
--0,    0   --> GROUP BY --emp테이블의 모든행에 대해 GROUP BY

--GROUP BY 응용
--GROUP BY ROLLUP, CUBE 를 섞어 사용하기
--가능한 조합을 생각해보면 쉽게 결과를 예측할 수 있다.
--GROUP BY job,rollup(deptno),cube(mgr)


SELECT job, deptno,mgr,
        SUM(sal+NVL(comm,0))sal_comm_sum
FROM emp
GROUP BY job,rollup(deptno),cube(mgr);

--


SELECT job, deptno,mgr,
        SUM(sal+NVL(comm,0))sal_comm_sum
FROM emp
GROUP BY job,rollup(job,deptno),cube(mgr);


--sub_a1 실습
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt number);

--deptno=10 --> empcat =3,
--deptno=20 --> empcat =5,
--deptno=30 --> empcat =6,

UPDATE dept_test 
SET empcnt = (SELECT COUNT(*)deptno
            FROM emp
            WHERE emp.deptno = dept_test.DEPTNO);

SELECT *
FROM dept_test;

--sub_a2
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

insert into dept_test values(99,'it1','daejeon');
insert into dept_test values(98,'it2','daejeon');

DELETE dept_test
WHERE deptno NOT IN (SELECT deptno
                FROM emp
                GROUP BY deptno);
                

DELETE dept_test
WHERE deptno > 30;
               
ROLLBACK; 

SELECT *
FROM dept_test;

--sub_a3
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

UPDATE emp_test
SET sal = sal +200
WHERE sal <
            (SELECT ROUND(AVG(sal),0)
            FROM emp
            WHERE deptno = emp_test.deptno );
          
SELECT deptno, sal
FROM emp_test
ORDER BY deptno;
        
-- MERGE 구문을 이용한 업데이트
MERGE INTO emp_test a
USING    (SELECT deptno,AVG(sal) avg_sal
            FROM emp_test
            GROUP BY deptno)b
ON(a.deptno = b.deptno)

WHEN MATCHED THEN
    UPDATE SET sal = sal +200
    WHERE a.sal < b.avg_sal;
             
ROLLBACK;
MERGE INTO emp_test a
USING    (SELECT deptno,AVG(sal) avg_sal
            FROM emp_test
            GROUP BY deptno)b
ON(a.deptno = b.deptno)
WHEN MATCHED THEN
    UPDATE SET sal = CASE
                        WHEN a.sal < b.avg_sal THEN sal + 200
                        ELSE sal
                    END;
