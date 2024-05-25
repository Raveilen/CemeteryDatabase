/* __CREATE_CEMETERY_USER__ */
ALTER SESSION SET CURRENT_SCHEMA = sys;
CREATE USER CEMETERY IDENTIFIED BY REAPER
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";




-- ROLES
GRANT "CONNECT" TO CEMETERY;
GRANT "RESOURCE" TO CEMETERY;
ALTER USER CEMETERY DEFAULT ROLE "CONNECT","RESOURCE";
GRANT CREATE TYPE TO CEMETERY;
-- SYSTEM PRIVILEGES
GRANT SELECT ANY DICTIONARY TO CEMETERY;
GRANT UNLIMITED TABLESPACE TO CEMETERY;




--PROCEDURES/FUNCTIONS ACCESS:
ALTER SESSION SET CURRENT_SCHEMA = cemetery;




/* __CREATE_TABLES__ */





CREATE TABLE RELIGIOUS_AREAS
(
    areaID NUMBER,
    religion VARCHAR(50),
    CONSTRAINT pk_areaID PRIMARY KEY(areaID)
);




CREATE OR REPLACE TYPE sector_t AS OBJECT
(
    sectorID NUMBER,
    areaID NUMBER,
    grave_count NUMBER
);




CREATE TABLE SECTORS OF sector_t (sectorID PRIMARY KEY);




CREATE OR REPLACE TYPE payment_t AS OBJECT
(
    paymentID NUMBER,
    value NUMBER,
    payment_date DATE
);




CREATE TABLE PAYMENTS OF payment_t(paymentID PRIMARY KEY);




CREATE OR REPLACE TYPE grave_t AS OBJECT
(
    graveID NUMBER,
    expiration_date DATE,
    grave_type VARCHAR(20),
    payment_ref REF payment_t,
    sector_ref REF sector_t
);





CREATE TABLE GRAVES OF grave_t (graveID PRIMARY KEY, payment_ref SCOPE IS PAYMENTS,sector_ref SCOPE IS SECTORS);




CREATE OR REPLACE TYPE funeral_t AS OBJECT
(
    funeralID NUMBER,
    funeral_date DATE,
    priest_name VARCHAR(50)
);




CREATE TABLE FUNERALS OF funeral_t (funeralID PRIMARY KEY);




CREATE OR REPLACE TYPE service_worker_t AS OBJECT
(
    workerID NUMBER,
    name varchar(50),
    surname varchar(70),
    profession varchar(50),
    phone varchar(20),
    reputation NUMBER,
    active_orders NUMBER,
    service_cost NUMBER
);





CREATE TABLE SERVICE_WORKERS OF service_worker_t (workerID PRIMARY KEY);





CREATE OR REPLACE TYPE service_workers_referencesNT AS TABLE OF REF service_worker_t;





CREATE TABLE FUNERALS_AND_SERVICES
(
    funeral REF funeral_t SCOPE IS FUNERALS,
    funeral_services service_workers_referencesNT
)
NESTED TABLE funeral_services STORE AS funeral_servicesNT;





CREATE OR REPLACE TYPE buried_t AS OBJECT
(
    personID NUMBER,
    name VARCHAR(50),
    surname VARCHAR(70),
    born DATE,
    passed DATE,
    grave_ref REF grave_t,
    funeral_ref REF funeral_t
);





CREATE TABLE BURIED OF buried_t (personID PRIMARY KEY, grave_ref SCOPE IS GRAVES,funeral_ref SCOPE IS FUNERALS);




