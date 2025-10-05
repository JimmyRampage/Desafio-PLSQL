SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_suma_varray IS
    TYPE V_arr IS VARRAY(5) OF NUMBER;
    numeros V_arr := V_arr(6, 3, 4, 1, 2);
    v_total NUMBER := 0;
BEGIN
    FOR I IN 1..numeros.COUNT LOOP
        v_total := v_total + numeros(I);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total: ' || v_total);
END;
/

EXEC PROC_SUMA_VARRAY; -- Total: 16