
------실습  where8

SELECT *
FROM emp
WHERE deptno LIKE '10'
AND hirtdate > TO_DATE('19810601', 'YYYYMMDD');


------실습 where9

SELECT *
FROM emp 
WHERE deptno NOT IN (10)
AND HIREDATE > TO_DATE('1981-06-01', 'YYYY-MM-DD');

------실습 10 (NOT IN 연산자 사용 금지, IN 연산자만 사용 가능)

SELECT *
FROM emp 
WHERE DEPTNO IN (20 , 30)
AND HIREDATE > TO_DATE('1981-06-01', 'YYYY-MM-DD');


-------- 실습 11

SELECT *
FROM emp 
WHERE job = 'SALESMAN'
OR HIREDATE > TO_DATE('1981-06-01', 'YYYY-MM-DD');

-------- 실습 12


SELECT *
FROM emp 
WHERE job = 'SALESMAN'
OR EMPNO LIKE '78%';

-------- 실습 13 (LIKE 연산을 사용하지 마시오)
---전제조건 : EMPNO가 숫자여야된다 
SELECT *
FROM emp 
WHERE job = 'SALESMAN'
OR EMPNO BETWEEN 7800 AND 7899;



--연산자 우선 순위 ( AND >OR)
SELECT *
FROM emp
WHERE ename = 'SMITH'
OR ename = 'ALLEN'
AND jop = 'SALESMAN';

SELECT *
FROM emp
WHERE ename = 'SMITEH'
OR (ename = 'ALLEN' AND job = 'SALESMAN');

--직원이름이 SMITH 이거나 ALLEN 이면서 역학이 SALEMAN 인 사람

SELECT *
FROM emp
WHERE ( ename = 'SMITEH' OR ename = 'ALLEN')
AND job = 'SALESMAN';

------ 실습 14

SELECT *
FROM emp 
WHERE job = 'SALESMAN'
OR (empno BETWEEN 7800 AND 7899
 AND hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD'));


SELECT *
FROM emp 
WHERE job = 'SALESMAN'
OR (empno BETWEEN 7800 AND 7899)
 AND hiredate > TO_DATE('1981-06-01', 'YYYY-MM-DD');

--데이터 정렬
-- 10, , 5, 2, 1, 

--오름차순 : 1, 2, 3, 5, 10
--내림차순 : 10, 5, 3, 2, 1, 

--오름차순 : ASC   (표기를 안할 경우 기본값)
--내림차순 : DSSC

/*
    SELET co11, co12, ....
    FROM 테이블명
    WHERE co11 = '값'
    ORDER BY 정렬기준 컬럼1 [ASC , DESC], 정렬기준컬럼2.....[ASC / DESC]

사원(emp)테이블에서 직원의 정보름 지원 이름 으로 내림차순 정렬
*/
SELECT *
FROM emp
ORDER BY ename DESC;


--사원(emp)테이블에서 직원의 정보름 지원 이름 으로 오름차순(ASC) 정렬
--부서번호가 같을 떄는 sal 내림차순(DESC) 정렬

SELECT *
FROM emp
ORDER BY deptno, sal;


SELECT *
FROM emp
ORDER BY deptno, sal DESC;

--사원(emp)테이블에서 직원의 정보름 지원 이름 으로 오름차순(ASC) 정렬
--부서번호가 같을 떄는 sal 내림차순(DESC) 정렬
--급여(sal)가 같을떄는 이름으로 오름차순(ASC) 정렬한다.

SELECT *
FROM emp
ORDER BY deptno, sal DESC, ename;
--정렬 컬럼을 ALLAS 
SELECT *
FROM emp
ORDER BY nm;

--조회하는 컬럼의 위치를 인테스로 표현가능

SELECT *
FROM emp
ORDER BY 3; --추천하지 않음 (컬럼 추가시 의도하지 않은 결과가 나올수 있음)

--실습 orderby1

SELECT *
FROM dept
ORDER BY dname; --ASC 

SELECT *
FROM dept
ORDER BY loc DESC;

--실습 orderby2

SELECT * 
FROM emp
WHERE comm IS NOT NULL
AND COMM != 0
ORDER BY comm DESC, empno;

--실습 3

SELECT *
FROM emp
WHERE mgr IS NOT NULL;
ORDER BY job, empno DESC;

--실습 4

SELECT *
FROM emp
WHERE deptno IN(10, 30)     --(deptno = 10 OR deptno = 30)
AND sal > '1500'
ORDER BY ename DESC;


SELECT ROWNUM, empno,ename
FROM emp;


SELECT ROWNUM, empno,ename
FROM emp
WHERE ROWNUM = 1;       -- ROWNUM = equal 비교는 1만 가능

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 2;      -- <=  을 순차적으로 조회하느경우 가능


SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 20;      -- 1부터 시작 하는 경우 가능

--SELECT r결과 ORDER BY 구문을 실행하는 순서
--SELECT > ROWNUM > OREDER BY
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

--INLINE VIEW 을 통해 정렬 먼저 실행하고 결과에 ROWNUM을 적용
SELECT ROWNUM, *
FROM    
    (SELECT empno, ename
    FROM emp
    ORDER BY ename);

--SELEECT 절에 * 표현하고 다른컬럼 표현식으 ㄹ썻을 경우 *앞에 테이블명이나 별칭을 적용해야 한다. 단 AS를 잉용해서 ALLAS를 사용할수 없다
SELECT ROWNUM, a.*
FROM ( SELECT empno, ename
    FROM emp
    ORDER BY ename) a;
    

--실습 row1

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM <=10;

--실습 row2 ROWNUM 11-14

SELECT a.*
FROM
    (SELECT ROWNUM rn, empno, ename
    FROM emp ) a
WHERE rn BETWEEN 11 AND 20;

--실습 row3
-- emp 테이블에서 ename 으로 정렬한 결과에 11번째 행과 14번째 행만 조회하는 쿼리를 작성해 보세요
--(empno, ename 컬럼과 행번호만 조회)

SELECT rn,empno, ename
FROM
        (SELECT ROWNUM rn, a.*
         FROM
        (SELECT  empno, ename
         FROM emp
         ORDER BY ename) a )
            
WHERE rn BETWEEN 11 AND 14;


(SELECT ROWNUM rn, empno, ename
    FROM emp
    ORDER BY ename);
