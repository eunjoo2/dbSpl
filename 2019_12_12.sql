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

--emp 테이블을 사용하여 synonym e를 생성
--CREATE SYNONYM 시노님 이름 FOR 오라클 객체;
CREATE SYNONYM e FOR emp;

--JOO 계정에 SYNONYM 생성 권한을 부여
GRANT CREATE SYNONYM TO JOO;














