CREATE TABLE REGIONS(
             REGION_ID NUMBER,
             REGION_NAME VARCHAR(25),
             CONSTRAINT pk_region_id PRIMARY KEY (REGION_ID));
    
CREATE TABLE COUNTRIES (
             COUNTRY_ID CHAR(2),
             COUNTRY_NAME VARCHAR2(40),
             REGION_ID NUMBER,
             CONSTRAINT pk_country_id PRIMARY KEY (COUNTRY_ID),
             CONSTRAINT counrt_reg_fk FOREIGN KEY (REGION_ID) 
             REFERENCES REGIONS(REGION_ID));
             
CREATE TABLE LOCATIONS (
             LOCATION_ID NUMBER(4),
             STREET_ADDRESS VARCHAR2(40),
             POSTAL_CODE VARCHAR2(12),
             CITY VARCHAR2(30),
             STATE_PROVINCE VARCHAR2(25),
             COUNTRY_ID CHAR(2),
             CONSTRAINT pk_location_id PRIMARY KEY (LOCATION_ID),
             CONSTRAINT loc_c_id_fk FOREIGN KEY (COUNTRY_ID)
             REFERENCES COUNTRIES(COUNTRY_ID),
             CONSTRAINT nn_city CHECK (CITY IS NOT NULL));
             
CREATE TABLE DEPARTMENTS (
             DEPARTMENT_ID NUMBER(4),
             DEPARTMENT_NAME VARCHAR2(30),
             MANAGER_ID NUMBER(6),
             LOCATION_ID NUMBER(4),
             CONSTRAINT pk_department_id PRIMARY KEY (DEPARTMENT_ID),
             CONSTRAINT DEPT_LOC_FK FOREIGN KEY (LOCATION_ID)
             REFERENCES LOCATIONS(LOCATION_ID),
             CONSTRAINT DEPT_MGR_FK FOREIGN KEY (MANAGER_ID)
             REFERENCES EMPLOYEES(EMPLOYEE_ID),
             CONSTRAINT nn_DEPARTMENT_NAME CHECK (DEPARTMENT_NAME IS NOT NULL));
             
CREATE TABLE JOBS (
             JOB_ID VARCHAR2(10),
             JOB_TITLE VARCHAR2(35),
             MIN_SALARY NUMBER(6),
             MAX_SALARY NUMBER(6),
             CONSTRAINT pk_job_id PRIMARY KEY (JOB_ID),
             CONSTRAINT nn_JOB_TITLE CHECK (JOB_TITLE IS NOT NULL));
             
CREATE TABLE JOB_HISTORY (
             EMPLOYEE_ID NUMBER(6),
             START_DATE DATE,
             END_DATE DATE,
             JOB_ID VARCHAR2(10),
             DEPARTMENT_ID NUMBER(4),
             CONSTRAINT pk_employee_start_date_id PRIMARY KEY (EMPLOYEE_ID, START_DATE),
             CONSTRAINT JHIST_JOB_FK FOREIGN KEY (JOB_ID)
             REFERENCES JOBS(JOB_ID),
             CONSTRAINT JHIST_EMP_FK FOREIGN KEY (EMPLOYEE_ID)
             REFERENCES EMPLOYEES(EMPLOYEE_ID),
             CONSTRAINT JHIST_DEPT_FK FOREIGN KEY (DEPARTMENT_ID)
             REFERENCES DEPARTMENTS(DEPARTMENT_ID),
             CONSTRAINT nn_END_DATE CHECK (END_DATE IS NOT NULL),
             CONSTRAINT nn_JOB_ID CHECK (JOB_ID IS NOT NULL));
             
CREATE TABLE EMPLOYEES (
             EMPLOYEE_ID NUMBER(6),
             FIRST_NAME VARCHAR2(20),
             LAST_NAME VARCHAR2(25),
             EMAIL VARCHAR2(25),
             PHONE_NUMBER VARCHAR2(20),
             HIRE_DATE DATE,
             JOB_ID VARCHAR2(10),
             SALARY NUMBER(8, 2),
             COMMISSION_PCT NUMBER(2, 2),
             MANAGER_ID NUMBER(6),
             DEPARTMENT_ID NUMBER(4),
             CONSTRAINT pk_employee_id PRIMARY KEY (EMPLOYEE_ID),
             CONSTRAINT EMP_MANAGER_FK FOREIGN KEY (MANAGER_ID)
             REFERENCES EMPLOYEES(EMPLOYEE_ID),
             CONSTRAINT EMP_JOB_FK FOREIGN KEY (JOB_ID)
             REFERENCES JOBS(JOB_ID),
             CONSTRAINT EMP_DEPT_FK FOREIGN KEY (DEPARTMENT_ID)
             REFERENCES DEPARTMENTS(DEPARTMENT_ID,
             CONSTRAINT nn_LAST_NAME CHECK (LAST_NAME IS NOT NULL),
             CONSTRAINT nn_EMAIL CHECK (EMAIL IS NOT NULL),
             CONSTRAINT HIRE_DATE CHECK (HIRE_DATE IS NOT NULL),
             CONSTRAINT JOB_ID CHECK (JOB_ID IS NOT NULL));
             
             
             
             
             
             