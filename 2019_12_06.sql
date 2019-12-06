SELECT
    *
FROM dept;

--dept 테이블에 부서번호 99, 부서명 ddit 위치 daejeon

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

--UPDATE : 테이블에 저장된 컬럼의 값을 변경
--UPDATE 테이블명 SET 컬럼명 1= 적용하려는 값1, 컬럼명2= 적용하려고하는 값2...
--[WHERE row 조회 조건]에  해당하는 데이터만 업데이트가 된다.

--부서번호가 99인 부서의 부서명을 대덕IT로, 지역을 영민빌딩으로 변경
UPDATE dept SET dname = '대덕IT',loc = '영민빌딩'
WHERE deptno = 99;

--업데이트전 업데이트 하려고 하는 테이블을 AHERE절에 기술한 조건으로 SELECT를 하여 업데이트 대상 ROW를 확인해 보자
--다음  QUERY를 실행하면 WHERE절에 ROW 제한 조건이 없기 때문에 dept 테이블의 모든 행에 대해 부서명, 위치 정보를 수정한다.
--UPDATE dept SET dname = '대덕IT',loc = '영민빌딩'

SELECT
    *
FROM dept
WHERE deptno = 99;

SELECT
    *
FROM dept;

--SUBQUERY를 이용한 UPDATE
--EMP 테이블에 신규 데이터 입력
--사원번호 9999, 사원이름 brown, 업무 : null

INSERT INTO emp (empno, ename) VALUES ( 9999, 'brown');
COMMIT;

--사원번호가 9999인 사원의 소속 부서와 담당업무를 SMITH 사원의 부서, 업무로 업데이드
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename= 'SMITH'),
                    job = (SELECT job FROM emp WHERE ename= 'SMITH')
        WHERE empno = 9999;
COMMIT;        
SELECT*
FROM emp
WHERE empno = 9999;

--DELETE : 조건에 해당하는 ROW를 삭제
--컬럼의 값을 삭제?(NULL) 값으로 변경하려면 --> UPDATE
 --DELETE 테이블명
 --WHERE 조건
 
 --UPDATE 쿼리와 마찬가지로 DELETE쿼리 실행전에는 해당 테이블WHERE 조건을 동일하게 하여 SELECT를 실행, 삭제될 ROW를 먼저 확인해보지
 
 --emp테이블에 존재하는 사원번호 9999인 사원을 삭제
 DELETE emp
 WHERE empno = 9999;
 COMMIT;
 SELECT
     *
 FROM emp;
 
 --매니저가 7698인 모든 사원을 삭제
 --서브쿼리를 사용
 DELETE emp
 WHERE empno IN (SELECT empno
                 FROM emp
                 WHERE mgr =7698);
SELECT *
FROM emp;
-- 위 쿼리는 아래 쿼리와 동일
DELETE emp WHERE mgr = 7698;

--ISOLATION LEVEL2
--선행 트랙잭션에서 읽은 데이터
--(FOR UPDATE)를 수정, 삭제를 하지 못함

--현 트랙잭션에서 해당 ROW는 항상 동일한 결과값으로 조회할 수 있다.
SELECT *
FROM dept;

--하지만 후행 트랙잭션의 데이터 조회기준이 트랜잭션에서 데이터를 신규 입력, 수정, 삭제 후 COMMPIT을 하더라도
--선행트랜잭션에서는 해당 데이터를 보지않는다.

