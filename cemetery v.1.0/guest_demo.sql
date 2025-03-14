SET SERVEROUTPUT ON;

ALTER SESSION SET CURRENT_SCHEMA=GUEST1;

EXECUTE CEMETERY.GUEST_PACKAGE.display_funerals();

EXECUTE CEMETERY.GUEST_PACKAGE.display_buried_in_funeral(1);

EXECUTE CEMETERY.GUEST_PACKAGE.display_graves_in_area(3);

EXECUTE CEMETERY.GUEST_PACKAGE.display_graves_in_sector(2);

EXECUTE CEMETERY.GUEST_PACKAGE.display_payments();

EXECUTE CEMETERY.GUEST_PACKAGE.display_service_workers();

EXECUTE CEMETERY.GUEST_PACKAGE.show_buried_in_grave(46);

ALTER SESSION SET CURRENT_SCHEMA=CEMETERY;