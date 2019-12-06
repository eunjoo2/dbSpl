-- dept 테이블에 Synonnym님을 생성하여
--  rollback 이 안돼


--DDL : TABLE 생성
--CREATTE TABLE [사용자명.]테이블명(
--      컬럼명1 컬럼타입1,
--      컬럼명2 컬럼타입2,
--      컬럼명N 컬럼타입N,
-- ranger_no NUMBER         :레인저 번호
-- ranger_nm VARCHAR2(50)   :레인저 이름
-- reg_dt DATE              :레인저 등록일자
--테이블 생성 DDL : Date Defination Language(데이터 정의어)
--DDL rollback이 없다 (자동 커밋 되므로 rollback을 할 수 없다.)

CREATE TABLE ranger(
    renger_no NUMBER,
    renger_nm VARCHAR2(50),
    reg_dt DATE);
DESC ranger;
--DDL 문장은 ROLLBACK처리가 불가!!!!!!!!!
ROLLBACK;


SELECT *
FROM user_tables
WHERE table_name = 'RANGER';


--WHERE table_name = 'ranger';
--오라클에서는 객체 생성시 소문자로 생성하더라도 내부적으로는 대문자로 관리한다.

INSERT INTO ranger VALUES(1, 'brown', sysdate);
--데이터가 조회되는 것을 확인 했음
SELECT *
FROM ranger;
--DML 문은 DDM과 다르게 ROLLBACK이 가능하다
ROLLBACK;

--ROLLBACK을 했기 떄문에 DML문장이 취소된다
SELECT *
FROM ranger;

--DESC 타입에서 필드 추출하기
--EXTRACT (필드명 FROM 컬럼/ exptession)
SELECT TO_CHAR(SYSDATE, 'YYYY') yyyy,
        TO_CHAR (SYSDATE, 'mm') mm,
        EXTRACT(year FROM SYSDATE) ex_yyyy,
        EXTRACT(month FROM SYSDATE) ex_mm
FROM dual;

--테이블 생성시 컬럼 레벨 제약조건 생성
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
--dept_test 테이블의 deptno컬럼에 PRIMARY KEY 제약조건이 있기 떄문에 
--deptno가 동일한 테이터를 입력하거나 수정할 수 없다

INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
--dept_test 데이터에 deptno 가 99번인 데이터가 있으므로 
--primary key제약조건에 의해 입력 될수 없다
--ORA-00001 unique costraint 제약 위반
--SYS-C007115 제약 조건을 어떤 제액 조건인지 판단하기 힘드므로 제약 조건에
--이름을 코딩룰에 의해 붙여주는 편이 유지보수시 편하다
INSERT INTO dept_test VALUES(99, '대덕', '대전');

--테이블 삭제후 제약조건 이름을 추가하여 제생성
--PRIMARY KEY : pk 테이블명
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT pk_ PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));

--INSERT 구문 복사
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(99, '대덕', '대전');
