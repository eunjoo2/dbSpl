--CROSS 실습
SELECT *
FROM CUSTOMER CROSS JOIN PRODUCT;

--도시발전지수
--손으로 계산해서 도시발전 지수를 계산
--대전시 유성구  0.5
--대전시 동구    0.5
--대전시 중구    1.16
--대전시 서구    1.41
--대전시 대덕구   0.28
SELECT *
FROM FASTFOOD
WHERE sido = '대전광역시'
AND SIGUNGU = '서구'
AND GB NOT IN ('파파이스','맘스터치')
AND GB = GB
ORDER BY GB;

SELECT *
FROM FASTFOOD
WHERE sido = '대전광역시'
AND SIGUNGU = '동구'
AND GB NOT IN ('파파이스','맘스터치')
AND GB = GB
ORDER BY GB;

SELECT *
FROM FASTFOOD
WHERE sido = '대전광역시'
AND SIGUNGU = '유성구'
AND GB NOT IN ('파파이스','맘스터치')
AND GB = GB
ORDER BY GB;

SELECT *
FROM FASTFOOD
WHERE sido = '대전광역시'
AND SIGUNGU = '중구'
AND GB NOT IN ('파파이스','맘스터치')
AND GB = GB
ORDER BY GB;

SELECT *
FROM FASTFOOD
WHERE sido = '대전광역시'
AND SIGUNGU = '대덕구'
AND GB NOT IN ('파파이스','맘스터치')
AND GB = GB
ORDER BY GB;



SELECT R
FROM (SELECT SIDO ,SIGUNGU
    FROM FASTFOOD
    WHERE GB IN ('버거킹','KFC','맥도날드')
    GROUP BY SIDO, SIGUNGU) a
    ,(SELECT SIDO, SIGUNGU
    
    FROM FASTFOOD
    WHERE GB IN ('롯데리아')
    GROUP BY SIDO, SIGUNGU) b;
    
    
SELECT rownum 순위, dd.sido 시도, dd.sigungu 시군구, dd.cnt 도시발전지수
FROM
    (SELECT rownum, a.sido, a.sigungu, round(bcnt/lcnt,1) cnt
    FROM
        (SELECT sido, sigungu, count(sigungu) bcnt
         FROM fastfood
         WHERE gb IN ('버거킹','맥도날드','KFC')
         GROUP BY sido, sigungu)a,
        (SELECT sido, sigungu, count(sigungu) lcnt
         FROM fastfood
         WHERE gb = '롯데리아'
         GROUP BY sido, sigungu)b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY cnt DESC)dd;



-- 5
--도시발전지수가 높은 순으로 나열
--도시발전지수 = (버거킹개수 + KFC 개수 +맥도날드 개수) / 롯데리아 개수
--순위 / 시도 / 시군구/ 도시잘전 지수(소수점 둘째 자리에서 반올림)
--1 / 서울 특별시/ 서초구 / 7.5
--2 / 서울특별시 / 경남/ 72.3

--해당 시도, 시군구별 프렌차이즈별 건수가 필요
  SELECT ROWNUM 순위, SIDO,SIGUNGU, 도시발전지수
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
        ORDER BY 도시발전지수 DESC);
        
        SELECT
            *
        FROM FASTFOOD;
SELECT
    *
FROM FASTFOOD,TAX;

    