    --1.tax 테이블을 이용 시도/시군구별 인당 연말정산 신고액 구하기
    --2.신고액이 많은 순서로 랭킨부여하기
    --랭킹 시도 시군구 인당 연말 정산 신고액
    --1 서울특별시 서초구 7000
    --2 서울특별시 강남구 6800
   SELECT
       *
   FROM 
    (SELECT ROWNUM 순위,sido, sigungu,인당연말정산신고액
    FROM
    (SELECT sido, SIGUNGU,sal,people,ROUND(sal/people,2)인당연말정산신고액    
    FROM tax
    ORDER BY 인당연말정산신고액 DESC))a,
    
   ( SELECT ROWNUM 순위, SIDO,SIGUNGU, 도시발전지수
  FROM ( SELECT A.SIDO, A.SIGUNGU, A.CNT, B.CNT, ROUND( A.CNT/B.CNT,1) AS 도시발전지수
        
    FROM
        (SELECT SIDO,SIGUNGU, COUNT(*)CNT
        FROM FASTFOOD
        WHERE GB IN('KFC','버거킹','맥도날드')
        GROUP BY sido, SIGUNGU) a,
    
        (SELECT SIDO,SIGUNGU, COUNT(*)CNT
        FROM FASTFOOD
        WHERE GB ='롯데리아'
        GROUP BY sido, SIGUNGU) b
        WHERE A.SIDO = B.SIDO
        AND A.SIGUNGU = B.SIGUNGU
        ORDER BY 도시발전지수 DESC))b;
    
    --도시발전지수 시도, 시군구와 연말정산 납입금액의 시도, 시군구가 같은지역끼리 조인
    --정렬순서는 tax 테이블의 id 컬럼순으로 정렬
    --1 서울특별시   강남구5.6 서울 특별시 강남구 70.3
      SELECT
       *
   FROM 
    (SELECT ROWNUM 순위,sido, sigungu,인당연말정산신고액
    FROM
    (SELECT sido, SIGUNGU,sal,people,ROUND(sal/people,2)인당연말정산신고액    
    FROM tax
    ORDER BY 인당연말정산신고액 DESC))a,
    
   ( SELECT ROWNUM 순위, SIDO,SIGUNGU, 도시발전지수
  FROM ( SELECT A.SIDO, A.SIGUNGU, A.CNT, B.CNT, ROUND( A.CNT/B.CNT,1) AS 도시발전지수
        
    FROM
        (SELECT SIDO,SIGUNGU, COUNT(*)CNT
        FROM FASTFOOD
        WHERE GB IN('KFC','버거킹','맥도날드')
        GROUP BY sido, SIGUNGU) a,
    
        (SELECT SIDO,SIGUNGU, COUNT(*)CNT
        FROM FASTFOOD
        WHERE GB ='롯데리아'
        GROUP BY sido, SIGUNGU) b
        WHERE A.SIDO = B.SIDO
        AND A.SIGUNGU = B.SIGUNGU
        ORDER BY 도시발전지수 DESC))b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY a.id ;
        
--UPDATE TAX SET SIGUNGU = TRIM(SIGUNGU);



--SMLTH 가 속한 부서 찾기
SELECT DEPTNO
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno IN (SELECT DEPTNO
                FROM emp);
                
SELECT empno, ename, deptno, 
        (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname
FROM emp;

--SCALAR SUBQUERY
--SElECT 절에 표현된 서브 쿼리
--한 행, 한 COLUMN을 조회해야 한다.
SELECT empno, ename, deptno, 
        (SELECT dname FROM dept) dname
FROM emp;

-- INLINE VIEW
-- FROM 절에 사용되는 서브 쿼리


--SUBQUERY
--WHERE에 사용되는 서브쿼리

--실습 1
SELECT COUNT(*) cnt
FROM emp
WHERE sal > (SELECT round (AVG(sal),0)
            FROM emp);
--실습 2
SELECT *
FROM emp
WHERE sal > (SELECT round (AVG(sal),0)
            FROM emp);

--실습 3
SELECT *
FROM emp
WHERE DEPTNO IN ( SELECT DEPTNO 
                    FROM emp
                    WHERE ENAME IN('SMITH','WARD'));

SELECT *
FROM emp
WHERE sal <= ANY (SELECT sal -- 800, 1250 --> 1250보다 작은 사람
                FROM emp
                WHERE ename = 'SMITH'
                or ename ='WARD');
                
-- 관리자 역할을 하지 않는 사원 정보 조회
-- NOT IN 연산자 사용시 NULL이 데이터에 존재하지 않아야 정상동작을 한다.
SELECT *
FROM emp        -- 사원 정보조회--> 관리자역할을 하지 않는
WHERE empno NOT IN
            (SELECT NVL(mgr, -1) --NULL 값을 존재하지 않을만한 데이터로 치환
            FROM emp); 
            
SELECT *
FROM emp    
WHERE empno NOT IN
            (SELECT mgr
            FROM emp
            WHERE mgr IS NOT null); 

--pair wise(여러 컬럼의 값을 동시에 만족 해야하는 경우)
--ALLEN, CLARK의 매니저와 부서번호가 동시에 같은 사원 정보 조회
--(7698, 30)
--(7839, 10)
--소속부서가 10번 이거나 30번인 직원 정보 조회
--7698,10
--7698,30
--7639,10
--7639,30
SELECT *
FROM emp
WHERE (mgr, deptno) IN  (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782))
                    AND deptno IN  (SELECT deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
                        
--비상호 연관 서브 쿼리
--메인 쿼리의 컬럼을 서브쿼리에서 사용하지 않는 형태의 서브쿼리

--비상호 연관 서브쿼리의 경우 메인쿼리에서 사용하는 테이블, 서브쿼리 조회 순서를 성능적으로 
--  유리한쪽으로 판단하여 순서를 결정 한다.
--메인쿼리의 emp테이블을 먼저 읽을수도 있고, 서브쿼리의 emp테이블을 먼저 읽을수도 있다.

--비상호 연관 서브쿼리에서 서브쿼리쪽 테이블을 '먼저' 읽을 떄는 서브쿼리가 '제공자' 역할을 했다 라고 볼수있다.

--비상호 연관 서브쿼리에서 서브쿼리쪽 테이블을 '나중에' 읽을 떄는 서브쿼리가 '확인자' 역할을 했다 라고 볼수있다.

--직원의 급여 평균보다 높은 급여를 받는 직원 정보 조회
--직원의 급여 평균

SELECT AVG(sal)
FROM emp
WHERE sal> (SELECT AVG(sal)
            FROM emp);

--상호연관 서브쿼리 
--해당 직원이 속한 부서의 급여 평균보다 높은 급여를 맏는 직원 조회

SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
            FROM emp
            WHERE deptno = m.deptno);

--10번 부서의 급여 평균
SELECT deptno,ROUND(AVG(sal),2)
FROM emp 
WHERE deptno = 10;

--실습 4
