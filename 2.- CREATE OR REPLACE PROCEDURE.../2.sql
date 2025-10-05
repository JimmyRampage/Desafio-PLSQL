SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_voltear_cadena(cadena VARCHAR2) IS
    v_anedac VARCHAR2(20) := '';
BEGIN
    FOR I IN 1..LENGTH(cadena) LOOP
        v_anedac := SUBSTR(cadena, I, 1) || v_anedac;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_anedac);
END;
/

EXEC proc_voltear_cadena('jimmy');