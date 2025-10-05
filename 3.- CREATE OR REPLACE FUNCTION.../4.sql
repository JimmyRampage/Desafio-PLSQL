SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION func_get_trienios_between(
                                p_fecha_uno DATE,
                                p_fecha_dos DATE) RETURN NUMBER IS
    v_years NUMBER;
    v_trienios NUMBER;
BEGIN
    v_years := func_years_between(p_fecha_uno, p_fecha_dos);
    v_trienios := TRUNC(v_years / 3);
    RETURN v_trienios;
END;
/

DECLARE
    date_uno DATE := TO_DATE('05-09-1990', 'DD-MM-YYYY');
    date_dos DATE := SYSDATE;
    v_trienios NUMBER;
BEGIN
    v_trienios := func_get_trienios_between(date_uno, date_dos);
    DBMS_OUTPUT.PUT_LINE('Años de diferencia: ' || v_trienios);
END;
/

