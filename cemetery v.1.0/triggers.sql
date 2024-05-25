create or replace TRIGGER ADD_BURIED_INTEGRITY_TRIGGER 
BEFORE INSERT OR UPDATE ON BURIED FOR EACH ROW 
DECLARE
    funeral_exists NUMBER;
    grave_exists NUMBER;
    nonexistent_id NUMBER;
BEGIN
    SELECT COUNT(*) INTO grave_exists FROM graves WHERE graveID = deref(:NEW.grave_ref).graveID;
    
    IF grave_exists < 1 THEN
        SELECT deref(:NEW.grave_ref).graveID INTO nonexistent_id FROM DUAL;
        RAISE_APPLICATION_ERROR(-20112,'No sector with ID ' || nonexistent_id || '.');
    END IF;
    
    SELECT COUNT(*) INTO funeral_exists FROM funerals WHERE funeralID = deref(:NEW.funeral_ref).funeralID;
    
    IF funeral_exists < 1 THEN
        SELECT deref(:NEW.funeral_ref).funeralID INTO nonexistent_id FROM DUAL;
        RAISE_APPLICATION_ERROR(-20112,'No sector with ID ' || nonexistent_id || '.');
    END IF;
END;




create or replace TRIGGER ADD_GRAVE_INTEGRITY_TRIGGER 
BEFORE INSERT OR UPDATE ON GRAVES FOR EACH ROW 
DECLARE
    sector_exists NUMBER;
    payment_exists NUMBER;
    nonexistent_id NUMBER;
BEGIN
    SELECT COUNT(*) INTO sector_exists FROM sectors WHERE sectorID = deref(:NEW.sector_ref).sectorID;
    
    IF sector_exists < 1 THEN
        SELECT deref(:NEW.sector_ref).sectorID INTO nonexistent_id FROM DUAL;
        RAISE_APPLICATION_ERROR(-20112,'No sector with ID ' || nonexistent_id || '.');
    END IF;
    
    SELECT COUNT(*) INTO payment_exists FROM payments WHERE paymentID = deref(:NEW.payment_ref).paymentID;
    
    IF payment_exists < 1 THEN
        SELECT deref(:NEW.payment_ref).paymentID INTO nonexistent_id FROM DUAL;
        RAISE_APPLICATION_ERROR(-20112,'No payment with ID ' || nonexistent_id || '.');
    END IF;
END;




create or replace TRIGGER KEEP_GRAVE_COUNT_IN_SECTOR 
BEFORE DELETE OR INSERT OR UPDATE OF sector_ref ON GRAVES FOR EACH ROW
DECLARE
    sector_grave_count NUMBER;
    sector_ref REF SECTOR_T;
BEGIN
    IF DELETING THEN
        SELECT grave_count INTO sector_grave_count FROM sectors WHERE sectorID = deref(:OLD.sector_ref).sectorID;
        sector_grave_count := sector_grave_count - 1;
        UPDATE sectors SET grave_count = sector_grave_count WHERE sectorID = deref(:OLD.sector_ref).sectorID;
    END IF;
    
    IF INSERTING THEN
        SELECT grave_count INTO sector_grave_count FROM sectors WHERE sectorID = deref(:NEW.sector_ref).sectorID;
        sector_grave_count := sector_grave_count + 1;
        UPDATE sectors SET grave_count = sector_grave_count WHERE sectorID = deref(:NEW.sector_ref).sectorID;
    END IF;
    
    IF UPDATING THEN
        SELECT grave_count INTO sector_grave_count FROM sectors WHERE sectorID = deref(:OLD.sector_ref).sectorID;
        sector_grave_count := sector_grave_count - 1;
        UPDATE sectors SET grave_count = sector_grave_count WHERE sectorID = deref(:OLD.sector_ref).sectorID;
        
        SELECT grave_count INTO sector_grave_count FROM sectors WHERE sectorID = deref(:NEW.sector_ref).sectorID;
        sector_grave_count := sector_grave_count + 1;
        UPDATE sectors SET grave_count = sector_grave_count WHERE sectorID = deref(:NEW.sector_ref).sectorID;
    END IF;
END;




create or replace TRIGGER SECTORS_TO_AREAID_FOREIGN_KEY_TRIGGER
BEFORE INSERT OR UPDATE OF AREAID, GRAVE_COUNT ON SECTORS FOR EACH ROW 
DECLARE
    AREA_EXISTS NUMBER;
BEGIN
    SELECT COUNT(*) INTO AREA_EXISTS FROM RELIGIOUS_AREAS WHERE AreaID = :NEW.AreaID;
    
    IF AREA_EXISTS < 1 THEN
        RAISE_APPLICATION_ERROR(-20112,'No religious area with ID ' || :NEW.AREAID || '.');
    END IF;
END;
