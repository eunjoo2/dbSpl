SELECT seq, LPAD(' ',3*(LEVEL-1))||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY parent_seq = PRIOR seq
ORDER BY connect_by_root(seq) desc, seq ;

--사원이름, 사워번호, 전체직원건수
SELECT ename, sal, deptno,rownum(sal)
FROM emp
START WITH deptno = '10'
CONNECT BY deptno = PRIOR sal
ORDER BY  connect_by_root(sal)DESC ,deptno DESC;

SELECT a.ename, a.sal, a.deptno, b.rn
FROM 
(SELECT ename, sal, deptno, ROWNUM j_rn
    FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC)) a,

(SELECT rn, ROWNUM j_rn
FROM
    (SELECT b.*, a.rn
    FROM 
    (SELECT ROWNUM rn
     FROM dual
     CONNECT BY level <= (SELECT COUNT(*) FROM emp)) a,
    
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) b
    WHERE b.cnt >= a.rn
    ORDER BY b.deptno, a.rn )) b
WHERE a.j_rn = b.j_rn;

--ana0-을 분석함수로
SELECT ename, sal, deptno,
        RANK() OVER(PARTITION BY deptno ORDER BY sal )rank,
        DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal )dense_rank,
        ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal )row_rank
FROM emp;

---실습 1
SELECT empno,ename, sal, deptno,
        RANK() OVER( ORDER BY sal DESC, empno )rank,
        DENSE_RANK() OVER(ORDER BY sal DESC,empno)sal_dense_rank,
        ROW_NUMBER() OVER(ORDER BY sal DESC)sal_row_rank
        
FROM emp;

------실습 2
         
 SELECT empno,ename,a.deptno,cnt
 FROM emp,
(SELECT deptno, COUNT(*)cnt
FROM emp
GROUP BY deptno)a
WHERE a.deptno = emp.deptno
ORDER BY deptno;

----window 함수
--사원번호, 사원이름, 부서번호, 부서의 직원수
 SELECT empno,ename,deptno,
        COUNT(*) OVER(PARTITION BY deptno)cnt
 FROM emp;
 
--window함수2
SELECT empno,ename,sal,deptno,
        ROUND(AVG(sal)OVER(PARTITION BY deptno),2)cnt

 FROM emp;
 
--window함수3
 SELECT empno,ename,sal,deptno,
        MAX(sal)OVER(PARTITION BY deptno)max_sal
 FROM emp;

--window함수4
 SELECT empno,ename,sal,deptno,
        MIN(sal)OVER(PARTITION BY deptno)min_sal
 FROM emp;
 
 SELECT empno, ename,sal, a.*
 FROM emp,
 (SELECT deptno,MIN(sal)
 FROM emp
 GROUP BY deptno)a
WHERE emp.deptno = a.deptno
ORDER BY a.deptno;


--전체사원을 대상으로 급여순위가 자신보다 한단계 낮은 사람의 급여
--(급여가 같을 경우 입사일자가 빠른사람이 높은 순위)

SELECT empno,ename,hiredate,sal,
        LEAD(sal) OVER (ORDER BY sal DESC,hiredate) lead_sal
FROM emp;

--전체사원을 대상으로 급여순위가 자신보다 한단계 높은 사람의 급여
--window함수5
SELECT empno,ename,hiredate,sal,
        LAG(sal) OVER (ORDER BY sal DESC,hiredate) lead_sal
FROM emp;

--window함수6
SELECT empno,ename,hiredate,job,sal,
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC,hiredate) lead_sal
    
FROM emp;

--window함수 실습 no_ana3

SELECT a.empno, a.ename, a.sal, SUM(b.sal) 
FROM
    (SELECT aa.*, ROWNUM rn
    FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal)aa) a, 
        
    (SELECT bb.*, ROWNUM rn
    FROM
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal)bb) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY sal;



SELECT *
    FROM emp  ,
    (SELECT ROWNUM c_sum
    FROM dual
    CONNECT BY level <= (SELECT COUNT(*) FROM emp))a
    
    
    GROUP BY empno
    
    
    ;







