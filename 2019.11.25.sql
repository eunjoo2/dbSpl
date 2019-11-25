--row_1 : emp테이블에서 (empmo, ename) 정렬없이 ROWNUM이 1~ 10인 행만 조회

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

--row_2 : emp테이블에서 (empmo, ename) 정렬없이 ROWNUM이 11~ 14인 행만 조회
SELECT ROWNUM, a. *
FROM
        (SELECT ROWNUM rn, empno, ename
        FROM emp) a
WHERE rn BETWEEN 11 AND 14;

--row_3
SELECT *
FROM  
   ( SELECT ROWNUM rn, a. empno, ename 
    FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename)a)
WHERE rn BETWEEN  11 AND 14;
    
    
    
SELECT *
FROM
    ( SELECT a. empno, ename
        FROM
            (SELECT ROWNUM rn, empno, ename
             FROM emp
            ORDER BY ename) a )
            
    WHERE rn BETWEEN 11 AND 14;
    
    
    
--DUAL 테이블 : sys 계정에 있는 누구나 가용가능한 테이블이며 데이터는 한행만 존재하며 컬럼(dummy)도 하나 존재('X')

SELECT *
FROM dyal;

--SINGLE ROW FUNCTION : 행당 한번의 F 이 실행 
-- 1개의 행 INPUT -> 1개의 행으로 OUTPUT (COLUMN)
-- 'HELLO, Worid'
--dual 테이블에는 데이터가 하나의 행만 존재한다. 결과도 하나의 행으로 나온다
SELECT LOWER('HELLO, Worid')low, UPPER('HELLO, Worid')upper,
        INITCAP ('HELLO, Worid')
FROM dual;

--아래 쿼리는 결과도 14개의 행
SELECT LOWER('HELLO, Worid')low, UPPER('HELLO, Worid')upper,
        INITCAP ('HELLO, Worid')
FROM emp;
--컬럼에 function
SELECT empno, LOWER(ename) iow_enm
FROM emp
WHERE ename = UPPER('smith'); --직원 이름이 smith인 사람을 조회 하려면 대문자. 원본 데이터에 저장되어 있는 

--테이블 컬럼을 가공해도 동일한 결과를 얻을 수 있지만 테이블 컬럼보다는 상수쪽을 가공하는 것이 속도면에서 유리
-- 해당 컬럼에 인덱스가 존재하더라도 함수를 적용하게되면 값이 달라지게 되어 인덱스를 활용 할 수 없게 된다.
--예외 : FBI(Function Based Index)
SELECT empno, LOWER(ename) iow_enm
FROM emp
WHERE LOWER(ename) = 'smith';

--HELLO
--,
--WORLD
--HELLO, WORLD (위 3가지 문자열 상수를 이용, CONCAT 함수를 사용하여 문자열 결합)

SELECT CONCAT CONCAT('HELLO'(, ', ', 'WORLD')),
        SUBSTR('HELLO, WORLD')
        LENGTH('HELLO, WORLD')
FROM dual;

SELECT CONCAT (CONCAT ('HELLO', ','), 'WORLD') C1,
        'HELLO' || ',' || 'WORLD',
        --시작인텍스는 1부터, 종료인덱스 문자열까지 포함한다
        --S (문자열,시작인덱스, 종료인덱스)
        --INSTR : 문자열에 특정문자열이 존재하는지, 존재할 경우 문자의 인덱스를 리턴
         --'HELLO, WORLD', 문자열의 4번째 인덱스 이후에 등장하는 '0'문자열
           --문자열의 특정 인덱스 이후부터 검색 하도록
        SUBSTR('HELLO, WORLD', 1 , 5) i1,     
        INSTR('HELLO, WORLD', '0') i2,
  
       INSTR('HELLO, WORLD', '1','6') i3,
       LPAD('HELLO, WORLD', 15, '*') L1,
       RPAD('HELLO, WORLD', 15, '*') R1,
       
       --REPLACE(대상문자열, 검색문자열, 변경할 문자열)
       --대상문자열에서 검색 문자열 변셩할 문자열로 치환
       
       REPLACE('HELLO, WORLD', 'HELLO', 'hello') rep1, --hello, WORLD
       
       --문자열 앞, 뒤의 공백을 제거
       '    HELLO, WORLD    ' before_trim,
       TRIM('   HELLO, WORLD    ') after_trim,
       TRIM('B' FROM 'HELLO, WORLD') after_trim2
FROM dual;

--숫자 조작함수
--ROUND : 반올림 -ROUND (숫자, 반올림 자리)
--TRUNC : 절삭 - TRONC (숫자, 절삭 자리)
--MOD : 나머지 연산 MOD (피제제수, 제수)// MOD(5, 2) : 1

SELECT 'Y'
SELECT CONCAT (CONCAT ('HELLO', ','), 'WORLD') C1,
        'HELLO' || ',' || 'WORLD',
        --시작인텍스는 1부터, 종료인덱스 문자열까지 포함한다
        --S (문자열,시작인덱스, 종료인덱스)
        --INSTR : 문자열에 특정문자열이 존재하는지, 존재할 경우 문자의 인덱스를 리턴
         --'HELLO, WORLD', 문자열의 4번째 인덱스 이후에 등장하는 '0'문자열
           --문자열의 특정 인덱스 이후부터 검색 하도록
        SUBSTR('HELLO, WORLD', 1 , 5) i1,     
        INSTR('HELLO, WORLD', '0') i2,

       INSTR('HELLO, WORLD', '1','6') i3,
       LPAD('HELLO, WORLD', 15, '*') L1,
       RPAD('HELLO, WORLD', 15, '*') R1,

       --REPLACE(대상문자열, 검색문자열, 변경할 문자열)
       --대상문자열에서 검색 문자열 변셩할 문자열로 치환

       REPLACE('HELLO, WORLD', 'HELLO', 'hello') rep1, --hello, WORLD

       --문자열 앞, 뒤의 공백을 제거
       '    HELLO, WORLD    ' before_trim,
       TRIM('   HELLO, WORLD    ') after_trim,
       TRIM('B' FROM 'HELLO, WORLD') after_trim2
FROM dual;

--반올림결과가 소수점한자리까지 나오도록 (소수점 둘째자리에서 반올림
SELECT  ROUND(105.54, 1) r1, 
        ROUND(105.55, 1) r2,  --반올림 결과가 소숫점 1자리
        ROUND(105.55, 0) r3 ,--반올림 결과가 소숫점 0자리
        ROUND(105.55, -1) r4 --정수 첫번째 저리에서 반올림
FROM dual;



 
 
SELECT  TRUNC(105.54, 1) t1, --내림결과 소숫점
        TRUNC(105.55, 1) t2, 
        TRUNC(105.55, 0) t3, --소수점 첫번째 자리에서 절삭
        TRUNC(105.55, -1) t4 -- 정수 첫번째 자리에서 절삭
FROM dual;

--MOD(피제수, 제수) 피제수를 제수로 나눈 나머지 값
--MOD(M, 2) 의 결과 종류: 0, 1(0~제수~1)
SELECT MOD(5, 2) M1 -- 5/2 : 몫이 2, [나머지 1]
FROM dual;

--emp 테이블의 sal 컬럼을 1000으로 나눴을때 사원별 값을 조회하는 sql 작성
--ename, sal, sal/1000을 때의 몫, sal/1000을 때의 나머지

SELECT ename, sal, TRUNC(sal/1000), MOD(sal, 1000)/*,
        TRUNC(sal/1000) * 1000 + MOD(sal, 1000)*/
FROM emp;

--DATE : 년원일, 시간, 분, 초
SELECT ename, hiredate, TO_CHAR(hiredate, 'YYYY/MM/DD hh24-mi-ss')--YYYY/MM/DD
FROM emp;

--SYSDATE : 서버의 현자 DATE를 리턴하는 내장함수, 특별한 인자가 없다
--DATE 연산 DATE + 정수N = DATE에 N일자만큼 더한다
--DATE 연산에 있어서 정수는 일자
--하루는 24시간
--DATE 타입에 시간을 더할 수 도 있다 1시간 = 1/24
SELECT TO_CHAR (SYSDATE+5, 'YYYY-MM-DD hh24:mi:ss') AFTER5_DAYS,
        TO_CHAR (SYSDATE+5/24, 'YYYY-MM-DD hh24:mi:ss') AFTER5_HOURS,
        TO_CHAR (SYSDATE+5/24/60, 'YYYY-MM-DD hh24:mi:ss') AFTER5_MIN
FROM dual;

--실습 (date 1)

SELECT TO_DATE('19/12/31', 'YY/MM/DD') LASTDAY,
        TO_DATE('19/12/31', 'YY/MM/DD')-5 LASTDAY_BEFORE5,
        SYSDATE NOW,
        SYSDATE-3 NOW_BEFORE3

FROM dual;

--YYYY, MM, DD, D(요일을 숫자로 : 일요일 1,월요일 2, 화요일 3....토요일 7)
--IW(주차 1~53), HH, MI, SS
SELECT 
        TO_CHAR(SYSDATE, 'YYYY') YYYY --현재년도
        ,TO_CHAR(SYSDATE, 'MM') MM --현재월
        ,TO_CHAR(SYSDATE, 'DD') DD --현재일
        ,TO_CHAR(SYSDATE, 'D') D -- 현재요일(주간일자 1-7)
        ,TO_CHAR(SYSDATE, 'IW') IW --현재 일자의 주차(해당주의 목요일을 주차의 기준)
        --2019 12월 31일은 몇주차가 나오는가
        ,TO_CHAR(TO_DATE('20191231','YYYYMMDD'),'IW') IW_20191231
FROM DUAL;


--실습 (FN2)
SELECT
        TO_CHAR(SYSDATE, 'YYYY-MM-DD')DT_DASH ,
        TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss')DT_DASH_WITH_TIME,
        TO_CHAR(SYSDATE, 'DD-MM-YYYY')DT_DD_MM_YYYY
FROM DUAL;

--DATE타입의 ROUND, TRUNC 적용
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now,
        --MM에서 반올림
       TO_CHAR(ROUND(SYSDATE, 'YYYY'),'YYYY-MM-DD hh24:mi:ss') now_YYYY
       --DD에서 반올림
       TO_CHAR(ROUND(SYSDATE, 'MM'),'YYYY-MM-DD hh24:mi:ss') now_MM
     --hh24에서 반올림
        TO_CHAR(ROUND(SYSDATE, 'MM'),'YYYY-MM-DD hh24:mi:ss') now_MM 
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now,
        --MM에서 내림
       TO_COAR(TRUNC(SYSDATE, 'YYYY'),'YYYY-MM-DD hh24:mi:ss') now_YYYY
       --DD에서 내림
       TO_CHAR(TRUNC(SYSDATE, 'MM'),'YYYY-MM-DD hh24:mi:ss') now_MM
     --hh24에서 내림
        TO_CHAR(TRUNC(SYSDATE, 'MM'),'YYYY-MM-DD hh24:mi:ss') now_MM 
FROM DUAL;

--날짜 조작 함수
--MONTHS_BETWEEN (date1, date2) : date2와 date1 사이의 개월수
--ADD_MONTHS (date, 가감할 개월수) : date에서 특정 개월수를 더하거나 뺀 날짜
--NEXT_DAY(date, weekday (1~7) : date이후 첫번째 weekday 날짜
--LAST_DAY(date) ; date가 속한 월의 마지막 날짜

--MONTHS_BETWEEN(date1, date2)
SELECT MONTHS_BETWEEN (TO_DATE('2019-11-25', 'YYYY-MM-DD'), 
                        TO_DATE('2019-03-31', 'YYYY-MM-DD')) m_bet,
TO_DATE('2019-11-25','YYYY-MM-DD') - TO_DATE('2019-03-31', 'YYYY-MM-DD') d_m
FROM dual;

--ADD_MONTHS(date,number(=, -) )
SELECT ADD_MONTHS(TO_DATE('20191125', 'YYYYMMDD'), 5) NOW_AFTER5M
    ,ADD_MONTHS(TO_DATE('20191125', 'YYYYMMDD'), -5) MOW_BEFORE5M
    ,SYSDATE +100 --100일 뒤의 날짜 (월 개념 3~31,2-28?29)
    
FROM DUAL;

--NEXT_DAY(date, weekday number(1-7))
SELECT NEXT_DAY (SYSDATE, 7) --오늘 날짜이후 등장하는 첫번째 토요일의 날짜
FROM dual;