--특정 테이블의 컬럼 조회
--1. DESC 테이블명
--2. SELECT * FROM user rab_colummns;

--prod 테이블의 컬럼조회
DESC prod;

VARCHAR2, CHAR -->문자열 (Characret)
MEMBER -->숫자
CLOB --> Character Latge OBject, 문자열 타입의 길이 제한을 피하는 타입
        -- 최대 사이즈 : VARCHAR2(4000), CLOB(4GB)
DATE-- 날짜(일시 = 년,월,일,+시간,분,초 YYYY/MM/DD hh/mm/ss

--date 타입에 대한 연산의 결과는?
'2019/11/20 09:16:20'+ 1 =


--USERS 테이블의 모든 컬럼을 조회 해보세요
SELECT *
FROM users;


--userid, usernm, reg_dt 세가지 컬럼만 조회
--연산을 통해 새로운 컬럼을 생성 (reg_dt에 숫자 연산을 한 새로운 가공 컬럼)
--날짜 + 정수 연산 ==> 일자를 더한 날짜타입이 결과로 나온다
--별칭 : 기존 컬럼명이나 연산을 통해 생성된 가상 컬럼에 임의의 컬럼이름을 부여
--  co1 : express [AS]  별칭명

SELECT userid, usernm, reg_dt, reg_dt+5 AS after5day
FROM users;

-- 숫자 상수. 문자열 상수 ( oracle : '' , java : '', "") 
-- table에 없는 값을 입으로 컬럼으로 생성
-- 숫자에 대한 연산 ( +, -, /, *)
-- 문자에 대한 연산 ( + 가 존재하지 않음, = || )
SELECT 10-5*2, 'DB SQL 수업',
        /*userid, usernm, reg_dt, 문자열 연산은 [+] 연산이 없다 */
        usernm || '_modified', reg_dt
        
FROM users;

--NULL : 아직 모르는 값
--NULL에 대한 연산 결과는 항상 NULL이다
--DESC 테이블명 : NOT NULL로 설정되어있는 컬럼에는 값이 반드시 들어가야 한다.

--users 불필요한 데이터 삭제
DELETE users
WHERE userid NOT IN ('brown', 'sally', 'cony', 'moon', 'james');

SELECT * from users;

--null연산을 시험해보기 위해 moon의 reg_dt 컬럼을 null로 변경
UPDATE users SET reg_dt = NULL
WHERE userid = 'moon';

--users 테이블의 reg_dt 컬럼값에 5일을 더한 새로운 컬럼을 생성
SELECT userid, usernm, reg_dt, reg_dt + 5
FROM users;

--
--column alias (실습 select2)
SELECT prod_id AS id, prod_name AS name 
FROM prod;

SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod;

SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;


--문자열 컬람간 결합    (컬럼 || 컬럼, '문자열상수' || 컬럼)
--                  ( CONCAT(컬럼, 컬럼))
SELECT userid, usernm,
        userid || usernm AS id_nm
        CONCAT(userid, usernm) con_id_nm,
        -- ||을 이용해서 userid, userm, pass
        userid || usernm || pass id_nm_pass,
        -- CONCAT을 이용해서 userid, usernm, pass
        CONCAT(userid, usernm, pass) con_id_nm_pass
FROM users;

SELECT CONCAT(CONCAT(userid, usernm),pass) con_id_nm,pass
FROM users;

SELECT userid || usernm || pass id_nm_pass,
FROM users;

--사용자가 소유한 테이블 목록 조회
--LPROD -->SELECT * FROM LPROD;
SELECT 'SELECT * FROM' ||table_name || ';' AS query
       
FROM user_tables;

SELECT CONCAT(CONCAT ('SELECT * FROM',table_name ), ';')
FROM user_tables;


--WHERE : 조건이 일치하는 행만 조회하기 위해 사용
--         행에 대한 조회 기준을 작성

SELECT userid, usernm, alias, reg_dt
FROM users;


SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'brown';


--emp 테이블의 전체 데이터 조회 (모든행(row), duf(columo))
SELECT *
FROM emp;

SELECT *
FROM dept;

--부서번호(deptno)가 20보다 크거나 같은 부서에서 일하는 직원 정보 조회
SELECT *
FROM emp
WHERE deptno >= 20;

--사원번호(empno)가 7700보다 크거나 같은 사원의 정보를 조회
SELECT *
FROM emp
WHERE empno >= 7700;

--사원입사일자(hiredate)가 1982년 1월1일 이후인 사원정보 조회
-- 문자열--> 날짜 타입으로 변경 TO_DATE('날짜문자열', '날짜문자열포멧')
-- 한국 날짜 표현 : 년-월-일
-- 미국 날짜 표현 : 일-월-년
SELECT empno, ename, hiredate,
        2000 no, '문자열상수' str, TO_DATE('19820101', 'YYYYMMDD')
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');


--범위 조회 (BETWEEN 시작기준 AND 종료기준)
--시작기준, 종료기준을 포함
--사원중에서 급여(sal) 1000보다 크거나 같고, 2000보다 작거나 같은 사원 정보조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- BETWEEN AND 연산자는 부동호 연산자로 대체 가능
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000;

-- 실습 where 1
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD') AND TO_DATE('19830101', 'YYYYMMDD');


-- 실습 where2
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD') AND hiredate <= TO_DATE('19830101', 'YYYYMMDD'); 


