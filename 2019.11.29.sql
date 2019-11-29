--실습join(0.3)급여가 2300 초과 사번이 7600

SELECT c. *
FROM
(SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp JOIN dept
ON dept.deptno = emp.deptno)c
WHERE c.sal > 2500 AND c.empno > 7600 
ORDER BY deptno;

-----실습 join0_4

SELECT c. *
FROM
(SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp JOIN dept
ON dept.deptno = emp.deptno)c
WHERE c.sal > 2500 AND c.empno > 7600 AND dname = 'RESEARCH'
ORDER BY deptno;

----실습 join1

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod, prod
WHERE prod_lgu = lprod_gu;

--실습 join2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer_id = prod_buyer;

--실습 join3
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member,prod,cart
WHERE cart_member = mem_id
AND cart_prod = prod_id;

--실습 join4
SELECT  customer.CID,customer.CNM,product.pid,cycle.DAY,cycle.CNT
FROM customer,cycle,PRODUCT
WHERE product.pid = cycle.pid 
AND customer.cid = cycle.cid
AND customer.CNM IN ('brown','sally');

--실습 join5
SELECT c. *
FROM (SELECT customer.CID,customer.CNM,product.pid,product.PNM,cycle.DAY,cycle.CNT
    FROM customer, cycle, product
    WHERE product.pid = cycle.pid AND customer.cid = cycle.cid) c
WHERE c.cnm IN ('brown','sally');

--실습 join6
SELECT customer.CID,customer.CNM,product.pid,product.PNM,SUM(cycle.CNT)
FROM customer, cycle, product
WHERE product.pid = cycle.pid AND customer.cid = cycle.cid
group by  customer.CID,customer.CNM,product.pid,product.PNM;

--실습 join7
SELECT product.pid,product.PNM, sum(cycle.cnt)
FROM cycle, product
WHERE product.pid = cycle.pid
group by product.pid,product.PNM;


