SELECT *
FROM EMP
WHERE empno = :empno;
ALTER TABLE emp ADD CONSTRAINT PK_emp_empno PRIMARY KEY (empno); 

SELECT *
FROM EMP
WHERE ename = :ename;
ALTER TABLE emp ADD CONSTRAINT nn_emp_ename CHECK (ename IS NOT NULL); 


SELECT *
FROM EMP, DEPT
WHERE EMP.deptno = DEPT.deptno
AND EMP.deptno = emp.DEPTNO
AND EMP.empno LIKE emp.empno || '%';
CREATE INDEX idx_emp_deptno_empno ON emp (deptno, empno);


SELECT *
FROM EMP
WHERE sal BETWEEN : st_sal AND :ed_sal
AND deptno = :deptno;
CREATE INDEX idx_emp_deptno ON emp (deptno);

SELECT B.*
FROM EMP A, EMP B
WHERE A.mgr = B.empno
AND A.deptno = :deptno;
CREATE INDEX idx_emp_mgr_deptno ON emp (mgr, empno);


SELECT deptno, TO_CHAR(hiredate, 'yyyymm'),
        COUNT(*) cnt
FROM EMP
GROUP BY deptno, to_CHAR(hiredate, 'yyyymm');


CREATE UNIQUE INDEX idx_emp_u_01 ON emp (empno);
CREATE INDEX idx_emp_n_01 ON emp (deptno);

--------------------------------------------------------
--별칭 : 테이블, 컬럼을 다른 이름으로 지침
-- [AS] 별칭명
-- SELECT empno [AS] eno
-- FROM emp e

--SYNONYM (동의어)
--오라클 객체를 다른 이름으로 불르 수 있도록 하는 것
--만약에 emp 테이블을 e 라고 하는 synonym(동의어)로 생성을 하면
--다음과 같이 SQL을 작성 할 수 있다.
--SELET *
--FRM e;

--JOO 계정에 SYNONYM 생성 권한을 부여
GRANT CREATE SYNONYM TO JOO;

--emp 테이블을 사용하여 synonym e를 생성
--CREATE SYNONYM 시노님 이름 FOR 오라클 객체;
CREATE SYNONYM e FOR emp;

--emp 라는 테이블 명 대신에 e라고 하는 시노님을 사용하여 쿼리를 작성 할 수 있다
SELECT *
FROM e;

--sem계정의 fastfood 테이블을 joo2계정에서도 볼수 있도록 
--테이블 조회 권한을 부여
GRANT SELECT ON fastfood TO hr;

SELECT
    *
FROM dictionary;

--동일한 SQL의 개념에 아래 SQLemfdms ekfmek
SELECT /*201911_205*/* FROM emp;
SELECT /*201911_205*/* FROM EMP;
SELECt /*201911_205*/* FROM EMP;

SELECt /*201911_205*/* FROM EMP WHERE empno = 7369;
SELECt /*201911_205*/* FROM EMP WHERE empno = 7499;
SELECt /*201911_205*/* FROM EMP WHERE empno = :empno;


--multiple insert
DROP TABLE emp_test;

--emp테이블의 empno,ename 컬럼으로 emp_test,emp_test2 테이블을 생성
CREATE TABLE emp_test AS
SELECT empno,ename
FROM emp;

CREATE TABLE emp_test2 AS
SELECT empno,ename
FROM emp;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--uncoditinal isert
--여러 테이블에 데이터를 동시에 입력
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 9999, 'brown' FROM DUAL UNION ALL
SELECT 9998, 'cony' FROM DUAL;

SELECT *
FROM emp_Test
WHERE empno > 9000;


SELECT *
FROM emp_Test2
WHERE empno > 9000;

--------------------------------------------
ROLLBACK;
--테이블 별 입력되는 데이터의 컬럼을 제어 가능
INSERT ALL
    INTO emp_test (empno,ename) VALUES(eno,enm)
    INTO emp_test2 (empno) VALUES (eno)
SELECT 9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT 9998, 'cony' FROM DUAL;

SELECT *
FROM emp_Test
WHERE empno > 9000

UNION ALL

SELECT *
FROM emp_Test2
WHERE empno > 9000;

--CONDITIONAL INSERT
--조건에 따라 테이블에 데이터를 입력
ROLLBACK;
/*
    CASE
        WHEN 조건 THEN -----//IF
        WHEN 조건 THEN ----//ELES IF
        ESLE----            //ELSE
*/
INSERT ALL
    WHEN eno > 9000 THEN
        INTO emp_test(empno,ename) VALUES (eno,enm)
    WHEN eno > 9500 THEN
        INTO emp_test(empno,ename) VALUES (eno,enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
        
SELECT 9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT 8998, 'cony' FROM DUAL;

SELECT *
FROM emp_Test
WHERE empno > 9000

UNION ALL

SELECT *
FROM emp_Test2
WHERE empno > 8000;


ROLLBACK;

INSERT FIRST
    WHEN eno > 9000 THEN
        INTO emp_test(empno,ename) VALUES (eno,enm)
    WHEN eno > 9500 THEN
        INTO emp_test(empno,ename) VALUES (eno,enm)
    ELSE
        INTO emp_test2 (empno) VALUES (eno)
        
SELECT 9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT 8998, 'cony' FROM DUAL;

SELECT *
FROM emp_Test
WHERE empno > 9000

UNION ALL

SELECT *
FROM emp_Test2
WHERE empno > 8000;
