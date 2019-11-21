-- col IN (value1, value2...)
-- col의 값이 IN 연산자 안에 나열된 값중에 포함될 때 참으로 판정

--RDBMS - 집합개념
-- 1. 집합에는 순서가 없다.
-- (1, 5, 7), (5, 1, 7)

-- 2. 집합에는 중복이 없다.
-- (1, 1, 5, 7), (5, 1, 7)
SELECT *
FROM emp
WHERE deptno IN (10,20);  --emp 테이블의 직원의 소속 부서가 10번이거나 20번이거나 직원 정보만 조회
-- 이거나 --> OR(또는)
-- 이고 --> AND(그리고)

-- IN--> OR
-- BETWEEN AND --> AND + 산술 비고

SELECT *
FROM emp
WHERE deptno = 10 OR deptno = 20;

-----실습 where3

SELECT userid "아이디", usernm  "이름",  alias  "별명" 
FROM users
WHERE userid IN('brown', 'cony', 'sally');

--LINE 연산자 : 문자열 매칭 연산
-- % : 여러 문자 (문자열 없을 수도 있다)
-- _ : 하나의 문자

--emp테이블에서 사원이름(ename)이 S로 시작하는 사원 정보만 조회

SELECT *
FROM emp 
WHERE ename LIKE 'S%';

--SMITH
--SCOTT
--첫글자는 s로 시작하고 4번째 글자는 T
--두번째, 세번째, 다섯번째 문자는 어떤 문자든 올 수 있다
SELECT *
FROM emp
WHERE ename LIKE 'S__T_';

-------실습 where4
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%'; --'신__'

-------실습 where5
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%'; -- % 어디든 포함되어 있는 이름을 찾을 수 있다

--컬럼 값이 NULL인 데이터 찾기
SELECT *
FROM emp
WHERE MGR ;
WHERE MGR IS NULL;
WHERE MGR = 7698;

SELECT *
FROM emp
WHERE comm IS NOT NULL;


SELECT *
FROM emp
WHERE comm IS NOT NULL;

--AND : 조건을 동시에 만족
--OR : 조건을 한개만 충족하면 만족
--emp 테이블에서 mgr가 7698 사번이고(AND) 급여가 1000보다 큰 사람 
SELECT *
FROM emp
WHERE mgr = 7698
AND sal >1000;

--emp 테이블에서 mgr가 7698 사번이거나(OR) 급여가 1000보다 큰 사람  
SELECT *
FROM emp
WHERE mgr = 7698
OR sal >1000;

--emp 테이블에서 관리자 사번이 7698, 7839가 아닌 직원 정보조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839) 
OR mgr IS NULL;

------실습 where7

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
AND HIREDATE >= TO_DATE('1981.06.01', 'YYYY.MM.DD');
