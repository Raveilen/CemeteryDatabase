SET SERVEROUTPUT ON;

ALTER SESSION SET CURRENT_SCHEMA = MANAGER1;

DECLARE
  v_count NUMBER;
BEGIN
  v_count := CEMETERY.RELIGIOUS_AREA_UTILS.COUNT_GRAVES(1);
  DBMS_OUTPUT.PUT_LINE('Grobow w strefie 1: ' || v_count);
  v_count := CEMETERY.RELIGIOUS_AREA_UTILS.COUNT_GRAVES(2);
  DBMS_OUTPUT.PUT_LINE('Grobow w strefie 2: ' || v_count);
  v_count := CEMETERY.RELIGIOUS_AREA_UTILS.COUNT_GRAVES(3);
  DBMS_OUTPUT.PUT_LINE('Grobow w strefie 3: ' || v_count);
  v_count := CEMETERY.RELIGIOUS_AREA_UTILS.COUNT_SECTORS(1);
  DBMS_OUTPUT.PUT_LINE('Sektorow w strefie 1: ' || v_count);
  v_count := CEMETERY.RELIGIOUS_AREA_UTILS.COUNT_SECTORS(2);
  DBMS_OUTPUT.PUT_LINE('Sektorow w strefie 2: ' || v_count);
  v_count := CEMETERY.RELIGIOUS_AREA_UTILS.COUNT_SECTORS(3);
  DBMS_OUTPUT.PUT_LINE('Sektorow w strefie 3: ' || v_count);
  
  DBMS_OUTPUT.PUT_LINE('Groby w strefie 3: ');
  CEMETERY.RELIGIOUS_AREA_UTILS.display_graves(3);
  
  DBMS_OUTPUT.PUT_LINE('Sektory w strefie 2: ');
  CEMETERY.RELIGIOUS_AREA_UTILS.display_sectors(2);
  ROLLBACK;
END;

DECLARE
    v_count NUMBER;
    test_val NUMBER;
BEGIN
    v_count := cemetery.sector_utils.count_graves(1);
    DBMS_OUTPUT.PUT_LINE('Grobow w sektorze 1: ' || v_count);
    v_count := cemetery.sector_utils.count_graves(2);
    DBMS_OUTPUT.PUT_LINE('Grobow w sektorze 2: ' || v_count);
    v_count := cemetery.sector_utils.count_graves(6);
    DBMS_OUTPUT.PUT_LINE('Grobow w sektorze 6: ' || v_count);
    
    DBMS_OUTPUT.PUT_LINE('Zmiana strefy sektora:');
    CEMETERY.RELIGIOUS_AREA_UTILS.display_sectors(1);
    cemetery.sector_utils.change_area(1, 4);
    CEMETERY.RELIGIOUS_AREA_UTILS.display_sectors(4);
    cemetery.sector_utils.change_area(1, 1);
    
    DBMS_OUTPUT.PUT_LINE('Groby w sektorze 1:');
    cemetery.sector_utils.display_graves(1);
    ROLLBACK;
END;

--kasuje rekordy w tabelach burried, graves, funerals,service_workers;
DECLARE
    num_var NUMBER;
BEGIN
    cemetery.grave_for_manager.update_expiration_date(1,to_date('2030-01-01', 'yyyy-mm-dd'));
    cemetery.grave_for_manager.update_grave_type(1,'stone');
    cemetery.grave_for_manager.assign_buried(1,5);
    cemetery.grave_for_manager.show_buried(1);
    cemetery.grave_for_manager.update_payment(3,1);
    cemetery.grave_for_manager.add_grave(150,to_date('2045-01-01', 'yyyy-mm-dd'),'urn',2,7);
    DBMS_OUTPUT.put_line('----------');
--    cemetery.sector_utils.display_graves(7);
--    cemetery.grave_for_manager.remove_grave(150);
--    cemetery.grave_for_manager.add_grave(150, to_date('2045-01-01', 'yyyy-mm-dd'),'urn',2,7);
--    cemetery.grave_for_manager.assign_buried(150,5);
    DBMS_OUTPUT.put_line('----------');
--    cemetery.grave_for_manager.show_buried(150);
--    cemetery.grave_for_manager.remove_grave_and_buried(150);
    
    DBMS_OUTPUT.put_line('----------');
    cemetery.sector_utils.display_graves(1);
    ROLLBACK;
END;

DECLARE
BEGIN
    CEMETERY.BURIED_UTILS.create_buried(150, 'Jan', 'Kowalski', to_date('1965-01-01', 'yyyy-mm-dd'),
    to_date('2020-02-01', 'yyyy-mm-dd'),5, 10);
    CEMETERY.BURIED_UTILS.display_buried(10);
    CEMETERY.BURIED_UTILS.remove_buried(150);
    ROLLBACK;
END;

DECLARE
BEGIN
    
    CEMETERY.PAYMENT_UTILS.ADD_PAYMENT(256,2500,to_date('2015-08-15','YYYY-MM-DD'));
    CEMETERY.PAYMENT_UTILS.DISPLAY_PAYMENTS();    
    DBMS_OUTPUT.PUT_LINE('Dodajemy płatność');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    CEMETERY.PAYMENT_UTILS.REMOVE_PAYMENT(256);
    CEMETERY.PAYMENT_UTILS.DISPLAY_PAYMENTS();
    DBMS_OUTPUT.PUT_LINE('Usuwamy płatność');
    DBMS_OUTPUT.PUT_LINE(' ');
    ROLLBACK;
END;

DECLARE
funeral_cost NUMBER;
BEGIN
    
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(256,to_date('2035-12-22','YYYY-MM-DD'),'VALID DATE');
    CEMETERY.FUNERAL_FOR_MANAGER.display_funerals();
    DBMS_OUTPUT.PUT_LINE('Dodajemy pogrzeb o ID 256');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    CEMETERY.FUNERAL_FOR_MANAGER.remove_funeral_by_id(256);
    CEMETERY.FUNERAL_FOR_MANAGER.display_funerals();
    DBMS_OUTPUT.PUT_LINE('Kasujemy pogrzeb o ID 256');
    DBMS_OUTPUT.PUT_LINE(' ');
    ROLLBACK;
END;    

DECLARE
BEGIN
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(1,1); 
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(1,1); --nie można przydzielić 2 razy do tego samego pogrzebu
    ROLLBACK;
END;


DECLARE
BEGIN
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(1,222); -- nie istnieje   
    ROLLBACK;
END;

DECLARE
funeral_cost NUMBER;
BEGIN
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(1,1);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(1,2);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(1,3);

    funeral_cost := CEMETERY.FUNERAL_FOR_MANAGER.calculate_funeral_cost(1);
    DBMS_OUTPUT.PUT_LINE('Koszt obliczany na podstawie ceny usług pracowników pogrzebowych');
    DBMS_OUTPUT.PUT_LINE(funeral_cost);
    DBMS_OUTPUT.PUT_LINE(' ');
    ROLLBACK;
END;

DECLARE
BEGIN
    CEMETERY.FUNERAL_FOR_MANAGER.remove_service_worker(1,4); --nie jest przypisany do pogrzebu
    ROLLBACK;
END;

DECLARE
funeral_cost NUMBER;
BEGIN
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(1,1);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(1,2);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(1,3);
    
    CEMETERY.FUNERAL_FOR_MANAGER.remove_service_worker(1,2);
    
    funeral_cost := CEMETERY.FUNERAL_FOR_MANAGER.calculate_funeral_cost(1);
    DBMS_OUTPUT.PUT_LINE('Koszt pogrzebu się zmienia gdy usuwamy pracownika z pogrzebu');
    DBMS_OUTPUT.PUT_LINE(funeral_cost);
    DBMS_OUTPUT.PUT_LINE(' ');
    
    CEMETERY.FUNERAL_FOR_MANAGER.remove_funeral_by_id(1);
    CEMETERY.FUNERAL_FOR_MANAGER.display_funerals();
    DBMS_OUTPUT.PUT_LINE('Skasowano pogrzeb 1');
    DBMS_OUTPUT.PUT_LINE(' ');
    ROLLBACK;
END;    
    
DECLARE
funerals_removed NUMBER;
BEGIN
    funerals_removed := CEMETERY.FUNERAL_FOR_MANAGER.remove_funerals_by_date(to_date('2005-01-01','YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Skasowano: ' || to_char(funerals_removed) || ' pogrzebów');
    DBMS_OUTPUT.PUT_LINE(' ');
    ROLLBACK;
END;

DECLARE
BEGIN
    
    CEMETERY.SERVICE_WORKER_UTILS.add_service_worker(223,'DEMO','TEST','flautist','123-456-789',1,123);
    CEMETERY.SERVICE_WORKER_UTILS.display_service_workers();
    DBMS_OUTPUT.PUT_LINE('Dodano pracownika 223');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    
    CEMETERY.SERVICE_WORKER_UTILS.remove_service_worker(223);
    CEMETERY.SERVICE_WORKER_UTILS.display_service_workers();
    DBMS_OUTPUT.PUT_LINE('Skasowano pracownika 223');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    ROLLBACK;
END;


BEGIN
    CEMETERY.SERVICE_WORKER_UTILS.add_service_worker(223,'DEMO','TEST','flautist','123-456-789',1,123);
    
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(111,to_date('2025-06-10','YYYY-MM-DD'),'WHITE');
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(222,to_date('2025-09-04','YYYY-MM-DD'),'SAINT');
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(333,to_date('2024-12-28','YYYY-MM-DD'),'WITHERS');
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(444,to_date('2024-11-15','YYYY-MM-DD'),'JACKSON');
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(555,to_date('2024-08-01','YYYY-MM-DD'),'NELSON');
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(666,to_date('2024-05-08','YYYY-MM-DD'),'KEITH');
    
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(111,223);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(222,223);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(333,223);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(444,223);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(555,223);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(666,223);
    
    CEMETERY.SERVICE_WORKER_UTILS.display_service_workers(); --błąd: pracownik osiągnął limit zamówień.
    DBMS_OUTPUT.PUT_LINE(' ');
    
    ROLLBACK;
END;


DECLARE
    future_count NUMBER; 
BEGIN
    
    CEMETERY.SERVICE_WORKER_UTILS.add_service_worker(223,'DEMO','TEST','flautist','123-456-789',1,123);
    
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(111,to_date('2025-06-10','YYYY-MM-DD'),'WHITE');
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(222,to_date('2025-09-04','YYYY-MM-DD'),'SAINT');
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(333,to_date('2024-12-28','YYYY-MM-DD'),'WITHERS');
    
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(111,223);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(222,223);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(333,223);
    
    CEMETERY.SERVICE_WORKER_UTILS.display_service_workers();
    future_count := CEMETERY.SERVICE_WORKER_UTILS.count_orders_in_future(223);
    DBMS_OUTPUT.PUT_LINE(future_count); 
    DBMS_OUTPUT.PUT_LINE('pracownik o numerze 223 ma 3 zaplanowane zamówienia');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    ROLLBACK;
END;

DECLARE
    future_count NUMBER; 
BEGIN
    CEMETERY.SERVICE_WORKER_UTILS.add_service_worker(223,'DEMO','TEST','flautist','123-456-789',1,123);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(1,223);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(2,223);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(3,223);

    CEMETERY.SERVICE_WORKER_UTILS.display_service_workers();    
    future_count := CEMETERY.SERVICE_WORKER_UTILS.count_orders_in_future(223);
    DBMS_OUTPUT.PUT_LINE(future_count); 
    DBMS_OUTPUT.PUT_LINE('Pracownik posiada 3 zamówienia choć pogrzeby odbyły się w przeszłości');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    CEMETERY.SERVICE_WORKER_UTILS.update_orders_count_by_ID(223);
    CEMETERY.SERVICE_WORKER_UTILS.display_service_workers();    
    future_count := CEMETERY.SERVICE_WORKER_UTILS.count_orders_in_future(223);
    DBMS_OUTPUT.PUT_LINE(future_count); 
    DBMS_OUTPUT.PUT_LINE('Funkcja update_orders_count aktualizuje licznik aktywnych zamówień sprawdzając, czy pogrzeb już był czy dopiero się odbędzie.');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    ROLLBACK;
END;

--PRZYKŁAD UŻYCIA:

DECLARE
    expiration_date NUMBER;
    date_of_death DATE;
BEGIN
    date_of_death := to_date('2024-02-27','YYYY-MM-DD');
    CEMETERY.PAYMENT_UTILS.add_payment(223,1200,date_of_death+1);
    CEMETERY.PAYMENT_UTILS.display_payments();
    DBMS_OUTPUT.PUT_LINE('wprowadzamy płatność za grób zmarłego');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    expiration_date := 20*12; --20 lat od złożenia opłaty za grób.
    CEMETERY.GRAVE_FOR_MANAGER.add_grave(223,ADD_MONTHS(date_of_death+1,expiration_date),'frame',223,1);
    CEMETERY.SECTOR_UTILS.display_graves(1);
    DBMS_OUTPUT.PUT_LINE('Dodajemy grób zmarłego. Umiesczony on zostanie w sektorze 1 wraz z ID płatności 223.');
    DBMS_OUTPUT.PUT_LINE(' ');
--    
    CEMETERY.FUNERAL_FOR_MANAGER.add_funeral(224,date_of_death+5,'ADAMS');
    CEMETERY.FUNERAL_FOR_MANAGER.display_funerals();
    DBMS_OUTPUT.PUT_LINE('Planujemy pogrzeb zmarłego (5 dni po jego zgonie)');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(224,3);
    CEMETERY.FUNERAL_FOR_MANAGER.assign_service_worker(224,4);
    
    DBMS_OUTPUT.PUT_LINE('Dobieramy usługi do pogrzebu: trąbka - 345, kwiaty - 100');
    DBMS_OUTPUT.PUT_LINE('Sumarycznie wychodzi: ' || to_char(CEMETERY.FUNERAL_FOR_MANAGER.calculate_funeral_cost(224) || '$'));
    DBMS_OUTPUT.PUT_LINE(' ');
    
    CEMETERY.BURIED_UTILS.create_buried(223,'JOHN','SMITH',to_date('1955-06-05','YYYY-MM-DD'),date_of_death,223,224);
    CEMETERY.GRAVE_FOR_MANAGER.show_buried(223);
    DBMS_OUTPUT.PUT_LINE('Tworzymy rekord zmarłego w bazie. Przypisujemy go do grobu 223 i przypisujemy mu pogrzeb 224');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    CEMETERY.GRAVE_FOR_MANAGER.update_grave_type(223,'stone');
    CEMETERY.GRAVE_FOR_MANAGER.show_buried(223);
    DBMS_OUTPUT.PUT_LINE('Zmiana typu pomnika');
    DBMS_OUTPUT.PUT_LINE(' ');
    ROLLBACK;
      
END;


ALTER SESSION SET CURRENT_SCHEMA = CEMETERY;