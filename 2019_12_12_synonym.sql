SELECT *
FROM JOO.users;

SELECT *
FROM USER_TABLES;

--78--> 79
SELECT *
FROM ALL_TABLES
WHERE OWNER = 'JOO';

SELECT *
FROM JOO.fastfood;

--JOO.fastfood--> fastfood
--생성후 다음 sql이 정상적으로 동작하는지 확인
CREATE SYNONYM fastfood FOR JOO.fastfood;
DROP SYNONYM fastfood;

SELECT*
FROM fastfood;