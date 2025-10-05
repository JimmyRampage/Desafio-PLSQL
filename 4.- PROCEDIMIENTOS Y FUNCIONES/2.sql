SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_only_abc(p_cadena VARCHAR2) IS
    v_relleno CHAR := ' ';
    c_regex_abc VARCHAR2(11) := '^[A-Za-z]+$';
    v_char VARCHAR2(2) := '';
    v_new_cadena VARCHAR(50) := '';
BEGIN
    FOR I IN 1..LENGTH(p_cadena) LOOP
        v_char := SUBSTR(p_cadena, I, 1);
        IF REGEXP_LIKE(v_char, c_regex_abc)
            THEN v_new_cadena := v_new_cadena || v_char;
        ELSE
            v_new_cadena := v_new_cadena || v_relleno;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_new_cadena);
END;
/

EXEC proc_only_abc('hola123?¡como¨*estas?');
