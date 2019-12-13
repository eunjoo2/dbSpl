--OUTER JOIN : 조인 연결에 실패 하더라도 기준이 되는 테이블의 데이터는 나오도록 하는 JOIN
--LEER OUTER JOIN : 테이블1 LEFT OUTER JOIN 테이블2
-- 테이블 1과 테이블2를 조인 할 때 조인에 실패하더라도 테이블 1쪽의 데이터는 조회가 되도록 한다.
-- 조인에 실패한 행에서 테이블2의 컬럼값은 존재하지 않으므로 NULL로 표시된다.


SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno);
            
            
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno

FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno AND m.deptno = 10)
WHERE m.deptno =10;
--ORACLE outer join syntax
--일반조인과 차이점은 컬럼명데 (+) 표시
--(+)표시 : 데이터가 존재하지 않는데 나와야 하는 테이블의 컬럼
-- 직원 LEFT OUTER JOIN 매니저
--     ON(직원.매니저번호 = 매니저.직원번호)

--ORACLE OUTER
--WHERE 직원. 매니저 번호 = 매니저 직원번호(+) --매니저쪽 데이터가 존재하지 않음
SELECT e. empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
            ON (e. mgr = m.empno);


--ORACLE OUTER

SELECT e. empno, e.ename, m.empno, m.ename
FROM emp e ,emp m
WHERE e.mgr = m.empno(+);


--매니저 부서번호 제한
--ANSI SQL ON 절에 기술
-- --> outer 조인이 적용되지 않은 상황, 
-- ++아우터 조인이 적용되어야 테이블의 모든 컬럼에 (+) 가 붙여야 한다.
SELECT e. empno, e.ename, m.empno, m.ename
FROM emp e ,emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

--ansi sql의 on절에 기술한 경우와 동일
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e ,emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

----emp 테이블에는 14명의 직원이 있고 14명은 10, 20, 30 부서중에 한 부서에 속한다.
--하지만 dept 테이블에는 10, 20, 30, 40번 부서가 존재
--부서번호, 부서명, 해당부서에 속한 직원수가 나오도록 쿼리를 작성

SELECT dept.deptno, dept.dname ,COUNT(emp.deptno) cnt
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno
GROUP BY dept.deptno, dept.dname;


SELECT dept.deptno, dept.dname, NVL(emp_cnt.CNT, 0)CNT --NULL이 아닌 값을 띄우기 위해
FROM dept,
    (SELECT deptno, COUNT(*) CNT
    FROM emp 
    GROUP BY deptno) emp_cnt
WHERE dept.DEPTNO = emp_cnt.deptno(+); --데이터가 존재하지 않은 쪽에 (+)를 붙여줘야 한다.

--ANSI
SELECT dept.deptno, dept.dname, NVL(emp_cnt.CNT, 0)CNT --NULL이 아닌 값을 띄우기 위해
FROM 
dept LEFT OUTER JOIN
    (SELECT deptno, COUNT(*) CNT
    FROM emp 
    GROUP BY deptno) emp_cnt
ON(dept.DEPTNO = emp_cnt.deptno);

--FULL OUTER = LEFT OUTER + RIGHER OUTER 중복데이터 를 한건만 저장
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
            ON (e.mgr = m.empno);

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m
            ON (e.mgr = m.empno);

--OUTER JOIN 1
SELECT BUYPROD.BUY_DATE, BUYPROD.BUY_PROD
FROM PROD,BUYPROD;
  
    
SELECT a.BUY_DATE,a.BUY_PROD,b.prod_id,b.prod_name,a.BUY_QTY
FROM buyprod a, prod b
WHERE a.BUY_DATE(+) = TO_DATE ('2005_01_25')
AND a.BUY_PROD(+) = b.PROD_ID;
 
    
--OUTER JOIN 2
SELECT BUYPROD.BUY_DATE, BUYPROD.BUY_PROD
FROM PROD,BUYPROD;
    
    SELECT TO_DATE(:yyyymmdd,'YYYYMMDD') BUYDATE ,a.BUY_PROD,b.prod_id,b.prod_name,a.BUY_QTY
    FROM buyprod a, prod b
    WHERE a.BUY_DATE(+) = TO_DATE ('2005_01_25')
    AND a.BUY_PROD(+) = b.PROD_ID;



--OUTER JOIN 3

 SELECT NVL(TO_CHAR(a.BUY_DATE,'yy/mm/dd'), '05/01/25')BUY_DATE,a.BUY_PROD,b.prod_id,b.prod_name,NVL(a.BUY_QTY, '0')BUY_QTY
    FROM buyprod a, prod b
    WHERE a.BUY_DATE(+)= TO_DATE ('2005_01_25')
    AND a.BUY_PROD(+) = b.PROD_ID;
    
SELECT
    *
FROM BUYPROD,PROD
WHERE BUY_DATE = TO_DATE ('2005_01_25');    
--OUTER JOIN 4
SELECT PRODUCT.PID, product.PNM,
NVL(cycle.CID,1)CID,
NVL(cycle.DAY,0)DAY,
NVL(cycle.CNT,0)CNT
FROM cycle,product
WHERE cycle.PID(+) = product.PID
AND cycle.CID(+) IN 1;

SELECT PRODUCT.PID, product.PNM,
NVL(cycle.CID,1)CID,
NVL(cycle.DAY,0)DAY,
:cid
FROM cycle,product
WHERE cycle.PID(+) = product.PID
AND cycle.CID(+) = :cnt ;

--OUTER JOIN 5
SELECT PRODUCT.PID, product.PNM, NVL(cycle.CID, '1')CID, CUSTOMER.CNM,
        NVL(cycle.DAY,0)DAY, NVL(cycle.CNT,0)CNT
FROM cycle,product,CUSTOMER
WHERE cycle.PID(+) = product.PID
AND cycle.CID(+) IN 1
AND CUSTOMER.CNM IN'brown'
ORDER BY product.PID DESC ,DAY DESC;

--실습5
SELECT product.pid, pnm, NVL(cycle.cid,'1')cycle, NVL(cnm, 'brown') cnm, 
        NVL(day,0) day, NVL(cnt,0) cnt
FROM cycle, product, customer
WHERE product.pid = cycle.pid (+)
AND cycle.cid = customer.cid (+)
AND cycle.cid (+)= 1
ORDER BY pid DESC, DAY DESC;

SELECT *
FROM product;

--CROSS 실습
SELECT *
FROM CUSTOMER CROSS JOIN PRODUCT;
