--merge
SELECT  *
FROM emp_test
ORDER BY empno;

--emp테이블에 존재하는 데이터를emp_test 테이블로 머지
--만약 empno가 동일한 데이터가 존재하면
--empno update :ename || '_merge'
-- 만약mpno가 동일한 데이타가 존재하지 않을 경우
--dmp 테이블의 empmo, ename_emp_Test 테이블로 insert

--emp_test 데이터에서 절반의 데이터 삭제
DELETE emp_test
WHERE empno >= 7788;
COMMIT;

--테이블에는 14건의 데이터가 존재
--emp_test 테이블에는 사번이 7788보다 작은 7명의 데이터가 존재
--emp테이블을 이용하여 emp_test 테이블을 머지하게되면
--emp테이블만 존재하는 직원(사번이 7788보다 크거나 같은 )7aud
--emp_test로 새롭게 insert가 될 것이고
--emp, emp_test 에 사원번호가 동일하게 존재하는 7명으ㅔ 데이터는 
--(사번이7788보다 작은 직운)ename 컬럼으로 ename||'_modify'로 업데이트 한다.

/*
MEGRE INTO 테이블명
USING 머지대상 테이블 |VIEW|SUBQUUERY
ON (테이블명과 머지대상의 연결관계)
WHEN MATCHED THEN
    UPDATE ....
QHEN NOT MATCHED THNE
    INSERT...
*/

MERGE INTO emp_test
USING emp
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = ename ||'_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

--emp_test 테이블에 사번이 9999 데이터가 존재하면
--ename 을 ;brownl'으로 update
--존재하지 않을 경우 empno,ename VALUES (9999,'brown'dmfh ㅑㅜㄴㄷㄳ
--위의 시나리오를 MERGE 구문으 ㄹ활용하여 한번의 spl로 구현
--:empno - 9999 , :ename - 'brown'
MERGE INTO emp_test
USING dual
ON (emp_test.empno = :empno)
WHEN MATCHED THEN
    UPDATE SET ename = :ename || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES(:empno, :ename);
    
SELECT *
FROM emp_test
WHERE empno =9999;

--만약 merge구문이 없다면
-- 1.empno = 9999인 데이터가 존재하는지 확인
-- 2-1 1번 사항에서 데이터가 존재하면 UPDATE
-- 2-2 1번 사항에서 데이터가 존재하면 않으면 INSERT



--부서별 급여
SELECT deptno, SUM(sal)sal
FROM emp
GROUP BY deptno

UNION ALL 
--전체 직원의 급여 함
SELECT null, SUM(sal)
FROM emp;

--JOIN방식으로 풀이
--emp 테이블의 14건데 데이터를 28건으로 생성
--구분자 (1-14,2-14)를 기준으로 group by
-- 구분자 1 : 부서번호 기준으로 14 row
-- 구분자 2 : 전체 14row

SELECT DECODE(b.rn, 1, emp.deptno, 2, null)deptno,
        SUM(emp.sal) sal
FROM emp,   (SELECT ROWNUM rn
            FROM dept
            WHERE ROWNUM <=2)b
GROUP BY DECODE(b.rn, 1, emp.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, emp.deptno, 2, null);
----------------------------------------------------
SELECT DECODE(b.rn, 1, emp.deptno, 2, null)deptno,
        SUM(emp.sal) sal
FROM emp,   (SELECT ROWNUM rn
            FROM dual
            CONNECT BY LEVEL <=2)b
GROUP BY DECODE(b.rn, 1, emp.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, emp.deptno, 2, null);

--- REPORT GROUP BY
--ROLLUP
--GROUP BY ROLLUP(coll.....)
--ROLLUP 절에 기술한 컬럼을 오른쪾에서 부터 지원결과를
--SUB GROUP을 생성하여 여러개의 GROUP BY 절을 하나의 SQL에서 실행 하도록 한다
GROUP BY ROLLUP(job,deptno)
--GROUP BY job, deptno
--GROUP BY job
--GROUP BY --> 전체 행을 대상으로 GROUP BY

--EMP 테이블을 이용하여 부서번호별, 전제직원별 급여합을 구하는 쿼리를 ROLLUP기능을 활용
SELECT deptno, SUM(sal)sal
FROM emp
GROUP BY ROLLUP (deptno);

--emp테이블을 이용하여 job,deptno 별 sal+comm합계
--                  job별 sal+comm합계
--                  전체직원 sal+comm합계
--ROLLUP

SELECT job, deptno, SUM(sal + NVL(comm,0)) sal_sum
FROM emp

--ROLLUP은 컬럼 순서가 조회결과에 영향을 미친다.
GROUP BY ROLLUP (job, deptno);
--GROUP BY job, deptno
--GROUP BY job
--GROUP BY --> 전체 row대상

GROUP BY ROLLUP (deptno,job);
--GROUP BY deptno,job
--GROUP BY deptno
--GROUP BY --> 전체 row대상

--GROPU_2
SELECT NVL(job,'층계'),deptno,
        SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY rollup(job,deptno);

SELECT DECODE(GROUPING(job), 1,'총계',job)job,deptno,SUM(sal+NVL(comm,0))sal_sum
FROM emp
GROUP BY rollup(job,deptno);

--GROPU_2-1
SELECT DECODE(GROUPING(job), 1,'총',job)job,
       
       CASE
            WHEN deptno IS NULL AND job IS NULL THEN '계'
            WHEN deptno IS NULL AND job IS NOT NULL THEN '소계'
            ELSE '' || deptno
        END,
       SUM(sal+NVL(comm,0))sal_sum
FROM emp
GROUP BY rollup(job,deptno);


SELECT deptno,job,SUM(sal)sal
        --SUM(sal+NVL(comm,0))sal_sum
FROM emp
GROUP BY rollup(deptno,job);

SELECT deptno,job,
        SUM(sal+NVL(comm,0))sal_sum
FROM emp
GROUP BY rollup(deptno,job);

-------

SELECT deptno,job,SUM(sal+NVL(comm,0))sal_sum
FROM emp
GROUP BY deptno,job

UNION ALL
SELECT deptno,null,SUM(sal+NVL(comm,0))sal_sum
FROM emp
GROUP BY deptno,job

-----------4

SELECT *
FROM emp,dept;

SELECT dname,job,SUM(sal+NVL(comm,0))sal
FROM emp,dept
WHERE emp.deptno = dept.deptno
GROUP BY rollup(dname,job);
--
SELECT dept.dname, a.job,a.sal
FROM
        (SELECT deptno,job,
        SUM(sal+NVL(comm,0))sal
        FROM emp
        GROUP BY ROLLUP (deptno,job))a, dept
WHERE a.deptno = dept.deptno(+);
----------5
SELECT NVL(dname,'총합')dname,job,SUM(sal+NVL(comm,0))sal
FROM emp,dept
WHERE emp.deptno = dept.deptno
GROUP BY rollup(dname,job);

--
SELECT NVL(dept.dname,'총계')dname, a.job,a.sal
FROM
        (SELECT deptno,job,
        SUM(sal+NVL(comm,0))sal
        FROM emp
        GROUP BY ROLLUP (deptno,job))a, dept
WHERE a.deptno = dept.deptno(+);
