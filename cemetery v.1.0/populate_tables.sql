ALTER SESSION SET CURRENT_SCHEMA = cemetery;

/* __POPULATE_TABLES__*/

--RELIGIOUS AREA
INSERT INTO religious_areas (areaid,religion) VALUES (1,'catholic');
INSERT INTO religious_areas (areaid,religion) VALUES (2,'evangelical');
INSERT INTO religious_areas (areaid,religion) VALUES (3,'municipal');
INSERT INTO religious_areas (areaid,religion) VALUES (4,'military');

--SECTORS
INSERT INTO SECTORS values(1,1,0);
INSERT INTO SECTORS values(2,1,0);
INSERT INTO SECTORS values(3,1,0);
INSERT INTO SECTORS values(4,2,0);
INSERT INTO SECTORS values(5,2,0);
INSERT INTO SECTORS values(6,2,0);
INSERT INTO SECTORS values(7,3,0);
INSERT INTO SECTORS values(8,3,0);
INSERT INTO SECTORS values(9,3,0);
INSERT INTO SECTORS values(10,4,0);
INSERT INTO SECTORS values(11,4,0);
INSERT INTO SECTORS values(12,4,0);


--PAYMENT

DECLARE
    payment_iterator NUMBER;
BEGIN
    payment_iterator := 0;
    FOR i IN 1..6 LOOP
        payment_iterator := payment_iterator + 1;
        INSERT INTO PAYMENTS VALUES(payment_iterator,1350,TO_DATE('2011-07-13','YYYY-MM-DD'));
        payment_iterator := payment_iterator + 1;
        INSERT INTO PAYMENTS VALUES(payment_iterator,1200,TO_DATE('2005-12-05','YYYY-MM-DD'));
        payment_iterator := payment_iterator + 1;
        INSERT INTO PAYMENTS VALUES(payment_iterator,1120,TO_DATE('2007-11-27','YYYY-MM-DD'));
        payment_iterator := payment_iterator + 1;
        INSERT INTO PAYMENTS VALUES(payment_iterator,1290,TO_DATE('2015-02-07','YYYY-MM-DD'));
        payment_iterator := payment_iterator + 1;
        INSERT INTO PAYMENTS VALUES(payment_iterator,1400,TO_DATE('2010-01-19','YYYY-MM-DD'));
        payment_iterator := payment_iterator + 1;
        INSERT INTO PAYMENTS VALUES(payment_iterator,2500,TO_DATE('2012-04-08','YYYY-MM-DD'));
        payment_iterator := payment_iterator + 1;
        INSERT INTO PAYMENTS VALUES(payment_iterator,1345,TO_DATE('2007-08-08','YYYY-MM-DD'));
        payment_iterator := payment_iterator + 1;
        INSERT INTO PAYMENTS VALUES(payment_iterator,1310,TO_DATE('2007-03-20','YYYY-MM-DD'));
        payment_iterator := payment_iterator + 1;
        INSERT INTO PAYMENTS VALUES(payment_iterator,1390,TO_DATE('2009-05-18','YYYY-MM-DD'));
        payment_iterator := payment_iterator + 1;
        INSERT INTO PAYMENTS VALUES(payment_iterator,1366,TO_DATE('2005-10-06','YYYY-MM-DD'));
    END LOOP;
END;

COMMIT;

    INSERT INTO PAYMENTS VALUES(61,1380,TO_DATE('2010-06-17','YYYY-MM-DD'));
    INSERT INTO PAYMENTS VALUES(62,1200,TO_DATE('2005-12-05','YYYY-MM-DD'));
    INSERT INTO PAYMENTS VALUES(63,1310,TO_DATE('2007-03-20','YYYY-MM-DD'));
    INSERT INTO PAYMENTS VALUES(64,1290,TO_DATE('2015-02-07','YYYY-MM-DD'));
    COMMIT;


--GRAVES
DECLARE
    payment_iter NUMBER;
    sector_iter NUMBER;
BEGIN
    payment_iter := 0;
    sector_iter := 0;
    FOR i IN 1..6 LOOP
        payment_iter := payment_iter+1;
        sector_iter := MOD(payment_iter,12) + 1;
        GRAVE_UTILS.add_grave(payment_iter,TO_DATE('2031-07-13','YYYY-MM-DD'),'stone',payment_iter,sector_iter);
         payment_iter := payment_iter+1;
        sector_iter := MOD(payment_iter,12) + 1;
        GRAVE_UTILS.add_grave(payment_iter,TO_DATE('2025-12-05','YYYY-MM-DD'),'frame',payment_iter,sector_iter);
        payment_iter := payment_iter+1;
        sector_iter := MOD(payment_iter,12) + 1;
        GRAVE_UTILS.add_grave(payment_iter,TO_DATE('2027-11-27','YYYY-MM-DD'),'frame',payment_iter,sector_iter);
         payment_iter := payment_iter+1;
        sector_iter := MOD(payment_iter,12) + 1;
        GRAVE_UTILS.add_grave(payment_iter,TO_DATE('2035-02-07','YYYY-MM-DD'),'stone',payment_iter,sector_iter);
        payment_iter := payment_iter+1;
        sector_iter := MOD(payment_iter,12) + 1;
        GRAVE_UTILS.add_grave(payment_iter,TO_DATE('2030-01-19','YYYY-MM-DD'),'stone',payment_iter,sector_iter);
         payment_iter := payment_iter+1;
        sector_iter := MOD(payment_iter,12) + 1;
        GRAVE_UTILS.add_grave(payment_iter,TO_DATE('2032-04-08','YYYY-MM-DD'),'malsoleum',payment_iter,sector_iter);
        payment_iter := payment_iter+1;
        sector_iter := MOD(payment_iter,12) + 1;
        GRAVE_UTILS.add_grave(payment_iter,TO_DATE('2027-08-08','YYYY-MM-DD'),'stone',payment_iter,sector_iter);
         payment_iter := payment_iter+1;
        sector_iter := MOD(payment_iter,12) + 1;
        GRAVE_UTILS.add_grave(payment_iter,TO_DATE('2027-03-20','YYYY-MM-DD'),'stone',payment_iter,sector_iter);
        payment_iter := payment_iter+1;
        sector_iter := MOD(payment_iter,12) + 1;
        GRAVE_UTILS.add_grave(payment_iter,TO_DATE('2029-05-18','YYYY-MM-DD'),'stone',payment_iter,sector_iter);
         payment_iter := payment_iter+1;
        sector_iter := MOD(payment_iter,12) + 1;
        GRAVE_UTILS.add_grave(payment_iter,TO_DATE('2025-10-06','YYYY-MM-DD'),'frame',payment_iter,sector_iter);
    END LOOP;
END;

COMMIT;

EXECUTE GRAVE_UTILS.add_grave(61,TO_DATE('2030-06-17','YYYY-MM-DD'),'stone',61,2);
EXECUTE GRAVE_UTILS.add_grave(62,TO_DATE('2025-10-06','YYYY-MM-DD'),'frame',62,3);
EXECUTE GRAVE_UTILS.add_grave(63,TO_DATE('2027-08-08','YYYY-MM-DD'),'stone',63,4);
EXECUTE GRAVE_UTILS.add_grave(64,TO_DATE('2035-02-07','YYYY-MM-DD'),'stone',64,1);

COMMIT;


--FUNERALS
EXECUTE FUNERAL_UTILS.set_debug_for_archival_data(1);

EXECUTE FUNERAL_UTILS.add_funeral(1,to_date('2008-05-15','YYYY-MM-DD'),'BROWN');
EXECUTE FUNERAL_UTILS.add_funeral(2,to_date('1995-09-03','YYYY-MM-DD'),'WHITE');
EXECUTE FUNERAL_UTILS.add_funeral(3,to_date('2010-06-20','YYYY-MM-DD'),'SAINT');
EXECUTE FUNERAL_UTILS.add_funeral(4,to_date('2022-12-10','YYYY-MM-DD'),'WITHERS');
EXECUTE FUNERAL_UTILS.add_funeral(5,to_date('1978-04-05','YYYY-MM-DD'),'BLAKE');
EXECUTE FUNERAL_UTILS.add_funeral(6,to_date('2015-11-28','YYYY-MM-DD'),'WILSON');
EXECUTE FUNERAL_UTILS.add_funeral(7,to_date('2002-02-18','YYYY-MM-DD'),'CLARK');

EXECUTE FUNERAL_UTILS.add_funeral(8,to_date('1999-08-07','YYYY-MM-DD'),'BROWN');
EXECUTE FUNERAL_UTILS.add_funeral(9,to_date('1985-10-12','YYYY-MM-DD'),'WHITE');
EXECUTE FUNERAL_UTILS.add_funeral(10,to_date('2012-01-25','YYYY-MM-DD'),'SAINT');
EXECUTE FUNERAL_UTILS.add_funeral(11,to_date('2006-07-14','YYYY-MM-DD'),'WITHERS');
EXECUTE FUNERAL_UTILS.add_funeral(12,to_date('1990-11-09','YYYY-MM-DD'),'BLAKE');
EXECUTE FUNERAL_UTILS.add_funeral(13,to_date('2004-06-06','YYYY-MM-DD'),'WILSON');
EXECUTE FUNERAL_UTILS.add_funeral(14,to_date('2019-03-02','YYYY-MM-DD'),'CLARK');

EXECUTE FUNERAL_UTILS.add_funeral(15,to_date('2016-09-28','YYYY-MM-DD'),'BROWN');
EXECUTE FUNERAL_UTILS.add_funeral(16,to_date('1988-12-17','YYYY-MM-DD'),'WHITE');
EXECUTE FUNERAL_UTILS.add_funeral(17,to_date('2014-08-03','YYYY-MM-DD'),'SAINT');
EXECUTE FUNERAL_UTILS.add_funeral(18,to_date('2000-05-09','YYYY-MM-DD'),'WITHERS');
EXECUTE FUNERAL_UTILS.add_funeral(19,to_date('2011-10-30','YYYY-MM-DD'),'BLAKE');
EXECUTE FUNERAL_UTILS.add_funeral(20,to_date('1997-04-21','YYYY-MM-DD'),'WILSON');
EXECUTE FUNERAL_UTILS.add_funeral(21,to_date('2009-11-06','YYYY-MM-DD'),'CLARK');

EXECUTE FUNERAL_UTILS.add_funeral(22,to_date('2003-10-05','YYYY-MM-DD'),'BROWN');
EXECUTE FUNERAL_UTILS.add_funeral(23,to_date('2015-06-10','YYYY-MM-DD'),'WHITE');
EXECUTE FUNERAL_UTILS.add_funeral(24,to_date('2013-09-04','YYYY-MM-DD'),'SAINT');
EXECUTE FUNERAL_UTILS.add_funeral(25,to_date('2007-12-28','YYYY-MM-DD'),'WITHERS');
EXECUTE FUNERAL_UTILS.add_funeral(26,to_date('2005-03-04','YYYY-MM-DD'),'BLAKE');
EXECUTE FUNERAL_UTILS.add_funeral(27,to_date('1982-07-19','YYYY-MM-DD'),'WILSON');
EXECUTE FUNERAL_UTILS.add_funeral(28,to_date('2018-02-13','YYYY-MM-DD'),'CLARK');

EXECUTE FUNERAL_UTILS.add_funeral(29,to_date('2010-02-08','YYYY-MM-DD'),'BROWN');
EXECUTE FUNERAL_UTILS.add_funeral(30,to_date('1998-05-29','YYYY-MM-DD'),'WHITE');
EXECUTE FUNERAL_UTILS.add_funeral(31,to_date('2012-11-12','YYYY-MM-DD'),'SAINT');
EXECUTE FUNERAL_UTILS.add_funeral(32,to_date('2016-04-03','YYYY-MM-DD'),'WITHERS');
EXECUTE FUNERAL_UTILS.add_funeral(33,to_date('2008-01-07','YYYY-MM-DD'),'BLAKE');
EXECUTE FUNERAL_UTILS.add_funeral(34,to_date('2001-09-25','YYYY-MM-DD'),'WILSON');
EXECUTE FUNERAL_UTILS.add_funeral(35,to_date('2014-12-14','YYYY-MM-DD'),'CLARK');

EXECUTE FUNERAL_UTILS.add_funeral(36,to_date('2008-05-15','YYYY-MM-DD'),'BROWN');
EXECUTE FUNERAL_UTILS.add_funeral(37,to_date('1995-09-03','YYYY-MM-DD'),'WHITE');
EXECUTE FUNERAL_UTILS.add_funeral(38,to_date('2010-06-20','YYYY-MM-DD'),'SAINT');
EXECUTE FUNERAL_UTILS.add_funeral(39,to_date('2022-12-10','YYYY-MM-DD'),'WITHERS');
EXECUTE FUNERAL_UTILS.add_funeral(40,to_date('1978-04-05','YYYY-MM-DD'),'BLAKE');
EXECUTE FUNERAL_UTILS.add_funeral(41,to_date('2015-11-28','YYYY-MM-DD'),'WILSON');
EXECUTE FUNERAL_UTILS.add_funeral(42,to_date('2002-02-18','YYYY-MM-DD'),'CLARK');

EXECUTE FUNERAL_UTILS.add_funeral(43,to_date('1999-08-07','YYYY-MM-DD'),'BROWN');
EXECUTE FUNERAL_UTILS.add_funeral(44,to_date('1985-10-12','YYYY-MM-DD'),'WHITE');
EXECUTE FUNERAL_UTILS.add_funeral(45,to_date('2012-01-25','YYYY-MM-DD'),'SAINT');
EXECUTE FUNERAL_UTILS.add_funeral(46,to_date('2006-07-14','YYYY-MM-DD'),'WITHERS');
EXECUTE FUNERAL_UTILS.add_funeral(47,to_date('1990-11-09','YYYY-MM-DD'),'BLAKE');
EXECUTE FUNERAL_UTILS.add_funeral(48,to_date('2004-06-06','YYYY-MM-DD'),'WILSON');
EXECUTE FUNERAL_UTILS.add_funeral(49,to_date('2019-03-02','YYYY-MM-DD'),'CLARK');

EXECUTE FUNERAL_UTILS.add_funeral(50,to_date('2016-09-28','YYYY-MM-DD'),'BROWN');
EXECUTE FUNERAL_UTILS.add_funeral(51,to_date('1988-12-17','YYYY-MM-DD'),'WHITE');
EXECUTE FUNERAL_UTILS.add_funeral(52,to_date('2014-08-03','YYYY-MM-DD'),'SAINT');
EXECUTE FUNERAL_UTILS.add_funeral(53,to_date('2000-05-09','YYYY-MM-DD'),'WITHERS');
EXECUTE FUNERAL_UTILS.add_funeral(54,to_date('2011-10-30','YYYY-MM-DD'),'BLAKE');
EXECUTE FUNERAL_UTILS.add_funeral(55,to_date('1997-04-21','YYYY-MM-DD'),'WILSON');
EXECUTE FUNERAL_UTILS.add_funeral(56,to_date('2009-11-06','YYYY-MM-DD'),'CLARK');

EXECUTE FUNERAL_UTILS.add_funeral(57,to_date('2003-10-05','YYYY-MM-DD'),'BROWN');
EXECUTE FUNERAL_UTILS.add_funeral(58,to_date('2015-06-10','YYYY-MM-DD'),'WHITE');
EXECUTE FUNERAL_UTILS.add_funeral(59,to_date('2013-09-04','YYYY-MM-DD'),'SAINT');
EXECUTE FUNERAL_UTILS.add_funeral(60,to_date('2007-12-28','YYYY-MM-DD'),'WITHERS');
EXECUTE FUNERAL_UTILS.add_funeral(61,to_date('2005-03-04','YYYY-MM-DD'),'BLAKE');
EXECUTE FUNERAL_UTILS.add_funeral(62,to_date('1982-07-19','YYYY-MM-DD'),'WILSON');
EXECUTE FUNERAL_UTILS.add_funeral(63,to_date('2018-02-13','YYYY-MM-DD'),'CLARK');

EXECUTE FUNERAL_UTILS.add_funeral(64,to_date('2010-02-08','YYYY-MM-DD'),'BROWN');
EXECUTE FUNERAL_UTILS.add_funeral(65,to_date('1998-05-29','YYYY-MM-DD'),'WHITE');
EXECUTE FUNERAL_UTILS.add_funeral(66,to_date('2012-11-12','YYYY-MM-DD'),'SAINT');
EXECUTE FUNERAL_UTILS.add_funeral(67,to_date('2016-04-03','YYYY-MM-DD'),'WITHERS');
EXECUTE FUNERAL_UTILS.add_funeral(68,to_date('2008-01-07','YYYY-MM-DD'),'BLAKE');
EXECUTE FUNERAL_UTILS.add_funeral(69,to_date('2001-09-25','YYYY-MM-DD'),'WILSON');
EXECUTE FUNERAL_UTILS.add_funeral(70,to_date('2014-12-14','YYYY-MM-DD'),'CLARK');
EXECUTE FUNERAL_UTILS.set_debug_for_archival_data(0);

COMMIT;

--SERVICE_WORKERS:
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(1,'Joshua','Sanchez','stonemason','(555) 123-4567',1,1100);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(2,'Stephanie','Jenkins','flautist','(555) 987-6543',2,250);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(3,'Eric','Perez','trumpeter','(555) 555-1212',1,345);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(4,'Christina','Hill','florist','(555) 867-5309',1,100);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(5,'Patrick ','Barnes','stonemason','(555) 555-1234',3,900);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(6,'Lindsey','Powell','stonemason','(555) 123-7890',2,980);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(7,'Olivia','Carter' ,'flautists','(555) 888-9999',1,320);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(8,'Samantha','Green' ,'embalmer','(555) 234-5678',1,400);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(9,'Justin','Rodriguez' ,'stonemason','(555) 456-7890',1,1250);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(10,'Jacob','Hughes' ,'stonemason','(555) 321-6547',2,1150);

EXECUTE SERVICE_WORKER_UTILS.add_service_worker(11,'Zahary','Barnes' ,'stonemason','(555) 321-6547',3,990);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(12,'Nathan','Wood' ,'florist','(555) 555-5678',2,95);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(13,'Brittany','Price' ,'florist','(555) 876-5432',1,115);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(14,'Lucas','Stewart' ,'florist','(555) 234-5678',2,98);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(15,'Austin','Peterson' ,'stonemason','(555) 890-1234',2,1050);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(16,'Brandon','Coleman' ,'trumpeter','(555) 987-6543',2,320);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(17,'James','Coleman' ,'trumpeter','(555) 222-3333',1,375);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(18,'Rebecca','Bell' ,'trumpeter','(555) 789-0123',2,350);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(19,'Daniel','Evans' ,'flautist','(555) 666-7777',3,200);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(20,'Amanda','Bennett' ,'flautist','(555) 987-6543',2,225);

EXECUTE SERVICE_WORKER_UTILS.add_service_worker(21,'Kayla','Richardson' ,'embalmer','(555) 876-5432',2,375);
EXECUTE SERVICE_WORKER_UTILS.add_service_worker(22,'David','Morris' ,'embalmer','(555) 345-6789',2,385);

COMMIT;


--BURIED
EXECUTE BURIED_UTILS.create_buried(1,'John','Smith',to_date('1950-01-10','YYYY-MM-DD'),to_date('2008-05-12','YYYY-MM-DD'),10,1);
EXECUTE BURIED_UTILS.create_buried(2,'Brian','Smith',to_date('1950-01-10','YYYY-MM-DD'),to_date('2008-05-12','YYYY-MM-DD'),10,1);
EXECUTE BURIED_UTILS.create_buried(3,'Emily','Johnson',to_date('1978-05-20','YYYY-MM-DD'),to_date('1995-09-01','YYYY-MM-DD'),1,2);
EXECUTE BURIED_UTILS.create_buried(4,'Michael','Williams',to_date('1952-11-15','YYYY-MM-DD'),to_date('2022-12-07','YYYY-MM-DD'),2,3);
EXECUTE BURIED_UTILS.create_buried(5,'Sarah','Brown',to_date('1982-03-25','YYYY-MM-DD'),to_date('2008-12-30','YYYY-MM-DD'),3,4);
EXECUTE BURIED_UTILS.create_buried(6,'David','Miller',to_date('1973-09-15','YYYY-MM-DD'),to_date('1978-04-02','YYYY-MM-DD'),4,5);
EXECUTE BURIED_UTILS.create_buried(7,'Amanda','Taylor',to_date('1990-07-08','YYYY-MM-DD'),to_date('2015-11-25','YYYY-MM-DD'),5,6);
EXECUTE BURIED_UTILS.create_buried(8,'Oscar','Beta',to_date('2002-02-15','YYYY-MM-DD'),to_date('2002-02-16','YYYY-MM-DD'),6,7);
EXECUTE BURIED_UTILS.create_buried(9,'Daniel','Martinez',to_date('1976-08-19','YYYY-MM-DD'),to_date('1999-08-04','YYYY-MM-DD'),7,8);
EXECUTE BURIED_UTILS.create_buried(10,'Samantha','Anderson',to_date('1980-04-03','YYYY-MM-DD'),to_date('1985-10-09','YYYY-MM-DD'),8,9);

EXECUTE BURIED_UTILS.create_buried(11,'Talor','Ward',to_date('1953-04-15','YYYY-MM-DD'),to_date('2012-01-22','YYYY-MM-DD'),9,10);
EXECUTE BURIED_UTILS.create_buried(12,'Justin','Hill',to_date('1952-10-04','YYYY-MM-DD'),to_date('2012-01-22','YYYY-MM-DD'),9,10);
EXECUTE BURIED_UTILS.create_buried(13,'Brandon','Walker',to_date('1952-12-12','YYYY-MM-DD'),to_date('2012-01-22','YYYY-MM-DD'),9,10);
EXECUTE BURIED_UTILS.create_buried(14,'Alan','Lewis',to_date('1954-11-11','YYYY-MM-DD'),to_date('2006-07-11','YYYY-MM-DD'),10,11);
EXECUTE BURIED_UTILS.create_buried(15,'Ho Chi','Minh',to_date('1890-11-11','YYYY-MM-DD'),to_date('1990-11-06','YYYY-MM-DD'),11,12);
EXECUTE BURIED_UTILS.create_buried(16,'Megan','Carter',to_date('1978-12-08','YYYY-MM-DD'),to_date('2004-06-03','YYYY-MM-DD'),12,13);
EXECUTE BURIED_UTILS.create_buried(17,'Samantha','More',to_date('1953-04-15','YYYY-MM-DD'),to_date('2019-02-27','YYYY-MM-DD'),13,14);
EXECUTE BURIED_UTILS.create_buried(18,'Elizabeth','More',to_date('1978-09-23','YYYY-MM-DD'),to_date('2016-09-25','YYYY-MM-DD'),13,15);

EXECUTE BURIED_UTILS.create_buried(19,'Emily','Perry',to_date('1977-04-05','YYYY-MM-DD'),to_date('1988-12-14','YYYY-MM-DD'),14,16);
EXECUTE BURIED_UTILS.create_buried(20,'Nathan','Coleman',to_date('1987-07-19','YYYY-MM-DD'),to_date('2014-08-01','YYYY-MM-DD'),15,17);
EXECUTE BURIED_UTILS.create_buried(21,'Jessica','Barnes',to_date('1978-02-13','YYYY-MM-DD'),to_date('2000-05-06','YYYY-MM-DD'),16,18);
EXECUTE BURIED_UTILS.create_buried(22,'Daniel','Bell',to_date('1966-06-27','YYYY-MM-DD'),to_date('2011-10-27','YYYY-MM-DD'),17,19);
EXECUTE BURIED_UTILS.create_buried(23,'Megan','Ward',to_date('1983-09-08','YYYY-MM-DD'),to_date('2015-11-19','YYYY-MM-DD'),18,20);
EXECUTE BURIED_UTILS.create_buried(24, 'Lucas','Hayes',to_date('1976-03-07','YYYY-MM-DD'),to_date('2009-11-03','YYYY-MM-DD'),19,21);
EXECUTE BURIED_UTILS.create_buried(25, 'Maria','Richardson',to_date('1980-10-02','YYYY-MM-DD'),to_date('2003-10-02','YYYY-MM-DD'),20,22);
EXECUTE BURIED_UTILS.create_buried(26, 'Jordan','Perry',to_date('1975-12-30','YYYY-MM-DD'),to_date('2015-06-07','YYYY-MM-DD'),21,23);
EXECUTE BURIED_UTILS.create_buried(27, 'Rebeca','Turner',to_date('1984-08-22','YYYY-MM-DD'),to_date('2013-09-01','YYYY-MM-DD'),22,24);
EXECUTE BURIED_UTILS.create_buried(28, 'Tyler','Stewart',to_date('1988-04-11','YYYY-MM-DD'),to_date('2007-12-25','YYYY-MM-DD'),23,25);

EXECUTE BURIED_UTILS.create_buried(29, 'Allison','Parker',to_date('1979-01-13','YYYY-MM-DD'),to_date('2005-03-01','YYYY-MM-DD'),24,26);
EXECUTE BURIED_UTILS.create_buried(30, 'Jacob','Cooper',to_date('1974-11-16','YYYY-MM-DD'),to_date('1982-07-16','YYYY-MM-DD'),25,27);
EXECUTE BURIED_UTILS.create_buried(31, 'Olivia','Richardson',to_date('1982-05-21','YYYY-MM-DD'),to_date('2018-02-11','YYYY-MM-DD'),26,28);
EXECUTE BURIED_UTILS.create_buried(32, 'Cody','Adams',to_date('1986-06-28','YYYY-MM-DD'),to_date('2010-02-05','YYYY-MM-DD'),27,29);
EXECUTE BURIED_UTILS.create_buried(33, 'Kayla','Nelson',to_date('1981-12-03','YYYY-MM-DD'),to_date('1998-05-27','YYYY-MM-DD'),28,30);
EXECUTE BURIED_UTILS.create_buried(34, 'Devin','Bennett',to_date('1973-08-14','YYYY-MM-DD'),to_date('2012-11-09','YYYY-MM-DD'),29,31);
EXECUTE BURIED_UTILS.create_buried(35, 'Morgan','Henderson',to_date('1985-04-09','YYYY-MM-DD'),to_date('2016-04-01','YYYY-MM-DD'),30,32);
EXECUTE BURIED_UTILS.create_buried(36, 'Amanda','Hughes',to_date('1977-09-23','YYYY-MM-DD'),to_date('2008-01-04','YYYY-MM-DD'),31,33);
EXECUTE BURIED_UTILS.create_buried(37, 'Rachel','Simmons',to_date('1970-02-17','YYYY-MM-DD'),to_date('2001-09-22','YYYY-MM-DD'),32,34);
EXECUTE BURIED_UTILS.create_buried(38, 'Jenny','Simmons',to_date('1975-01-10','YYYY-MM-DD'),to_date('2001-09-22','YYYY-MM-DD'),32,34);

EXECUTE BURIED_UTILS.create_buried(39, 'Kyle','Torres',to_date('1908-07-06','YYYY-MM-DD'),to_date('2014-12-11','YYYY-MM-DD'),33,35);
EXECUTE BURIED_UTILS.create_buried(40, 'Emily','Turner',to_date('1983-10-19','YYYY-MM-DD'),to_date('2008-05-12','YYYY-MM-DD'),34,36);
EXECUTE BURIED_UTILS.create_buried(41, 'Nathan','Bell',to_date('1971-01-05','YYYY-MM-DD'),to_date('1995-09-01','YYYY-MM-DD'),35,37);
EXECUTE BURIED_UTILS.create_buried(42, 'Phill','Bell',to_date('1950-03-17','YYYY-MM-DD'),to_date('1995-09-01','YYYY-MM-DD'),35,37);
EXECUTE BURIED_UTILS.create_buried(43, 'Adele','Bell',to_date('1955-10-25','YYYY-MM-DD'),to_date('2010-06-17','YYYY-MM-DD'),35,38);
EXECUTE BURIED_UTILS.create_buried(44, 'Jessica','Henderson',to_date('1984-06-15','YYYY-MM-DD'),to_date('2022-12-07','YYYY-MM-DD'),36,39);
EXECUTE BURIED_UTILS.create_buried(45, 'Megan','Brooks',to_date('1884-06-15','YYYY-MM-DD'),to_date('1978-04-02','YYYY-MM-DD'),37,40);
EXECUTE BURIED_UTILS.create_buried(46, 'Daniel','Carter',to_date('1976-11-23','YYYY-MM-DD'),to_date('2015-11-25','YYYY-MM-DD'),38,41);
EXECUTE BURIED_UTILS.create_buried(47, 'Lucas','Reed',to_date('1988-08-11','YYYY-MM-DD'),to_date('2002-02-15','YYYY-MM-DD'),39,42);
EXECUTE BURIED_UTILS.create_buried(48, 'Maria','Hill',to_date('1969-08-11','YYYY-MM-DD'),to_date('1999-08-04','YYYY-MM-DD'),40,43);

EXECUTE BURIED_UTILS.create_buried(49, 'Jordan','Cox',to_date('1985-09-10','YYYY-MM-DD'),to_date('1985-10-09','YYYY-MM-DD'),41,44);
EXECUTE BURIED_UTILS.create_buried(50, 'Rebecca','Coleman',to_date('1972-02-06','YYYY-MM-DD'),to_date('2012-01-22','YYYY-MM-DD'),42,45);
EXECUTE BURIED_UTILS.create_buried(51, 'Tyler','Barnes',to_date('1977-06-25','YYYY-MM-DD'),to_date('2012-01-22','YYYY-MM-DD'),43,46);
EXECUTE BURIED_UTILS.create_buried(52, 'Allison','Nelson',to_date('1982-10-08','YYYY-MM-DD'),to_date('1990-11-06','YYYY-MM-DD'),44,47);
EXECUTE BURIED_UTILS.create_buried(53, 'Bob','Nelson',to_date('1978-01-12','YYYY-MM-DD'),to_date('2004-06-03','YYYY-MM-DD'),44,48);
EXECUTE BURIED_UTILS.create_buried(54, 'Alan','Nelson',to_date('1983-08-24','YYYY-MM-DD'),to_date('2019-03-01','YYYY-MM-DD'),44,49);
EXECUTE BURIED_UTILS.create_buried(55, 'Cody','Simmons',to_date('1979-11-09','YYYY-MM-DD'),to_date('2016-09-24','YYYY-MM-DD'),45,50);
EXECUTE BURIED_UTILS.create_buried(56, 'Patrick','Bateman',to_date('1962-09-11','YYYY-MM-DD'),to_date('1988-12-17','YYYY-MM-DD'),46,51);
EXECUTE BURIED_UTILS.create_buried(57, 'Kayla','Torres',to_date('1980-03-14','YYYY-MM-DD'),to_date('2014-07-31','YYYY-MM-DD'),47,52);
EXECUTE BURIED_UTILS.create_buried(58, 'Megan','Brooks',to_date('1981-10-20','YYYY-MM-DD'),to_date('2000-05-06','YYYY-MM-DD'),48,53);

EXECUTE BURIED_UTILS.create_buried(59, 'Tyler','Foster',to_date('1983-05-10','YYYY-MM-DD'),to_date('2011-10-27','YYYY-MM-DD'),49,54);
EXECUTE BURIED_UTILS.create_buried(60, 'Brittany','Price',to_date('1972-12-31','YYYY-MM-DD'),to_date('1997-04-18','YYYY-MM-DD'),50,55);
EXECUTE BURIED_UTILS.create_buried(61, 'Cody','Simmons',to_date('1984-03-05','YYYY-MM-DD'),to_date('2009-11-03','YYYY-MM-DD'),51,56);
EXECUTE BURIED_UTILS.create_buried(62, 'Morgan','Kelly',to_date('1979-05-03','YYYY-MM-DD'),to_date('2003-10-02','YYYY-MM-DD'),52,57);
EXECUTE BURIED_UTILS.create_buried(63, 'Dylan','Murphy',to_date('1979-10-03','YYYY-MM-DD'),to_date('2015-06-06','YYYY-MM-DD'),53,58);
EXECUTE BURIED_UTILS.create_buried(64, 'Kayla','Richardson',to_date('1978-11-13','YYYY-MM-DD'),to_date('2013-09-01','YYYY-MM-DD'),54,59);
EXECUTE BURIED_UTILS.create_buried(65, 'Lucas','Stewart',to_date('1975-04-16','YYYY-MM-DD'),to_date('2007-12-25','YYYY-MM-DD'),55,60);
EXECUTE BURIED_UTILS.create_buried(66, 'Maria','Torres',to_date('1982-05-25','YYYY-MM-DD'),to_date('2005-03-01','YYYY-MM-DD'),56,61);
EXECUTE BURIED_UTILS.create_buried(67, 'Jordan','Parker',to_date('1948-08-30','YYYY-MM-DD'),to_date('1982-07-16','YYYY-MM-DD'),57,62);
EXECUTE BURIED_UTILS.create_buried(68, 'Samantha','Morris',to_date('1990-08-30','YYYY-MM-DD'),to_date('2018-02-13','YYYY-MM-DD'),58,63);
EXECUTE BURIED_UTILS.create_buried(69, 'Austin','Peterson',to_date('1990-09-28','YYYY-MM-DD'),to_date('2010-02-04','YYYY-MM-DD'),59,64);
EXECUTE BURIED_UTILS.create_buried(70, 'Rachel','Cooper',to_date('1971-04-09','YYYY-MM-DD'),to_date('1998-05-26','YYYY-MM-DD'),60,65);

EXECUTE BURIED_UTILS.create_buried(71, 'Zachary','Barnes',to_date('1972-05-10','YYYY-MM-DD'),to_date('2012-11-09','YYYY-MM-DD'),61,66);
EXECUTE BURIED_UTILS.create_buried(72, 'Taylor','Rivera',to_date('1982-06-08','YYYY-MM-DD'),to_date('2016-03-30','YYYY-MM-DD'),62,67);
EXECUTE BURIED_UTILS.create_buried(73, 'Brandon','Coleman',to_date('1976-12-18','YYYY-MM-DD'),to_date('2008-01-04','YYYY-MM-DD'),63,68);
EXECUTE BURIED_UTILS.create_buried(74, 'Emily','Cox',to_date('1977-02-01','YYYY-MM-DD'),to_date('2001-09-22','YYYY-MM-DD'),64,69);

COMMIT;
        


