SET SERVEROUTPUT ON;

DECLARE
    cumple_jimmy DATE := TO_DATE('05-09-1994', 'DD-MM-YYYY');
    cumple_mari DATE := TO_DATE('18-01-1992', 'DD-MM-YYYY');
    v_anio NUMBER;
BEGIN
    proc_get_year(cumple_jimmy);
    v_anio := func_get_year(cumple_mari);
    DBMS_OUTPUT.PUT_LINE('Año: ' || v_anio);
END;
/
