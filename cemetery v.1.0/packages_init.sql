--RELIGIOUS AREA UTILS
create or replace PACKAGE RELIGIOUS_AREA_UTILS AS 

    FUNCTION count_graves(arg_areaID IN NUMBER) RETURN NUMBER;
    FUNCTION count_sectors(arg_areaID IN NUMBER) RETURN NUMBER;
    PROCEDURE display_graves(arg_areaID IN NUMBER);
    PROCEDURE display_sectors(arg_areaID IN NUMBER);

END RELIGIOUS_AREA_UTILS;




--RELIGIOUS AREA UTILS BODY
create or replace PACKAGE BODY RELIGIOUS_AREA_UTILS AS
    
    FUNCTION count_graves(arg_areaID IN NUMBER) RETURN NUMBER AS
        grave_count NUMBER;
        area_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO area_exists FROM religious_areas WHERE areaID = arg_areaID;
        IF area_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Area with this ID does not exist.');
        END IF;
        
        SELECT COUNT(*) INTO grave_count
        FROM GRAVES WHERE deref(GRAVES.sector_ref).areaID = arg_areaID;
        RETURN grave_count;
    END count_graves;
    
    FUNCTION count_sectors(arg_areaID IN NUMBER) RETURN NUMBER IS
        sector_count NUMBER;
        area_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO area_exists FROM religious_areas WHERE areaID = arg_areaID;
        IF area_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Area with this ID does not exist.');
        END IF;
        
        SELECT COUNT(*) INTO sector_count
        FROM cemetery.SECTORS WHERE areaID = arg_areaID;
        RETURN sector_count;
    END count_sectors;
    
    PROCEDURE display_graves(arg_areaID IN NUMBER) AS
        CURSOR grave_cursor IS SELECT graveID, expiration_date, grave_type, payment_ref
        FROM cemetery.GRAVES WHERE deref(sector_ref).areaID = arg_areaID;
        CURSOR buried_cursor(gID NUMBER) IS SELECT personID, name, surname, born, passed
        FROM cemetery.BURIED WHERE deref(grave_ref).graveID = gID;
        grave_row grave_cursor%ROWTYPE;
        buried_row buried_cursor%ROWTYPE;
        temp_payment payment_t;
        area_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO area_exists FROM religious_areas WHERE areaID = arg_areaID;
        IF area_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Area with this ID does not exist.');
        END IF;
        
        OPEN grave_cursor;
        LOOP
            FETCH grave_cursor INTO grave_row;
            EXIT WHEN grave_cursor%NOTFOUND;
            DBMS_OUTPUT.put_line('ID Grobu: ' || grave_row.graveID);
            DBMS_OUTPUT.put_line('Data wygaśnięcia: ' || grave_row.expiration_date);
            DBMS_OUTPUT.put_line('Typ grobu: ' || grave_row.grave_type);
            SELECT deref(grave_row.payment_ref) INTO temp_payment FROM dual;
            DBMS_OUTPUT.put_line('ID zapłaty: ' || temp_payment.paymentID);
            DBMS_OUTPUT.put_line('Wartość zapłaty: ' || temp_payment.value);
            DBMS_OUTPUT.put_line('Opłacono dnia: ' || temp_payment.payment_date);
            DBMS_OUTPUT.put_line('Pochowani w grobie:');
            
            OPEN buried_cursor(grave_row.graveID);
            LOOP
                FETCH buried_cursor INTO buried_row;
                EXIT WHEN buried_cursor%NOTFOUND;
                DBMS_OUTPUT.put_line('Tu leży ' || buried_row.name || ' ' || buried_row.surname || ', ID w systemie: ' || buried_row.personID
                || ', data urodzenia: ' || buried_row.born || ', data śmierci: ' || buried_row.passed);
            END LOOP;
            CLOSE buried_cursor;
            
            DBMS_OUTPUT.put_line('');
        END LOOP;
        CLOSE grave_cursor;
    END display_graves;
    
    PROCEDURE display_sectors(arg_areaID IN NUMBER) AS
        CURSOR disp_cursor IS SELECT areaID, sectorID, grave_count
        FROM cemetery.SECTORS WHERE areaID = arg_areaID;
        temp_row disp_cursor%ROWTYPE;
        area_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO area_exists FROM religious_areas WHERE areaID = arg_areaID;
        IF area_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Area with this ID does not exist.');
        END IF;
        
        OPEN disp_cursor;
        LOOP
            FETCH disp_cursor INTO temp_row;
            EXIT WHEN disp_cursor%NOTFOUND;
            DBMS_OUTPUT.put_line('ID sektoru: ' || temp_row.sectorID
            || ' ID strefy religijnej: ' || temp_row.areaID
            || ' Liczba grobów w sektorze: ' || temp_row.grave_count);
        END LOOP;
        CLOSE disp_cursor;
    END display_sectors;

END RELIGIOUS_AREA_UTILS;





--SECTOR UTILS
create or replace PACKAGE SECTOR_UTILS AS 

    FUNCTION count_graves(arg_sectorID IN NUMBER) RETURN NUMBER;
    PROCEDURE change_area(arg_sectorID IN NUMBER, arg_areaID NUMBER);
    PROCEDURE display_graves(arg_sectorID IN NUMBER);

END SECTOR_UTILS;





--SECTOR UTILS BODY
create or replace PACKAGE BODY SECTOR_UTILS AS

    FUNCTION count_graves(arg_sectorID IN NUMBER) RETURN NUMBER AS
        count_graves NUMBER;
        sector_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO sector_exists FROM sectors WHERE sectorID = arg_sectorID;
        IF sector_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Sector with this ID does not exist.');
        END IF;
        
        SELECT COUNT(*) INTO count_graves
        FROM graves WHERE deref(sector_ref).sectorID = arg_sectorID;
        RETURN count_graves;
    END count_graves;

    PROCEDURE change_area(arg_sectorID IN NUMBER, arg_areaID NUMBER) AS
        sector_exists NUMBER;
        area_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO sector_exists FROM sectors WHERE sectorID = arg_sectorID;
        IF sector_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Sector with this ID does not exist.');
        END IF;
        
        SELECT COUNT(*) INTO area_exists FROM religious_areas WHERE areaID = arg_areaID;
        IF area_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Area with this ID does not exist.');
        END IF;
        
        UPDATE cemetery.SECTORS SET areaID = arg_areaID
        WHERE sectorID = arg_sectorID;
    END change_area;

    PROCEDURE display_graves(arg_sectorID IN NUMBER) AS
        CURSOR grave_cursor IS SELECT graveID, expiration_date, grave_type, payment_ref
        FROM cemetery.GRAVES WHERE deref(sector_ref).sectorID = arg_sectorID;
        CURSOR buried_cursor(gID NUMBER) IS SELECT personID, name, surname, born, passed
        FROM cemetery.BURIED WHERE deref(grave_ref).graveID = gID;
        grave_row grave_cursor%ROWTYPE;
        buried_row buried_cursor%ROWTYPE;
        temp_payment payment_t;
        sector_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO sector_exists FROM sectors WHERE sectorID = arg_sectorID;
        IF sector_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Sector with this ID does not exist.');
        END IF;
        
        OPEN grave_cursor;
        LOOP
            FETCH grave_cursor INTO grave_row;
            EXIT WHEN grave_cursor%NOTFOUND;
            DBMS_OUTPUT.put_line('ID Grobu: ' || grave_row.graveID);
            DBMS_OUTPUT.put_line('Data wygaśnięcia: ' || grave_row.expiration_date);
            DBMS_OUTPUT.put_line('Typ grobu: ' || grave_row.grave_type);
            SELECT deref(grave_row.payment_ref) INTO temp_payment FROM dual;
            DBMS_OUTPUT.put_line('ID zapłaty: ' || temp_payment.paymentID);
            DBMS_OUTPUT.put_line('Wartość zapłaty: ' || temp_payment.value);
            DBMS_OUTPUT.put_line('Opłacono dnia: ' || temp_payment.payment_date);
            DBMS_OUTPUT.put_line('Pochowani w grobie:');

            OPEN buried_cursor(grave_row.graveID);
            LOOP
                FETCH buried_cursor INTO buried_row;
                EXIT WHEN buried_cursor%NOTFOUND;
                DBMS_OUTPUT.put_line('Tu leży ' || buried_row.name || ' ' || buried_row.surname || ', ID w systemie: ' || buried_row.personID
                || ', data urodzenia: ' || buried_row.born || ', data śmierci: ' || buried_row.passed);
            END LOOP;
            CLOSE buried_cursor;

            DBMS_OUTPUT.put_line('');
        END LOOP;
        CLOSE grave_cursor;
    END display_graves;

END SECTOR_UTILS;





--PAYMENT UTILS
create or replace PACKAGE PAYMENT_UTILS AS 

    PROCEDURE add_payment(arg_paymentID NUMBER, value NUMBER, payment_date DATE);
    PROCEDURE remove_payment(arg_paymentID NUMBER);
    PROCEDURE display_payments;

END PAYMENT_UTILS;





--PAYMENT UTILS BODY
create or replace PACKAGE BODY PAYMENT_UTILS AS

    PROCEDURE add_payment(arg_paymentID NUMBER, value NUMBER, payment_date DATE) AS
        payment_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO payment_exists FROM payments WHERE paymentID = arg_paymentID;
        IF payment_exists > 0 THEN
            RAISE_APPLICATION_ERROR(-20111,'Payment with this ID already exists.');
        END IF;
        
        IF value <= 0 THEN
            RAISE_APPLICATION_ERROR(-20111,'Negative payment value is not allowed.');
        END IF;

        INSERT INTO payments VALUES (arg_paymentID, value, payment_date);
    END add_payment;

    PROCEDURE remove_payment(arg_paymentID NUMBER) AS
        payment_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO payment_exists FROM payments WHERE paymentID = arg_paymentID;
        IF payment_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Payment with this ID does not exist.');
        END IF;
        
        DELETE FROM payments WHERE paymentID = arg_paymentID;
    END remove_payment;

    PROCEDURE display_payments AS
        CURSOR payment_cursor IS SELECT paymentID, payment_date, value FROM payments;
        payment_row payment_cursor%rowtype;
    BEGIN
        OPEN payment_cursor;
        LOOP
            FETCH payment_cursor INTO payment_row;
            EXIT WHEN payment_cursor%notfound;
            DBMS_OUTPUT.put_line('Platnosc o ID: ' || payment_row.paymentID
            || 'data: ' || payment_row.payment_date || ' na ' || payment_row.value || '.');
        END LOOP;
        CLOSE payment_cursor;
    END display_payments;

END PAYMENT_UTILS;





--GRAVE UTILS
create or replace PACKAGE GRAVE_UTILS AS 
    
    debug_for_archival_data NUMBER := 0;

    PROCEDURE update_expiration_date(arg_graveID in NUMBER,new_date in DATE);
    PROCEDURE update_grave_type(arg_graveID in NUMBER,new_type in VARCHAR);
    PROCEDURE assign_buried(arg_graveID in NUMBER, buriedID in NUMBER);
    PROCEDURE show_buried(arg_graveID IN NUMBER);
    PROCEDURE update_payment(arg_paymentID IN NUMBER, arg_graveID IN NUMBER);
    PROCEDURE add_grave(arg_graveID IN NUMBER, expiration_date IN DATE, grave_type IN VARCHAR, arg_paymentID IN NUMBER, arg_sectorID IN NUMBER);
    PROCEDURE remove_grave(arg_graveID IN NUMBER);
    PROCEDURE remove_grave_and_buried(arg_graveID IN NUMBER);

    FUNCTION get_debug_for_archival_data RETURN NUMBER;
    PROCEDURE set_debug_for_archival_data(new_value NUMBER);

END GRAVE_UTILS;





--GRAVE UTILS BODY
create or replace PACKAGE BODY GRAVE_UTILS AS
    
    PROCEDURE update_expiration_date(arg_graveID in NUMBER,new_date in DATE) AS
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 
        
        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;
        
        IF new_date < SYSDATE() AND debug_for_archival_data = 0 THEN
            raise_application_error(-20111,'Date set in the past.');
        END IF;
        
        UPDATE cemetery.GRAVES SET expiration_date = new_date
        WHERE graveID = arg_graveID;
    END update_expiration_date;
    
    PROCEDURE update_grave_type(arg_graveID in NUMBER,new_type in VARCHAR) AS
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 
        
        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;
        
        IF LOWER(new_type) IN ('stone','frame','malsoleum','urn') THEN
            UPDATE cemetery.GRAVES SET grave_type = new_type WHERE graveID = arg_graveID;
        ELSE
            raise_application_error(-20111,'Invalid grave type.');
        END IF;
    END update_grave_type;
    
    PROCEDURE assign_buried(arg_graveID in NUMBER, buriedID in NUMBER) AS
        temp_grave_ref REF grave_t;
        grave_exists NUMBER;
        buried_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 
        
        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;
        
        SELECT COUNT(*) INTO buried_exists
        FROM buried WHERE personID = buriedID; 
        
        IF buried_exists = 0 THEN
            raise_application_error(-20111,'Buried with this ID does not exist.');
        END IF;
        
        SELECT REF(g) INTO temp_grave_ref FROM cemetery.GRAVES g WHERE g.graveID = arg_graveID;
        UPDATE cemetery.BURIED SET grave_ref = temp_grave_ref WHERE personID = buriedID;
    END assign_buried;
    
    PROCEDURE show_buried(arg_graveID IN NUMBER) AS
        CURSOR buried_cursor IS SELECT personID, name, surname, born, passed
        FROM cemetery.BURIED WHERE deref(grave_ref).graveID = arg_graveID;
        buried_row buried_cursor%ROWTYPE;
        disp_graveID NUMBER;
        disp_grave_type VARCHAR(20);
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 
        
        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;
        
        SELECT graveID INTO disp_graveID FROM cemetery.GRAVES WHERE graveID = arg_graveID;
        SELECT grave_type INTO disp_grave_type  FROM cemetery.GRAVES WHERE graveID = arg_graveID;
        
        DBMS_OUTPUT.put_line('ID Grobu: ' || disp_graveID
        || ', typ grobu: ' || disp_grave_type || '. Pochowani:');
        
        OPEN buried_cursor;
        LOOP
            FETCH buried_cursor INTO buried_row;
            EXIT WHEN buried_cursor%NOTFOUND;
            DBMS_OUTPUT.put_line('Tu leży ' || buried_row.name || ' ' || buried_row.surname || ', ID w systemie: ' || buried_row.personID
            || ', data urodzenia: ' || buried_row.born || ', data śmierci: ' || buried_row.passed);
        END LOOP;
        CLOSE buried_cursor;
    END show_buried;
    
    PROCEDURE update_payment(arg_paymentID IN NUMBER, arg_graveID IN NUMBER) AS
        temp_payment_ref REF payment_t;
        payment_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO payment_exists
        FROM cemetery.PAYMENTS WHERE paymentID = arg_paymentID; 
        
        IF payment_exists = 0 THEN
            raise_application_error(-20111,'Payment with this ID does not exist.');
        END IF;
        
        SELECT REF(p) INTO temp_payment_ref FROM cemetery.PAYMENTS p WHERE p.paymentID = arg_paymentID;
        UPDATE cemetery.GRAVES SET payment_ref = temp_payment_ref WHERE graveID = arg_graveID;
    END update_payment;
    
    PROCEDURE add_grave(arg_graveID IN NUMBER, expiration_date IN DATE, grave_type IN VARCHAR, arg_paymentID IN NUMBER, arg_sectorID IN NUMBER) AS
        grave_exists NUMBER;
        payment_exists NUMBER;
        sector_exists NUMBER;
        temp_payment_ref REF payment_t;
        temp_sector_ref REF sector_t;
    BEGIN
        SELECT COUNT(*) INTO grave_exists FROM cemetery.GRAVES WHERE graveID = arg_graveID;
        IF grave_exists > 0 THEN
            raise_application_error(-20111,'Grave with this ID already exists.');
        END IF;
        
        IF expiration_date < SYSDATE() AND debug_for_archival_data = 0 THEN
            raise_application_error(-20111,'Date set in the past.');
        END IF;
        
        IF LOWER(grave_type)  NOT IN ('stone','frame','malsoleum','urn') THEN
            raise_application_error(-20111,'Invalid grave type.');
        END IF;
        
        SELECT COUNT(*) INTO payment_exists FROM cemetery.PAYMENTS WHERE paymentID = arg_paymentID;
        IF payment_exists < 1 THEN
            raise_application_error(-20111,'No payment with this ID.');
        END IF;
        
        SELECT COUNT(*) INTO sector_exists FROM cemetery.SECTORS WHERE sectorID = arg_sectorID;
        IF sector_exists < 1 THEN
            raise_application_error(-20111,'No sector with this ID.');
        END IF;
        
        SELECT REF(p) INTO temp_payment_ref FROM cemetery.PAYMENTS p WHERE p.paymentID = arg_paymentID;
        SELECT REF(s) INTO temp_sector_ref FROM cemetery.SECTORS s WHERE s.sectorID = arg_sectorID;
        INSERT INTO cemetery.GRAVES VALUES (arg_graveID, expiration_date, grave_type, temp_payment_ref, temp_sector_ref);
    END add_grave;
    
    PROCEDURE remove_grave(arg_graveID IN NUMBER) AS
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 
        
        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;
        
        DELETE FROM cemetery.GRAVES WHERE graveID = arg_graveID;
    END remove_grave;
    
    PROCEDURE remove_grave_and_buried(arg_graveID IN NUMBER) AS
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 
        
        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;
        
        DELETE FROM cemetery.BURIED WHERE deref(grave_ref).graveID = arg_graveID;
        DELETE FROM cemetery.GRAVES WHERE graveID = arg_graveID;
    END remove_grave_and_buried;
    
    FUNCTION get_debug_for_archival_data RETURN NUMBER AS
    BEGIN
        RETURN debug_for_archival_data;
    END get_debug_for_archival_data;
    
    PROCEDURE set_debug_for_archival_data(new_value NUMBER) AS
    BEGIN
        IF new_value < 1 THEN
            debug_for_archival_data := 0;
        ELSE
            debug_for_archival_data := 1;
        END IF;
    END set_debug_for_archival_data;

END GRAVE_UTILS;





--FUNERAL UTILS
create or replace PACKAGE FUNERAL_UTILS AS 

    max_funerals_per_day NUMBER := 3;
    max_orders_per_worker NUMBER := 5;
    debug_for_archival_data NUMBER := 0;

    PROCEDURE add_funeral(arg_funeralID NUMBER, arg_funeral_date DATE, arg_priest_name VARCHAR);
    FUNCTION calculate_funeral_cost(arg_funeralID NUMBER) RETURN NUMBER;
    FUNCTION remove_funerals_by_date(cutoff_date DATE) RETURN NUMBER;
    PROCEDURE assign_service_worker(arg_funeralID NUMBER, arg_workerID NUMBER);
    PROCEDURE remove_service_worker(arg_funeralID NUMBER, arg_workerID NUMBER);
    PROCEDURE display_funerals;

    FUNCTION get_max_funerals_per_day RETURN NUMBER;
    FUNCTION get_max_orders_per_worker RETURN NUMBER;
    FUNCTION get_debug_for_archival_data RETURN NUMBER;
    PROCEDURE set_max_funerals_per_day(new_value NUMBER);
    PROCEDURE set_max_orders_per_worker(new_value NUMBER);
    PROCEDURE set_debug_for_archival_data(new_value NUMBER);
    PROCEDURE remove_funeral_by_id(funeral_to_remove NUMBER);

END FUNERAL_UTILS;





--FUNERAL UTILS BODY
create or replace PACKAGE BODY FUNERAL_UTILS AS

    PROCEDURE add_funeral(arg_funeralID NUMBER, arg_funeral_date DATE, arg_priest_name VARCHAR) AS
        funeral_exists NUMBER;
        funerals_on_date NUMBER;
        temp_funeral_ref REF funeral_t;
    BEGIN
        SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = arg_funeralID;

        IF funeral_exists > 0 THEN
            raise_application_error(-20111,'Funeral with this ID already exists.');
        END IF;

        SELECT COUNT(*) INTO funerals_on_date FROM funerals
        WHERE trunc(funeral_date, 'DD') = trunc(arg_funeral_date, 'DD');

        IF funerals_on_date >= max_funerals_per_day THEN
            raise_application_error(-20111,'Too many funerals on this date.');
        END IF;

        IF arg_funeral_date < SYSDATE AND debug_for_archival_data = 0 THEN
            raise_application_error(-20111,'Funeral date set in the past.');
        END IF;

        INSERT INTO funerals VALUES (arg_funeralID, arg_funeral_date, arg_priest_name);
        SELECT REF(f) INTO temp_funeral_ref FROM cemetery.funerals f WHERE f.funeralID = arg_funeralID;
        INSERT INTO funerals_and_services VALUES (temp_funeral_ref, NEW service_workers_referencesnt());
    END add_funeral;

    FUNCTION calculate_funeral_cost(arg_funeralID NUMBER) RETURN NUMBER AS
        funeral_cost NUMBER;
        funeral_exists NUMBER;
        temp_funeral_services service_workers_referencesNT;
        temp_service_worker_ref REF service_worker_t;
        temp_service_worker service_worker_t;
    BEGIN
        SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = arg_funeralID;

        IF funeral_exists < 1 THEN
            raise_application_error(-20111,'Funeral with this ID does not exists.');
        END IF;

        funeral_cost := 0;
        SELECT funeral_services INTO temp_funeral_services
        FROM cemetery.FUNERALS_AND_SERVICES WHERE deref(funeral).funeralID = arg_funeralID;
        
        IF temp_funeral_services.FIRST IS NOT NULL THEN
            FOR i IN temp_funeral_services.FIRST .. temp_funeral_services.LAST LOOP
                temp_service_worker_ref := temp_funeral_services(i);
                SELECT deref(temp_service_worker_ref) INTO temp_service_worker FROM DUAL;
                funeral_cost := funeral_cost + temp_service_worker.service_cost;
            END LOOP;
        END IF;

        RETURN funeral_cost;
    END calculate_funeral_cost;

    FUNCTION remove_funerals_by_date(cutoff_date DATE) RETURN NUMBER AS
        deleted_funerals_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO deleted_funerals_count FROM funerals WHERE funeral_date < cutoff_date;
        DELETE FROM funerals_and_services WHERE deref(funeral).funeral_date < cutoff_date;
        DELETE FROM funerals WHERE funeral_date < cutoff_date;
        RETURN deleted_funerals_count;
    END remove_funerals_by_date;

    PROCEDURE assign_service_worker(arg_funeralID NUMBER, arg_workerID NUMBER) AS
        funeral_exists NUMBER;
        worker_exists NUMBER;
        temp_funeral_services service_workers_referencesNT;
        worker_active_orders NUMBER;
        temp_service_worker_ref REF service_worker_t;
        temp_service_worker service_worker_t;
        CURSOR funeral_cursor IS SELECT funeralID, funeral_date FROM funerals;
        funeral_row funeral_cursor%rowtype;
        temp_funeral_date DATE;
        temp_iter_funeral_date DATE;
    BEGIN
        --czy pogrzeb istnieje
        SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = arg_funeralID;

        IF funeral_exists < 1 THEN
            raise_application_error(-20111,'Funeral with this ID does not exists.');
        END IF;

        --czy pracownik istnieje
        SELECT COUNT(*) INTO worker_exists FROM service_workers WHERE workerID = arg_workerID;

        IF worker_exists < 1 THEN
            raise_application_error(-20111,'Worker with this ID does not exists.');
        END IF;

        --czy pracownik juz jest przypisany do tego pogrzebu
        SELECT funeral_services INTO temp_funeral_services
        FROM cemetery.FUNERALS_AND_SERVICES WHERE deref(funeral).funeralID = arg_funeralID;

        IF temp_funeral_services.FIRST() IS NOT NULL THEN
            FOR indx IN temp_funeral_services.FIRST() .. temp_funeral_services.LAST() LOOP
                SELECT temp_funeral_services(indx) INTO temp_service_worker_ref FROM DUAL;
                SELECT deref(temp_service_worker_ref) INTO temp_service_worker FROM DUAL;
                IF temp_service_worker.workerID = arg_workerID THEN
                    raise_application_error(-20111,'Worker with this ID is already assigned to funeral with this ID.');
                END IF;
            END LOOP;
        END IF;
        --czy pracownik ma jeszcze wolne zamówienia
        SELECT active_orders INTO worker_active_orders FROM service_workers WHERE workerID = arg_workerID;

        IF worker_active_orders >= max_orders_per_worker THEN
            raise_application_error(-20111,'Worker with this ID cannot take more orders.');
        END IF;

        --czy pracownik ma tego dnia pogrzeb
        OPEN funeral_cursor;
        LOOP
            FETCH funeral_cursor INTO funeral_row;
            EXIT WHEN funeral_cursor%notfound;

            SELECT funeral_services INTO temp_funeral_services
            FROM funerals_and_services WHERE deref(funeral).funeralID = funeral_row.funeralID;

            SELECT funeral_date INTO temp_funeral_date
            FROM funerals WHERE funeralID = arg_funeralID;
            SELECT funeral_date INTO temp_iter_funeral_date
            FROM funerals WHERE funeralID = funeral_row.funeralID;
            
            IF temp_funeral_services.FIRST IS NOT NULL THEN
                FOR i IN temp_funeral_services.FIRST .. temp_funeral_services.LAST LOOP
                    temp_service_worker_ref := temp_funeral_services(i);
                    SELECT deref(temp_service_worker_ref) INTO temp_service_worker FROM DUAL;
    
                    IF temp_service_worker.workerID <> arg_workerID THEN
                        CONTINUE;
                    END IF;
    
                    IF TRUNC(temp_funeral_date, 'dd') = TRUNC(temp_iter_funeral_date, 'dd') THEN
                        raise_application_error(-20111,'Worker with this ID is already assigned to a funeral on this date.');
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
        CLOSE funeral_cursor;

        --aktualizacja wartości
        UPDATE service_workers SET active_orders = (worker_active_orders + 1) WHERE workerID = arg_workerID;
        SELECT funeral_services INTO temp_funeral_services FROM funerals_and_services
        WHERE deref(funeral).funeralID = arg_funeralID;
        SELECT REF(sw) INTO temp_service_worker_ref FROM service_workers sw
        WHERE sw.workerID = arg_workerID;
        temp_funeral_services.EXTEND(1);
        temp_funeral_services(temp_funeral_services.LAST) := temp_service_worker_ref;
        UPDATE funerals_and_services SET funeral_services = temp_funeral_services
        WHERE deref(funeral).funeralID = arg_funeralID;
    END assign_service_worker;

    PROCEDURE remove_service_worker(arg_funeralID NUMBER, arg_workerID NUMBER) AS
        funeral_exists NUMBER;
        worker_exists NUMBER;
        worker_not_assigned NUMBER := 1;
        temp_funeral_services service_workers_referencesNT;
        temp_service_worker_ref REF service_worker_t;
        temp_service_worker service_worker_t;
    BEGIN
        SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = arg_funeralID;

        IF funeral_exists < 1 THEN
            raise_application_error(-20111,'Funeral with this ID does not exists.');
        END IF;

        SELECT COUNT(*) INTO worker_exists FROM service_workers WHERE workerID = arg_workerID;

        IF worker_exists < 1 THEN
            raise_application_error(-20111,'Worker with this ID does not exists.');
        END IF;

        SELECT funeral_services INTO temp_funeral_services
        FROM cemetery.FUNERALS_AND_SERVICES WHERE deref(funeral).funeralID = arg_funeralID;

        IF temp_funeral_services.FIRST IS NOT NULL THEN
            FOR i IN temp_funeral_services.FIRST .. temp_funeral_services.LAST LOOP
                temp_service_worker_ref := temp_funeral_services(i);
                SELECT deref(temp_service_worker_ref) INTO temp_service_worker FROM DUAL;
                IF temp_service_worker.workerID = arg_workerID THEN
                    temp_funeral_services.delete(i);
                    UPDATE service_workers SET active_orders = (active_orders - 1) WHERE workerID = arg_workerID;
                    UPDATE funerals_and_services SET funeral_services = temp_funeral_services
                    WHERE deref(funeral).funeralID = arg_funeralID;
                    worker_not_assigned := 0;
                    EXIT;
                END IF;
            END LOOP;
        END IF;

        IF worker_not_assigned = 1 THEN
            raise_application_error(-20111,'Worker with this ID was not assigned to this funeral.');
        END IF;
    END remove_service_worker;

    PROCEDURE display_funerals AS
        CURSOR funeral_cursor IS SELECT funeralID, funeral_date, priest_name FROM funerals;
        funeral_row funeral_cursor%rowtype;
    BEGIN
        OPEN funeral_cursor;
        LOOP
            FETCH funeral_cursor INTO funeral_row;
            EXIT WHEN funeral_cursor%notfound;

            IF funeral_row.priest_name IS NOT NULL THEN
                DBMS_OUTPUT.put_line('Pogrzeb o ID ' || funeral_row.funeralID
                || ' odbyl sie ' || funeral_row.funeral_date
                || '. Duchowny: ' || funeral_row.priest_name || '.');
            ELSE
                DBMS_OUTPUT.put_line('Pogrzeb o ID ' || funeral_row.funeralID
                || ' odbyl sie ' || funeral_row.funeral_date || '.');
            END IF;
        END LOOP;
        CLOSE funeral_cursor;
    END display_funerals;

    FUNCTION get_max_funerals_per_day RETURN NUMBER AS
    BEGIN
        RETURN max_funerals_per_day;
    END get_max_funerals_per_day;

    FUNCTION get_max_orders_per_worker RETURN NUMBER AS
    BEGIN
        RETURN max_orders_per_worker;
    END get_max_orders_per_worker;

    FUNCTION get_debug_for_archival_data RETURN NUMBER AS
    BEGIN
        RETURN debug_for_archival_data;
    END get_debug_for_archival_data;

    PROCEDURE set_max_funerals_per_day(new_value NUMBER) AS
    BEGIN
        IF new_value < 1 THEN
            raise_application_error(-20111,'Bag argument. Negative value passed to procedure.');
        END IF;

        max_funerals_per_day := new_value;
    END set_max_funerals_per_day;

    PROCEDURE set_max_orders_per_worker(new_value NUMBER) AS
    BEGIN
        IF new_value < 1 THEN
            raise_application_error(-20111,'Bag argument. Negative value passed to procedure.');
        END IF;

        max_orders_per_worker := new_value;
    END set_max_orders_per_worker;

    PROCEDURE set_debug_for_archival_data(new_value NUMBER) AS
    BEGIN
        IF new_value < 1 THEN
            debug_for_archival_data := 0;
        ELSE
            debug_for_archival_data := 1;
        END IF;
    END set_debug_for_archival_data;
    
    PROCEDURE remove_funeral_by_id(funeral_to_remove NUMBER) AS
        funeral_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = funeral_to_remove;
        IF funeral_exists < 1 THEN
            raise_application_error(-20111,'Funeral with this ID does not exists.');
        ELSE 
            DELETE FROM funerals_and_services WHERE deref(funeral).funeralID = funeral_to_remove;  
            DELETE FROM FUNERALS WHERE funeralID = funeral_to_remove;    
        END IF;
    END remove_funeral_by_id;

END FUNERAL_UTILS;





--SERVICE WORKER UTILS
create or replace PACKAGE SERVICE_WORKER_UTILS AS 

    PROCEDURE add_service_worker(arg_workerID NUMBER, name VARCHAR, surname VARCHAR, profession VARCHAR,
        phone VARCHAR, reputation NUMBER, service_cost NUMBER);
    PROCEDURE remove_service_worker(arg_workerID NUMBER);
    FUNCTION count_orders_in_future(arg_workerID NUMBER) RETURN NUMBER;
    PROCEDURE update_orders_count_by_ID(arg_workerID NUMBER);
    PROCEDURE update_orders_count_for_all_workers;
    PROCEDURE display_service_workers;

END SERVICE_WORKER_UTILS;





-- SERVICE WORKER UTILS BODY
create or replace PACKAGE BODY SERVICE_WORKER_UTILS AS

    PROCEDURE add_service_worker(arg_workerID NUMBER, name VARCHAR, surname VARCHAR, profession VARCHAR,
        phone VARCHAR, reputation NUMBER, service_cost NUMBER) AS
        worker_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO worker_exists FROM service_workers WHERE workerID = arg_workerID;

        IF worker_exists > 0 THEN
            raise_application_error(-20111,'Worker with this ID already exists.');
        END IF;

        INSERT INTO service_workers VALUES (arg_workerID, name, surname, profession, phone, reputation, 0, service_cost);
    END add_service_worker;

    PROCEDURE remove_service_worker(arg_workerID NUMBER) AS
        worker_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO worker_exists FROM service_workers WHERE workerID = arg_workerID;
        IF worker_exists < 1 THEN
            raise_application_error(-20111,'Worker with this ID does not exist.');
        END IF;
        
        DELETE FROM service_workers WHERE workerID = arg_workerID;
    END remove_service_worker;

    FUNCTION count_orders_in_future(arg_workerID NUMBER) RETURN NUMBER AS
        CURSOR worker_refs_cursor IS SELECT funeral, funeral_services FROM funerals_and_services;
        worker_refs_row funerals_and_services%ROWTYPE;
        count_orders NUMBER := 0;
        temp_service_worker_ref REF service_worker_t;
        temp_service_worker service_worker_t;
        temp_service_workerID NUMBER;
        temp_funeral_date DATE;
    BEGIN
        OPEN worker_refs_cursor;
        LOOP
            FETCH worker_refs_cursor INTO worker_refs_row;
            EXIT WHEN worker_refs_cursor%NOTFOUND;

            SELECT deref(worker_refs_row.funeral).funeral_date INTO temp_funeral_date FROM DUAL;
            IF worker_refs_row.funeral_services.FIRST IS NOT NULL THEN
                FOR i IN worker_refs_row.funeral_services.FIRST .. worker_refs_row.funeral_services.LAST LOOP
                    temp_service_worker_ref := worker_refs_row.funeral_services(i);
                    SELECT deref(temp_service_worker_ref) INTO temp_service_worker FROM DUAL;
                    temp_service_workerID := temp_service_worker.workerID;
    
                    IF temp_service_workerID = arg_workerID AND trunc(temp_funeral_date, 'DD') >= trunc(SYSDATE, 'DD') THEN
                        count_orders := count_orders + 1;
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
        RETURN count_orders;
    END count_orders_in_future;

    PROCEDURE update_orders_count_by_ID(arg_workerID NUMBER) AS
        count_orders_retval NUMBER;
    BEGIN
        count_orders_retval := count_orders_in_future(arg_workerID);
        UPDATE service_workers SET active_orders = count_orders_retval WHERE workerID = arg_workerID;
    END update_orders_count_by_ID;

    PROCEDURE update_orders_count_for_all_workers AS
        CURSOR worker_cursor IS SELECT workerID FROM service_workers;
        temp_workerID NUMBER;
    BEGIN
        OPEN worker_cursor;
        LOOP
            FETCH worker_cursor INTO temp_workerID;
            EXIT WHEN worker_cursor%NOTFOUND;
            update_orders_count_by_ID(temp_workerID);
        END LOOP;
    END update_orders_count_for_all_workers;

    PROCEDURE display_service_workers AS
        CURSOR worker_cursor IS SELECT workerID, name, surname, profession,
        phone, reputation, active_orders, service_cost FROM service_workers;
        worker_row worker_cursor%rowtype;
    BEGIN
        OPEN worker_cursor;
        LOOP
                FETCH worker_cursor INTO worker_row;
                EXIT WHEN worker_cursor%notfound;
                DBMS_OUTPUT.put_line('Pracownik uslug ' || worker_row.name || ' '
                || worker_row.surname || ' o ID ' || worker_row.workerID
                || ' w zawodzie ' || worker_row.profession || ' o reputacji ' 
                || worker_row.reputation || ' z numerem telefonu ' || worker_row.phone
                || ' i kosztem uslugi ' || worker_row.service_cost || ' ma '
                || worker_row.active_orders || ' zaplanowanych wykonan uslugi.');
        END LOOP;
        CLOSE worker_cursor;
    END display_service_workers;

END SERVICE_WORKER_UTILS;





--BURIED UTILS
create or replace PACKAGE BURIED_UTILS AS 

    function calculate_age(buried in buried_t) return number;
    procedure create_buried(arg_personID in number, name in VARCHAR, surname in VARCHAR,
        born in DATE, passed in DATE, arg_graveID in NUMBER, arg_funeralID in NUMBER);
    procedure remove_buried(buried_id in number);
    PROCEDURE display_buried(arg_funeralID IN NUMBER);

END BURIED_UTILS;





--BURIED UTILS BODY
create or replace PACKAGE BODY BURIED_UTILS AS

    function calculate_age(buried in buried_t) return number AS
    BEGIN
        IF buried.born >= buried.passed THEN
            RAISE_APPLICATION_ERROR(-20111,'Invalid dates given.');
        END IF;
        
        RETURN MONTHS_BETWEEN(buried.passed, buried.born) / 12;
    END calculate_age;

    procedure create_buried(arg_personID in number, name in VARCHAR, surname in VARCHAR,
    born in DATE, passed in DATE, arg_graveID in NUMBER, arg_funeralID in NUMBER) AS
        person_exists NUMBER;
        funeral_exists NUMBER;
        grave_exists NUMBER;
        temp_funeral_ref REF funeral_t;
        temp_grave_ref REF grave_t;
        test_f funeral_t;
    BEGIN
        IF born >= passed THEN
            RAISE_APPLICATION_ERROR(-20111,'Invalid dates given.');
        END IF;

        SELECT COUNT(*) INTO person_exists FROM cemetery.BURIED WHERE personID = arg_personID;
        IF person_exists > 0 THEN
            RAISE_APPLICATION_ERROR(-20111,'Buried person with this ID already exists.');
        END IF;

        SELECT COUNT(*) INTO grave_exists FROM cemetery.GRAVES WHERE graveID = arg_graveID;
        IF grave_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'No grave with this ID.');
        END IF;

        SELECT COUNT(*) INTO funeral_exists FROM cemetery.FUNERALS f WHERE f.funeralID = arg_funeralID;
        IF funeral_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'No funeral with this ID.');
        END IF;

        SELECT REF(g) INTO temp_grave_ref FROM cemetery.GRAVES g WHERE g.graveID = arg_graveID;
        SELECT REF(f) INTO temp_funeral_ref FROM cemetery.FUNERALS f WHERE f.funeralID = arg_funeralID;

        INSERT INTO cemetery.BURIED (personID, name, surname, born, passed, grave_Ref, funeral_ref)
        VALUES (arg_personID, name, surname, born, passed, temp_grave_ref, temp_funeral_ref);
    END create_buried;

    procedure remove_buried(buried_id in number) AS
        buried_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO buried_exists FROM buried WHERE personID = buried_id;
        
        IF buried_exists < 1 THEN   
            RAISE_APPLICATION_ERROR(-20111,'Buried with this ID does not exist.');
        END IF;
        
        DELETE FROM cemetery.BURIED WHERE personID = buried_id;
    END remove_buried;
    
    PROCEDURE display_buried(arg_funeralID IN NUMBER) AS
        buried_cursor SYS_REFCURSOR;
        temp_name VARCHAR(50);
        temp_surname VARCHAR(70);
        temp_personID NUMBER;
        temp_born DATE;
        temp_passed DATE;
    BEGIN
        IF arg_funeralID < 1 THEN
            DBMS_OUTPUT.put_line('Wszyscy pochowani:');
            OPEN buried_cursor FOR SELECT personID, name, surname, born, passed FROM buried;
            LOOP
                FETCH buried_cursor INTO temp_personID, temp_name, temp_surname, temp_born, temp_passed;
                EXIT WHEN buried_cursor%notfound;
                DBMS_OUTPUT.put_line('Zmarly: ' || temp_name || ' ' || temp_surname
                || ' o ID: ' || temp_personID
                || '(* ' || temp_born || ' - +' || temp_passed || ')');
            END LOOP;
            CLOSE buried_cursor;
        ELSE
            DBMS_OUTPUT.put_line('Pochowani na pogrzebie o ID ' || arg_funeralID);
            OPEN buried_cursor FOR SELECT personID, name, surname, born, passed
            FROM buried WHERE deref(funeral_ref).funeralID = arg_funeralID;
            LOOP
                FETCH buried_cursor INTO temp_personID, temp_name, temp_surname, temp_born, temp_passed;
                EXIT WHEN buried_cursor%notfound;
                DBMS_OUTPUT.put_line('Zmarly: ' || temp_name || ' ' || temp_surname
                || ' o ID: ' || temp_personID
                || '(* ' || temp_born || ' - +' || temp_passed || ')');
            END LOOP;
            CLOSE buried_cursor;
        END IF;
    END display_buried;

END BURIED_UTILS;





--GRAVE_FOR_MANAGER
create or replace PACKAGE GRAVE_FOR_MANAGER AS 
    
    debug_for_archival_data NUMBER := 0;

    PROCEDURE update_expiration_date(arg_graveID in NUMBER,new_date in DATE);
    PROCEDURE update_grave_type(arg_graveID in NUMBER,new_type in VARCHAR);
    PROCEDURE assign_buried(arg_graveID in NUMBER, buriedID in NUMBER);
    PROCEDURE show_buried(arg_graveID IN NUMBER);
    PROCEDURE update_payment(arg_paymentID IN NUMBER, arg_graveID IN NUMBER);
    PROCEDURE add_grave(arg_graveID IN NUMBER, expiration_date IN DATE, grave_type IN VARCHAR, arg_paymentID IN NUMBER, arg_sectorID IN NUMBER);
    PROCEDURE remove_grave(arg_graveID IN NUMBER);
    PROCEDURE remove_grave_and_buried(arg_graveID IN NUMBER);

END GRAVE_FOR_MANAGER;





--GRAVE FOR MANAGER BODY
create or replace PACKAGE BODY GRAVE_FOR_MANAGER AS
    
    PROCEDURE update_expiration_date(arg_graveID in NUMBER,new_date in DATE) AS
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 

        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;

        IF new_date < SYSDATE() AND debug_for_archival_data = 0 THEN
            raise_application_error(-20111,'Date set in the past.');
        END IF;

        UPDATE cemetery.GRAVES SET expiration_date = new_date
        WHERE graveID = arg_graveID;
    END update_expiration_date;

    PROCEDURE update_grave_type(arg_graveID in NUMBER,new_type in VARCHAR) AS
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 

        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;

        IF LOWER(new_type) IN ('stone','frame','malsoleum','urn') THEN
            UPDATE cemetery.GRAVES SET grave_type = new_type WHERE graveID = arg_graveID;
        ELSE
            raise_application_error(-20111,'Invalid grave type.');
        END IF;
    END update_grave_type;

    PROCEDURE assign_buried(arg_graveID in NUMBER, buriedID in NUMBER) AS
        temp_grave_ref REF grave_t;
        grave_exists NUMBER;
        buried_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 

        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;

        SELECT COUNT(*) INTO buried_exists
        FROM buried WHERE personID = buriedID; 

        IF buried_exists = 0 THEN
            raise_application_error(-20111,'Buried with this ID does not exist.');
        END IF;

        SELECT REF(g) INTO temp_grave_ref FROM cemetery.GRAVES g WHERE g.graveID = arg_graveID;
        UPDATE cemetery.BURIED SET grave_ref = temp_grave_ref WHERE personID = buriedID;
    END assign_buried;

    PROCEDURE show_buried(arg_graveID IN NUMBER) AS
        CURSOR buried_cursor IS SELECT personID, name, surname, born, passed
        FROM cemetery.BURIED WHERE deref(grave_ref).graveID = arg_graveID;
        buried_row buried_cursor%ROWTYPE;
        disp_graveID NUMBER;
        disp_grave_type VARCHAR(20);
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 

        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;

        SELECT graveID INTO disp_graveID FROM cemetery.GRAVES WHERE graveID = arg_graveID;
        SELECT grave_type INTO disp_grave_type  FROM cemetery.GRAVES WHERE graveID = arg_graveID;

        DBMS_OUTPUT.put_line('ID Grobu: ' || disp_graveID
        || ', typ grobu: ' || disp_grave_type || '. Pochowani:');

        OPEN buried_cursor;
        LOOP
            FETCH buried_cursor INTO buried_row;
            EXIT WHEN buried_cursor%NOTFOUND;
            DBMS_OUTPUT.put_line('Tu leży ' || buried_row.name || ' ' || buried_row.surname || ', ID w systemie: ' || buried_row.personID
            || ', data urodzenia: ' || buried_row.born || ', data śmierci: ' || buried_row.passed);
        END LOOP;
        CLOSE buried_cursor;
    END show_buried;

    PROCEDURE update_payment(arg_paymentID IN NUMBER, arg_graveID IN NUMBER) AS
        temp_payment_ref REF payment_t;
        payment_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO payment_exists
        FROM cemetery.PAYMENTS WHERE paymentID = arg_paymentID; 

        IF payment_exists = 0 THEN
            raise_application_error(-20111,'Payment with this ID does not exist.');
        END IF;

        SELECT REF(p) INTO temp_payment_ref FROM cemetery.PAYMENTS p WHERE p.paymentID = arg_paymentID;
        UPDATE cemetery.GRAVES SET payment_ref = temp_payment_ref WHERE graveID = arg_graveID;
    END update_payment;

    PROCEDURE add_grave(arg_graveID IN NUMBER, expiration_date IN DATE, grave_type IN VARCHAR, arg_paymentID IN NUMBER, arg_sectorID IN NUMBER) AS
        grave_exists NUMBER;
        payment_exists NUMBER;
        sector_exists NUMBER;
        temp_payment_ref REF payment_t;
        temp_sector_ref REF sector_t;
    BEGIN
        SELECT COUNT(*) INTO grave_exists FROM cemetery.GRAVES WHERE graveID = arg_graveID;
        IF grave_exists > 0 THEN
            raise_application_error(-20111,'Grave with this ID already exists.');
        END IF;

        IF expiration_date < SYSDATE() AND debug_for_archival_data = 0 THEN
            raise_application_error(-20111,'Date set in the past.');
        END IF;

        IF LOWER(grave_type)  NOT IN ('stone','frame','malsoleum','urn') THEN
            raise_application_error(-20111,'Invalid grave type.');
        END IF;

        SELECT COUNT(*) INTO payment_exists FROM cemetery.PAYMENTS WHERE paymentID = arg_paymentID;
        IF payment_exists < 1 THEN
            raise_application_error(-20111,'No payment with this ID.');
        END IF;

        SELECT COUNT(*) INTO sector_exists FROM cemetery.SECTORS WHERE sectorID = arg_sectorID;
        IF sector_exists < 1 THEN
            raise_application_error(-20111,'No sector with this ID.');
        END IF;

        SELECT REF(p) INTO temp_payment_ref FROM cemetery.PAYMENTS p WHERE p.paymentID = arg_paymentID;
        SELECT REF(s) INTO temp_sector_ref FROM cemetery.SECTORS s WHERE s.sectorID = arg_sectorID;
        INSERT INTO cemetery.GRAVES VALUES (arg_graveID, expiration_date, grave_type, temp_payment_ref, temp_sector_ref);
    END add_grave;

    PROCEDURE remove_grave(arg_graveID IN NUMBER) AS
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 

        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;

        DELETE FROM cemetery.GRAVES WHERE graveID = arg_graveID;
    END remove_grave;

    PROCEDURE remove_grave_and_buried(arg_graveID IN NUMBER) AS
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 

        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;

        DELETE FROM cemetery.BURIED WHERE deref(grave_ref).graveID = arg_graveID;
        DELETE FROM cemetery.GRAVES WHERE graveID = arg_graveID;
    END remove_grave_and_buried;


END GRAVE_FOR_MANAGER;





--FUNERAL_FOR_MANAGER
create or replace PACKAGE FUNERAL_FOR_MANAGER AS 

    max_funerals_per_day NUMBER := 3;
    max_orders_per_worker NUMBER := 5;
    debug_for_archival_data NUMBER := 0;

    PROCEDURE add_funeral(arg_funeralID NUMBER, arg_funeral_date DATE, arg_priest_name VARCHAR);
    FUNCTION calculate_funeral_cost(arg_funeralID NUMBER) RETURN NUMBER;
    FUNCTION remove_funerals_by_date(cutoff_date DATE) RETURN NUMBER;
    PROCEDURE assign_service_worker(arg_funeralID NUMBER, arg_workerID NUMBER);
    PROCEDURE remove_service_worker(arg_funeralID NUMBER, arg_workerID NUMBER);
    PROCEDURE remove_funeral_by_id(funeral_to_remove NUMBER);
    PROCEDURE display_funerals;

END FUNERAL_FOR_MANAGER;





--FUNERAL FOR MANAGER BODY
create or replace PACKAGE BODY FUNERAL_FOR_MANAGER AS

    PROCEDURE add_funeral(arg_funeralID NUMBER, arg_funeral_date DATE, arg_priest_name VARCHAR) AS
        funeral_exists NUMBER;
        funerals_on_date NUMBER;
        temp_funeral_ref REF funeral_t;
    BEGIN
        SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = arg_funeralID;

        IF funeral_exists > 0 THEN
            raise_application_error(-20111,'Funeral with this ID already exists.');
        END IF;

        SELECT COUNT(*) INTO funerals_on_date FROM funerals
        WHERE trunc(funeral_date, 'DD') = trunc(arg_funeral_date, 'DD');

        IF funerals_on_date >= max_funerals_per_day THEN
            raise_application_error(-20111,'Too many funerals on this date.');
        END IF;

        IF arg_funeral_date < SYSDATE AND debug_for_archival_data = 0 THEN
            raise_application_error(-20111,'Funeral date set in the past.');
        END IF;

        INSERT INTO funerals VALUES (arg_funeralID, arg_funeral_date, arg_priest_name);
        SELECT REF(f) INTO temp_funeral_ref FROM cemetery.funerals f WHERE f.funeralID = arg_funeralID;
        INSERT INTO funerals_and_services VALUES (temp_funeral_ref, NEW service_workers_referencesnt());
    END add_funeral;

    FUNCTION calculate_funeral_cost(arg_funeralID NUMBER) RETURN NUMBER AS
        funeral_cost NUMBER;
        funeral_exists NUMBER;
        temp_funeral_services service_workers_referencesNT;
        temp_service_worker_ref REF service_worker_t;
        temp_service_worker service_worker_t;
    BEGIN
        SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = arg_funeralID;

        IF funeral_exists < 1 THEN
            raise_application_error(-20111,'Funeral with this ID does not exists.');
        END IF;

        funeral_cost := 0;
        SELECT funeral_services INTO temp_funeral_services
        FROM cemetery.FUNERALS_AND_SERVICES WHERE deref(funeral).funeralID = arg_funeralID;

        IF temp_funeral_services.FIRST IS NOT NULL THEN
            FOR i IN temp_funeral_services.FIRST .. temp_funeral_services.LAST LOOP
                temp_service_worker_ref := temp_funeral_services(i);
                SELECT deref(temp_service_worker_ref) INTO temp_service_worker FROM DUAL;
                funeral_cost := funeral_cost + temp_service_worker.service_cost;
            END LOOP;
        END IF;

        RETURN funeral_cost;
    END calculate_funeral_cost;

    FUNCTION remove_funerals_by_date(cutoff_date DATE) RETURN NUMBER AS
        deleted_funerals_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO deleted_funerals_count FROM funerals WHERE funeral_date < cutoff_date;
        DELETE FROM funerals_and_services WHERE deref(funeral).funeral_date < cutoff_date;
        DELETE FROM funerals WHERE funeral_date < cutoff_date;
        RETURN deleted_funerals_count;
    END remove_funerals_by_date;

    PROCEDURE assign_service_worker(arg_funeralID NUMBER, arg_workerID NUMBER) AS
        funeral_exists NUMBER;
        worker_exists NUMBER;
        temp_funeral_services service_workers_referencesNT;
        worker_active_orders NUMBER;
        temp_service_worker_ref REF service_worker_t;
        temp_service_worker service_worker_t;
        CURSOR funeral_cursor IS SELECT funeralID, funeral_date FROM funerals;
        funeral_row funeral_cursor%rowtype;
        temp_funeral_date DATE;
        temp_iter_funeral_date DATE;
    BEGIN
        --czy pogrzeb istnieje
        SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = arg_funeralID;

        IF funeral_exists < 1 THEN
            raise_application_error(-20111,'Funeral with this ID does not exists.');
        END IF;

        --czy pracownik istnieje
        SELECT COUNT(*) INTO worker_exists FROM service_workers WHERE workerID = arg_workerID;

        IF worker_exists < 1 THEN
            raise_application_error(-20111,'Worker with this ID does not exists.');
        END IF;

        --czy pracownik juz jest przypisany do tego pogrzebu
        SELECT funeral_services INTO temp_funeral_services
        FROM cemetery.FUNERALS_AND_SERVICES WHERE deref(funeral).funeralID = arg_funeralID;

        IF temp_funeral_services.FIRST() IS NOT NULL THEN
            FOR indx IN temp_funeral_services.FIRST() .. temp_funeral_services.LAST() LOOP
                SELECT temp_funeral_services(indx) INTO temp_service_worker_ref FROM DUAL;
                SELECT deref(temp_service_worker_ref) INTO temp_service_worker FROM DUAL;
                IF temp_service_worker.workerID = arg_workerID THEN
                    raise_application_error(-20111,'Worker with this ID is already assigned to funeral with this ID.');
                END IF;
            END LOOP;
        END IF;
        --czy pracownik ma jeszcze wolne zamówienia
        SELECT active_orders INTO worker_active_orders FROM service_workers WHERE workerID = arg_workerID;

        IF worker_active_orders >= max_orders_per_worker THEN
            raise_application_error(-20111,'Worker with this ID cannot take more orders.');
        END IF;

        --czy pracownik ma tego dnia pogrzeb
        OPEN funeral_cursor;
        LOOP
            FETCH funeral_cursor INTO funeral_row;
            EXIT WHEN funeral_cursor%notfound;

            SELECT funeral_services INTO temp_funeral_services
            FROM funerals_and_services WHERE deref(funeral).funeralID = funeral_row.funeralID;

            SELECT funeral_date INTO temp_funeral_date
            FROM funerals WHERE funeralID = arg_funeralID;
            SELECT funeral_date INTO temp_iter_funeral_date
            FROM funerals WHERE funeralID = funeral_row.funeralID;

            IF temp_funeral_services.FIRST IS NOT NULL THEN
                FOR i IN temp_funeral_services.FIRST .. temp_funeral_services.LAST LOOP
                    temp_service_worker_ref := temp_funeral_services(i);
                    SELECT deref(temp_service_worker_ref) INTO temp_service_worker FROM DUAL;

                    IF temp_service_worker.workerID <> arg_workerID THEN
                        CONTINUE;
                    END IF;

                    IF TRUNC(temp_funeral_date, 'dd') = TRUNC(temp_iter_funeral_date, 'dd') THEN
                        raise_application_error(-20111,'Worker with this ID is already assigned to a funeral on this date.');
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
        CLOSE funeral_cursor;

        --aktualizacja wartości
        UPDATE service_workers SET active_orders = (worker_active_orders + 1) WHERE workerID = arg_workerID;
        SELECT funeral_services INTO temp_funeral_services FROM funerals_and_services
        WHERE deref(funeral).funeralID = arg_funeralID;
        SELECT REF(sw) INTO temp_service_worker_ref FROM service_workers sw
        WHERE sw.workerID = arg_workerID;
        temp_funeral_services.EXTEND(1);
        temp_funeral_services(temp_funeral_services.LAST) := temp_service_worker_ref;
        UPDATE funerals_and_services SET funeral_services = temp_funeral_services
        WHERE deref(funeral).funeralID = arg_funeralID;
    END assign_service_worker;

    PROCEDURE remove_service_worker(arg_funeralID NUMBER, arg_workerID NUMBER) AS
        funeral_exists NUMBER;
        worker_exists NUMBER;
        worker_not_assigned NUMBER := 1;
        temp_funeral_services service_workers_referencesNT;
        temp_service_worker_ref REF service_worker_t;
        temp_service_worker service_worker_t;
    BEGIN
        SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = arg_funeralID;

        IF funeral_exists < 1 THEN
            raise_application_error(-20111,'Funeral with this ID does not exists.');
        END IF;

        SELECT COUNT(*) INTO worker_exists FROM service_workers WHERE workerID = arg_workerID;

        IF worker_exists < 1 THEN
            raise_application_error(-20111,'Worker with this ID does not exists.');
        END IF;

        SELECT funeral_services INTO temp_funeral_services
        FROM cemetery.FUNERALS_AND_SERVICES WHERE deref(funeral).funeralID = arg_funeralID;

        IF temp_funeral_services.FIRST IS NOT NULL THEN
            FOR i IN temp_funeral_services.FIRST .. temp_funeral_services.LAST LOOP
                temp_service_worker_ref := temp_funeral_services(i);
                SELECT deref(temp_service_worker_ref) INTO temp_service_worker FROM DUAL;
                IF temp_service_worker.workerID = arg_workerID THEN
                    temp_funeral_services.delete(i);
                    UPDATE service_workers SET active_orders = (active_orders - 1) WHERE workerID = arg_workerID;
                    UPDATE funerals_and_services SET funeral_services = temp_funeral_services
                    WHERE deref(funeral).funeralID = arg_funeralID;
                    worker_not_assigned := 0;
                    EXIT;
                END IF;
            END LOOP;
        END IF;

        IF worker_not_assigned = 1 THEN
            raise_application_error(-20111,'Worker with this ID was not assigned to this funeral.');
        END IF;
    END remove_service_worker;

    PROCEDURE display_funerals AS
        CURSOR funeral_cursor IS SELECT funeralID, funeral_date, priest_name FROM funerals;
        funeral_row funeral_cursor%rowtype;
    BEGIN
        OPEN funeral_cursor;
        LOOP
            FETCH funeral_cursor INTO funeral_row;
            EXIT WHEN funeral_cursor%notfound;

            IF funeral_row.priest_name IS NOT NULL THEN
                DBMS_OUTPUT.put_line('Pogrzeb o ID ' || funeral_row.funeralID
                || ' odbyl sie ' || funeral_row.funeral_date
                || '. Duchowny: ' || funeral_row.priest_name || '.');
            ELSE
                DBMS_OUTPUT.put_line('Pogrzeb o ID ' || funeral_row.funeralID
                || ' odbyl sie ' || funeral_row.funeral_date || '.');
            END IF;
        END LOOP;
        CLOSE funeral_cursor;
    END display_funerals;
    
    PROCEDURE remove_funeral_by_id(funeral_to_remove NUMBER) AS
        funeral_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = funeral_to_remove;
        IF funeral_exists < 1 THEN
            raise_application_error(-20111,'Funeral with this ID does not exists.');
        ELSE 
            DELETE FROM funerals_and_services WHERE deref(funeral).funeralID = funeral_to_remove;  
            DELETE FROM FUNERALS WHERE funeralID = funeral_to_remove;    
        END IF;
    END remove_funeral_by_id;

END FUNERAL_FOR_MANAGER;





--GUEST PACKAGE
create or replace PACKAGE GUEST_PACKAGE AS 

    PROCEDURE display_graves_in_area(arg_areaID IN NUMBER);
    PROCEDURE display_graves_in_sector(arg_sectorID IN NUMBER);
    PROCEDURE display_payments;
    PROCEDURE show_buried_in_grave(arg_graveID IN NUMBER);
    PROCEDURE display_funerals;
    PROCEDURE display_service_workers;
    PROCEDURE display_buried_in_funeral(arg_funeralID IN NUMBER);

END GUEST_PACKAGE;





--GUEST PACKAGE BODY
create or replace PACKAGE BODY GUEST_PACKAGE AS

    PROCEDURE display_graves_in_area(arg_areaID IN NUMBER) AS
        CURSOR grave_cursor IS SELECT graveID, expiration_date, grave_type, payment_ref
        FROM cemetery.GRAVES WHERE deref(sector_ref).areaID = arg_areaID;
        CURSOR buried_cursor(gID NUMBER) IS SELECT personID, name, surname, born, passed
        FROM cemetery.BURIED WHERE deref(grave_ref).graveID = gID;
        grave_row grave_cursor%ROWTYPE;
        buried_row buried_cursor%ROWTYPE;
        temp_payment payment_t;
        area_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO area_exists FROM religious_areas WHERE areaID = arg_areaID;
        IF area_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Area with this ID does not exist.');
        END IF;

        OPEN grave_cursor;
        LOOP
            FETCH grave_cursor INTO grave_row;
            EXIT WHEN grave_cursor%NOTFOUND;
            DBMS_OUTPUT.put_line('ID Grobu: ' || grave_row.graveID);
            DBMS_OUTPUT.put_line('Data wygaśnięcia: ' || grave_row.expiration_date);
            DBMS_OUTPUT.put_line('Typ grobu: ' || grave_row.grave_type);
            SELECT deref(grave_row.payment_ref) INTO temp_payment FROM dual;
            DBMS_OUTPUT.put_line('ID zapłaty: ' || temp_payment.paymentID);
            DBMS_OUTPUT.put_line('Wartość zapłaty: ' || temp_payment.value);
            DBMS_OUTPUT.put_line('Opłacono dnia: ' || temp_payment.payment_date);
            DBMS_OUTPUT.put_line('Pochowani w grobie:');

            OPEN buried_cursor(grave_row.graveID);
            LOOP
                FETCH buried_cursor INTO buried_row;
                EXIT WHEN buried_cursor%NOTFOUND;
                DBMS_OUTPUT.put_line('Tu leży ' || buried_row.name || ' ' || buried_row.surname || ', ID w systemie: ' || buried_row.personID
                || ', data urodzenia: ' || buried_row.born || ', data śmierci: ' || buried_row.passed);
            END LOOP;
            CLOSE buried_cursor;

            DBMS_OUTPUT.put_line('');
        END LOOP;
        CLOSE grave_cursor;
    END display_graves_in_area;

    PROCEDURE display_graves_in_sector(arg_sectorID IN NUMBER) AS
        CURSOR grave_cursor IS SELECT graveID, expiration_date, grave_type, payment_ref
        FROM cemetery.GRAVES WHERE deref(sector_ref).sectorID = arg_sectorID;
        CURSOR buried_cursor(gID NUMBER) IS SELECT personID, name, surname, born, passed
        FROM cemetery.BURIED WHERE deref(grave_ref).graveID = gID;
        grave_row grave_cursor%ROWTYPE;
        buried_row buried_cursor%ROWTYPE;
        temp_payment payment_t;
        sector_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO sector_exists FROM sectors WHERE sectorID = arg_sectorID;
        IF sector_exists < 1 THEN
            RAISE_APPLICATION_ERROR(-20111,'Sector with this ID does not exist.');
        END IF;

        OPEN grave_cursor;
        LOOP
            FETCH grave_cursor INTO grave_row;
            EXIT WHEN grave_cursor%NOTFOUND;
            DBMS_OUTPUT.put_line('ID Grobu: ' || grave_row.graveID);
            DBMS_OUTPUT.put_line('Data wygaśnięcia: ' || grave_row.expiration_date);
            DBMS_OUTPUT.put_line('Typ grobu: ' || grave_row.grave_type);
            SELECT deref(grave_row.payment_ref) INTO temp_payment FROM dual;
            DBMS_OUTPUT.put_line('ID zapłaty: ' || temp_payment.paymentID);
            DBMS_OUTPUT.put_line('Wartość zapłaty: ' || temp_payment.value);
            DBMS_OUTPUT.put_line('Opłacono dnia: ' || temp_payment.payment_date);
            DBMS_OUTPUT.put_line('Pochowani w grobie:');

            OPEN buried_cursor(grave_row.graveID);
            LOOP
                FETCH buried_cursor INTO buried_row;
                EXIT WHEN buried_cursor%NOTFOUND;
                DBMS_OUTPUT.put_line('Tu leży ' || buried_row.name || ' ' || buried_row.surname || ', ID w systemie: ' || buried_row.personID
                || ', data urodzenia: ' || buried_row.born || ', data śmierci: ' || buried_row.passed);
            END LOOP;
            CLOSE buried_cursor;

            DBMS_OUTPUT.put_line('');
        END LOOP;
        CLOSE grave_cursor;
    END display_graves_in_sector;

    PROCEDURE display_payments AS
        CURSOR payment_cursor IS SELECT paymentID, payment_date, value FROM payments;
        payment_row payment_cursor%rowtype;
    BEGIN
        OPEN payment_cursor;
        LOOP
            FETCH payment_cursor INTO payment_row;
            EXIT WHEN payment_cursor%notfound;
            DBMS_OUTPUT.put_line('Platnosc o ID: ' || payment_row.paymentID
            || 'data: ' || payment_row.payment_date || ' na ' || payment_row.value || '.');
        END LOOP;
        CLOSE payment_cursor;
    END display_payments;

    PROCEDURE show_buried_in_grave(arg_graveID IN NUMBER) AS
        CURSOR buried_cursor IS SELECT personID, name, surname, born, passed
        FROM cemetery.BURIED WHERE deref(grave_ref).graveID = arg_graveID;
        buried_row buried_cursor%ROWTYPE;
        disp_graveID NUMBER;
        disp_grave_type VARCHAR(20);
        grave_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO grave_exists
        FROM graves WHERE graveID = arg_graveID; 

        IF grave_exists = 0 THEN
            raise_application_error(-20111,'Grave with this ID does not exist.');
        END IF;

        SELECT graveID INTO disp_graveID FROM cemetery.GRAVES WHERE graveID = arg_graveID;
        SELECT grave_type INTO disp_grave_type  FROM cemetery.GRAVES WHERE graveID = arg_graveID;

        DBMS_OUTPUT.put_line('ID Grobu: ' || disp_graveID
        || ', typ grobu: ' || disp_grave_type || '. Pochowani:');

        OPEN buried_cursor;
        LOOP
            FETCH buried_cursor INTO buried_row;
            EXIT WHEN buried_cursor%NOTFOUND;
            DBMS_OUTPUT.put_line('Tu leży ' || buried_row.name || ' ' || buried_row.surname || ', ID w systemie: ' || buried_row.personID
            || ', data urodzenia: ' || buried_row.born || ', data śmierci: ' || buried_row.passed);
        END LOOP;
        CLOSE buried_cursor;
    END show_buried_in_grave;

    PROCEDURE display_funerals AS
        CURSOR funeral_cursor IS SELECT funeralID, funeral_date, priest_name FROM funerals;
        funeral_row funeral_cursor%rowtype;
    BEGIN
        OPEN funeral_cursor;
        LOOP
            FETCH funeral_cursor INTO funeral_row;
            EXIT WHEN funeral_cursor%notfound;

            IF funeral_row.priest_name IS NOT NULL THEN
                DBMS_OUTPUT.put_line('Pogrzeb o ID ' || funeral_row.funeralID
                || ' odbyl sie ' || funeral_row.funeral_date
                || '. Duchowny: ' || funeral_row.priest_name || '.');
            ELSE
                DBMS_OUTPUT.put_line('Pogrzeb o ID ' || funeral_row.funeralID
                || ' odbyl sie ' || funeral_row.funeral_date || '.');
            END IF;
        END LOOP;
        CLOSE funeral_cursor;
    END display_funerals;

    PROCEDURE display_service_workers AS
        CURSOR worker_cursor IS SELECT workerID, name, surname, profession,
        phone, reputation, active_orders, service_cost FROM service_workers;
        worker_row worker_cursor%rowtype;
    BEGIN
        OPEN worker_cursor;
        LOOP
                FETCH worker_cursor INTO worker_row;
                EXIT WHEN worker_cursor%notfound;
                DBMS_OUTPUT.put_line('Pracownik uslug ' || worker_row.name || ' '
                || worker_row.surname || ' o ID ' || worker_row.workerID
                || ' w zawodzie ' || worker_row.profession || ' o reputacji ' 
                || worker_row.reputation || ' z numerem telefonu ' || worker_row.phone
                || ' i kosztem uslugi ' || worker_row.service_cost || ' ma '
                || worker_row.active_orders || ' zaplanowanych wykonan uslugi.');
        END LOOP;
        CLOSE worker_cursor;
    END display_service_workers;

     PROCEDURE display_buried_in_funeral(arg_funeralID IN NUMBER) AS
        buried_cursor SYS_REFCURSOR;
        temp_name VARCHAR(50);
        temp_surname VARCHAR(70);
        temp_personID NUMBER;
        temp_born DATE;
        temp_passed DATE;
    BEGIN
        IF arg_funeralID < 1 THEN
            DBMS_OUTPUT.put_line('Wszyscy pochowani:');
            OPEN buried_cursor FOR SELECT personID, name, surname, born, passed FROM buried;
            LOOP
                FETCH buried_cursor INTO temp_personID, temp_name, temp_surname, temp_born, temp_passed;
                EXIT WHEN buried_cursor%notfound;
                DBMS_OUTPUT.put_line('Zmarly: ' || temp_name || ' ' || temp_surname
                || ' o ID: ' || temp_personID
                || '(* ' || temp_born || ' - +' || temp_passed || ')');
            END LOOP;
            CLOSE buried_cursor;
        ELSE
            DBMS_OUTPUT.put_line('Pochowani na pogrzebie o ID ' || arg_funeralID);
            OPEN buried_cursor FOR SELECT personID, name, surname, born, passed
            FROM buried WHERE deref(funeral_ref).funeralID = arg_funeralID;
            LOOP
                FETCH buried_cursor INTO temp_personID, temp_name, temp_surname, temp_born, temp_passed;
                EXIT WHEN buried_cursor%notfound;
                DBMS_OUTPUT.put_line('Zmarly: ' || temp_name || ' ' || temp_surname
                || ' o ID: ' || temp_personID
                || '(* ' || temp_born || ' - +' || temp_passed || ')');
            END LOOP;
            CLOSE buried_cursor;
        END IF;
    END display_buried_in_funeral;

END GUEST_PACKAGE;


