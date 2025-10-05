SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_get_year(fecha DATE) IS
    v_year NUMBER;
BEGIN
    v_year := EXTRACT(YEAR FROM fecha);
    DBMS_OUTPUT.PUT_LINE('Año: ' || v_year);
END;
/

-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION func_get_year(fecha DATE) RETURN NUMBER IS
    v_year NUMBER;
BEGIN
    v_year := EXTRACT(YEAR FROM fecha);
    RETURN v_year;
END;
/

