SET SERVEROUTPUT ON;

-- bloque anónimo
DECLARE
    v_nombre VARCHAR2(10) := 'James';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hola ' || v_nombre || ' bienvenido a PL/SQL');
END;
