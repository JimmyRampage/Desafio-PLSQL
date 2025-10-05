SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION func_years_between(
                                p_fecha_uno DATE,
                                p_fecha_dos DATE) RETURN NUMBER IS
    v_months_betweeen NUMBER;
    v_years NUMBER;
BEGIN
    v_months_betweeen := MONTHS_BETWEEN(p_fecha_uno, p_fecha_dos);
    v_years := TRUNC(v_months_betweeen/12);
    RETURN ABS(v_years);
END;
/


DECLARE
    date_uno DATE := TO_DATE('05-09-1994', 'DD-MM-YY');
    date_dos DATE := TO_DATE('05-09-1992', 'DD-MM-YY');
    v_years NUMBER;
BEGIN
    v_years := func_years_between(date_uno, date_dos);
    DBMS_OUTPUT.PUT_LINE('Años de diferencia: ' || v_years);
END;
/