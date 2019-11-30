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
WHERE emp.deptno != dept.deptno
AND emp.deptno = 10;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT ename, deptno
FROM emp;

SELECT deptno, dname
FROM dept;

--antural join :조인 테이블간 같은 타입, 같은 이름의 컬럼으로 
--              같은 값을 갖을 경우 조인
DESC emp;
DESC dept;

SELECT *
FROM emp NATURAL JOIN dept;

--ALSI SQL
SELECT deptno, a.empno, ename
FROM emp a NATURAL JOIN dept b;

--ALTER TABLE emp DROP COLUMN dname;

--oracle 문법
SELECT a.deptno, a.empno, ename
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deprno = dept.deptno;

--JOIN USING
--JOIN 하려고 하는 테이블간 동일한 이름의 컬럼이 두개 이상일 때
--JOIN 컬럼을 하나만 사용하고 싶을 때

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno);

--OPACLE SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI JOIN with ON
--조인 하고자 하는 테이블의 컬럼 이름이 다를 때
--개발자가 조인 조건을 직접 제어할 때

SELECT *
FROM emp JOIN dept ON (emp.deptno= dept.deptno);

--oracle
SELECT  *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF JOIN : 같은 테이블간 조인
--emp 테이블간 조인 할만한 사항 : 직원의 관리자 정보 조회
--직원의 관리자 정보 조회
--직원이름, 관리자 이름

--ANSI
--직원 이름, 직원의 상급자 이름, 직원의 상급자의 상급자 이름
SELECT *
FROM emp e JOIN emp m ON(e.mgr = m.empno);
-------emp의 이름 emp 매니저를 조인 시킨 결과 값

SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);

--ORACLE
SELECT e.ename, m. ename    --3
FROM emp e, emp m           --1.
WHERE e.mgr = m.empno;      --2

--직원 이름, 직원의 상급자 이름, 직원의 상급자의 상급자 이름
SELECT
    *
FROM emp e JOIN emp m ON(e.mgr = m.empo);

SELECT e.ename, m.ename, t.ename
FROM emp e, emp m, emp t
WHERE e.mgr = m.empno
AND m.mgr = t.empno;

SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e, emp m, emp t, emp k
WHERE e.mgr = m.empno
AND m.mgr = t.empno
AND t.mgr = k.empno;

--여러테이블을 ANSI JOIN을 이용한 JOIN
SELECT e. ename, m.ename, t.ename, k.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno)
        JOIN emp t ON (m.mgr = t.empno)
        JOIN emp k ON (t.mgr = k.empno);


--직원의 이름과, 해당 직원의 관리자 이름을 조회한다.
--단 직원의 사번이 7369~7690인 직원을 대상으로 조회
SELECT e.ename, m.ename, 
FROM emp e, emp m, emp n
WHERE e.mgr = m.empno
AND e.empno >= 7369 AND e.mpno <=7690;

SELECT s.ename, m.ename
FROM emp s, emp m
WHERE s.empno BETWEEN 7369 AND 7698
AND s.mgr = m.empno;

--ANSI
SELECT s.ename, m.ename
FROM emp s JOIN eml m ON (s.mgr = m.empno)
WHERE s.empno BETWEEN 7369 AND 7698;

--NOW= EQUI JOIN : 조인 조건이 =(equals)이 아닌 JOIN
-- != , BETWEEN AND

SELECT *
FROM salgrade;

SELECT empno, ename, sal /*급여 grade*/
FROM emp;

SELECT empno,ename,sal,grade
FROM emp JOIN salgrade
ON emp.sal BETWEEN salgrade.loasl AND salgrade.hisal; 


SELECT empno, ename, sal,grade
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal; 

---실습(join0_0)
SELECT *
FROM emp;

SELECT *
FROM dept;

SELECT emp.empno,emp.ename, dept.deptno,dept.dname
FROM emp JOIN dept
ON dept.deptno = emp.deptno
ORDER BY deptno;

-----실습join(0.1)부서번호(10,30)인 사람만 조회

SELECT c. *
FROM
    (SELECT emp.empno,emp.ename, dept.deptno,dept.dname
    FROM emp JOIN dept
    ON dept.deptno = emp.deptno 
    ORDER BY deptno)c
WHERE c.deptno = 10 OR c.deptno = 30;

--실습join(0.2).급여가2500 초과

SELECT c. *
FROM
(SELECT emp.empno,emp.ename,emp.sal, dept.deptno,dept.dname
FROM emp JOIN dept
ON dept.deptno = emp.deptno)c
WHERE c.sal > 2500 
ORDER BY deptno;

--실습join(0.3)급여가 2300 초과 사번이 7600

SELECT c. *
FROM
(SELECT emp.empno,emp.ename,emp.sal, dept.deptno,dept.dname
FROM emp JOIN dept
ON dept.deptno = emp.deptno)c
WHERE c.sal > 2500 AND c.empno > 7600 
ORDER BY deptno;