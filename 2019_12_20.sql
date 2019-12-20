--hasy join
SELECT *
FROM dept,emp
WHERE dept.deptno = emp.deptno;

--dept 먼저 읽는 형태
--join 컬럼을 hasy 함수로 돌려서 bucket
--10 --> ccc1122(hasyvalue)

--emp 테이블에 대해 위의 진행을 동일하게 진행
--10 --> ccc1122(hasyvalue)

SELECT *
FROM dept, emp
WHERE emp.deptno BETWEEN dept.deptno AND 99;

SELECT COUNT(*)
FROM emp;

--사원번호, 사원이름, 부서번호, 급여, 부서원의 전체 급여합
SELECT empno, ename, deptno, sal,
    SUM(sal) OVER(ORDER by sal 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)c_sum, --가장 처음부터 현재행까지

    --바로 이전행이랑 현재행까지의 급여합
    SUM(sal) OVER(ORDER by sal ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)c_sum2

FROM emp
ORDER BY sal;

--windwo 함수
--사원번호, 사원이름 부서번호, 급여정보를 부서별로 급여, 사원번호 오름차순으로 정렬

SELECT empno, ename, deptno, sal,
   
    --바로 이전행이랑 현재행까지의 급여합
    SUM(sal) OVER(PARTITION BY deptno ORDER BY sal,empno
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)c_sum

FROM emp;


--ROWS vs RANGE 차이 확인하기
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER(ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum,
        SUM(sal) OVER(ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum,
        SUM(sal) OVER(ORDER BY sal ) c_sum

FROM emp;


