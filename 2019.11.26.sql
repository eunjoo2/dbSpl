--날짜관련 함수
--ROUND, TRUNC
--(MOTNHS_BETWEEN) ADD_MONTHS, NEXT_DAY
--LAST_DAY : 해당 날짜가 속한 월의 마지막 일지(DATE)

--월 : 1, 3, 5, 7, 8, 10, 12 :31일
-- : 2 -윤년 여부 28, 29
-- : 4, 6, 9, 11 : 30일

SELECT sysdate, LAST_DAY(SYSDATE)
FROM dual;

--실습3
--해당 날짜의 마지막날짜로 이동
--일자 필드만 추출
--DATE --> 일자컬럼(DD)만 추출
--DATE --> 문자열(DD)
SELECT TO_CHAR(TO_DATE ('201912','YYYYMM'), 'YYYYMM')AS PARAM
        , TO_CHAR(LAST_DAY(TO_DATE ('201912','YYYYMM')),'DD')AS DT
FROM dual;

SELECT :yyyymm param
        ,TO_CAHR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt
FROM dual;

--SYSDATE를 YYYY/MM/DD 포맷의 문자열로 변경(DATE->CHAR)

SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'),'YYYY/MM/DD')
    --YYYY-MM-DD HH24:MI:SS
    ,TO_CHAR(SYSDATE, 'YYYY/MM/DD'),'YYYY/MM/DD'
    ,TO_CHAR(sysdate, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;


--EMPNO NOT NULL NUMBER(4)
--HIREDATE      DATE
DESC emp;

--empno가 7369인 직원 정보 조회하기
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

----------------------
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR (empno) = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

----------------------------

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

-------------------------

SELECT *
FROM emp
WHERE hiredate > = TO_DATE('1981/06/01','YYYY/MM/DD');

 --DATE타입의 묵시적 형변환은 사용을 권하지않음
 --YY -> 19
 --RR--> 50 /19 . 20
SELECT TO_DATE('81/06/01', 'RR/MM/DD')
    ,  TO_DATE('50/06/01', 'RR/MM/DD')
    ,  TO_DATE('49/06/01', 'YY/MM/DD')
FROM dual;

--숫자 --> 문자열
--문자열 --> 숫자
--숫자 : 100000000 --> 1,000,000,00(한국)
--숫자 : 100000000 --> 1.000.000,00(독일)
--날짜 포맷 : YYYY, MM, DD, HH24, MI, SS
--숫자 포맷 : 숫자 표현 :9, 자리맞춤을 위한 0표시 : 0, 화펴단위 : L
--            1000자리 구분 : , 소수점 : .
--숫자 --> 문자열 TO_CHAR(숫자, '포맷')
--숫자 포맷이 길어질 경우 숫자 자리수를 충분히 표현
SELECT empno, ename, sal, TO_CHAR(sal,'L009,999') fm_sal
FROM emp;

SELECT TO_CHAR(100000000000,'999,999,999,999,999')
FROM dual;

--NULL 처리 함수 : NVL, NVL2, NULLIF, COALESCE

--NVL(evpr1, expr2) ; 함수 인자 두개
--expr1이 NULL 이면 expr2를 반환
--expr2이 NULL 이 아니면 expr1를 반환
SELECT empno, ename, comm, NVL(comm, -1) NV1_comm
FROM emp;

---NVL2(evpr1, expr2, expr3)
--expr1 IS NOT NULL expr2 리턴
--expr1 IS NULL expr3 리턴
SELECT empno, ename, comm, NVL2(comm, 1000, -500) NV12_comm,
        NVL2(comm, comm, -500) nv1_comm --NVL과 동일한 결과
FROM emp;

--NULLIF(expt1, expr2)
--expr1 = expr2 NULL을 리턴
--expr1 != expr2 expr1을 리턴
--comm이 NULL일때comm+500 : NULL
--  NULLIF(NILL, NULL) : NULL
--comm이 NULL이 아닐때 comm +500 : comm+500
--  NULLIF(comm, comm +500) : comm
SELECT empno, ename, comm, NULLIF(comm, comm) nullif_comm
FROM emp;

--COALESCE(expr1, expr2,expr3......)
--인자중에 첫번째로 등장하는 NULL이 아닌 exprN을 리턴
--expr1 IS NOT NULL 이면 expr1 을 리턴
--expr1 IS NULL COALESCE (expr1, expr2, expr3.......)

SELECT empno, ename, comm, sal, COALESCE (comm, sal) coal_sal
FROM emp;


------실습
SELECT empno, ename, mgr
    ,nvl(mgr, 9999) as mgr_n
    , nvl2(mgr, mgr, 9999) as mgr_N_1
    , coalesce(mgr, 9999) as mgr_N_2
FROM emp;

------실습
SELECT USERID, USERNM, reg_dt
        , nvl(reg_dt,sysdate) n_REG_DT 
    
FROM users
WHERE userid NOT IN ('brown');

--condition
--case
--emp.job 컬럼을 기준으로
--'SALESMAN' 이면 sal *1.05를 적용한 값 리턴
--'MANAGER' 이면 sal *1.10를 적용한 값 리턴
--'PRESIDENT' 이면 sal *1.20를 적용한 값 리턴
--위 3가지 직군이 아닐경우 sal리턴
--empno, ename, job, sal, 요율 적중한 급여

SELECT empno, ename, job, sal,
        CASE
            WHEN job = 'SALCSMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDNT' THEN sal * 1.20
            ELSE SAL
        END bonus
        
        
    --NULL처리 함수 사용하지 않고 CASE 절을 이용하여 COMM이 NULL일 경우 -10을 리턴하도록 구성
        /*CASE
            WHEN comm IS NULL THEN -10
        END*/
FROM emp;


--DECODE
SELECT empno, ename, job, sal,
    DECODE(JOB, 'SALESMAN', sal * 1.05,
                'MANAGER', sal * 1.10,
                'PRESIDNT', sal * 1.20,
                ELSE 
FROM emp;

SEOECT

--실습 1 emp 테이블을 이용하여 deptno에 따라 부서명을 변경해서 다음과 같이 조회되는 쿼리를 작성하세요.

SELECT EMPNO ,ENAME,
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
    
FROM emp;

SELECT 
    DECODE(deptno,  10,'ACCOUNTING'
                    20,'RESEARCH'
                    30,'SALES'
                    40,'OPERATIONS'
FROM emp;
----실습 2 emp 테이블을 이용하여 hiredate 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
--(생년을 기준으로 하나 여기서는 hiredate를 기준으로 한다.)
--1. TO_CHAR(SYSDATE, 'YYYY')
--> 올해년도 구분( 0:짝수년, 1:홀수년)


SELECT empno, ename, hiredate,
        CASE
            WHEN     MOD(TO_NUMBER(TO_CHAR(hiredate, 'yy')), 2) = 1
            
            THEN '건강검진 대상자'        
            ELSE '건강검진 비대상자'
        END CONTACT_TO_DOCTOR
FROM emp;
--내년도(2020) 건강검진 대상자를 조회하는 쿼리를 작성해보세요.

SELECT empno, ename, hiredate,
        CASE
            WHEN    MOD(TO_NUMBER(TO_CHAR(hiredate,'yy')), 2) =
                    MOD(TO_CHAR(TO_DATE('2020','YYYY'),'YY'),2) --MOD(2020,2)/(SYSDATE,'YYYY')+1
            THEN '건겅검진 대상자'
            ELSE '건간검진 비대상자'
        END contact_to_doctor
FROM emp;

--실습 3 emp 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
--(생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다.)

SELECT userid, usernm, alias, reg_dt,
    CASE
        WHEN reg_dt IN NULL THEN '건강검진 비대상자'
        ELSE '건강검진 대상자'
        
    END CONTACTTODOCTOR
    
FROM users;



