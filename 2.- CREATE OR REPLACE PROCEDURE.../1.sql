SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_sumar(n1 NUMBER, n2 NUMBER) IS
    v_resultado NUMBER;
BEGIN
    v_resultado := n1 + n2;
    DBMS_OUTPUT.PUT_LINE('-> ' || n1 || '+' || n2 || '= ' || v_resultado);
END;
/

EXEC proc_sumar(1, 3);