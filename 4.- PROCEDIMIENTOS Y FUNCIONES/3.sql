SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_detalle_ptas(p_monto NUMBER) IS
    TYPE MONEDAS IS VARRAY(11) OF NUMBER;
    v_monedas MONEDAS := MONEDAS(5000, 2000, 1000, 500, 200, 100, 50, 25, 10, 2, 1);
    TYPE MONEDERO IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    v_monedero MONEDERO;
    v_index BINARY_INTEGER;
    v_cantidad NUMBER;
    v_monto NUMBER := p_monto;
BEGIN
    FOR I IN 1..v_monedas.COUNT LOOP
        v_cantidad := FLOOR(v_monto / v_monedas(I));
        IF v_cantidad >= 1
            THEN v_monedero(v_monedas(I)) := v_cantidad;
        END IF;
        v_monto := v_monto - (v_cantidad * v_monedas(I));
    END LOOP;
    v_index := v_monedero.LAST;
    WHILE v_index IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('Moneda: ' || v_index);
        DBMS_OUTPUT.PUT_LINE( ' - Cantidad: ' || v_monedero(v_index));
        v_index := v_monedero.PRIOR(v_index);
    END LOOP;
END;
/

EXEC PROC_DETALLE_PTAS(13238);