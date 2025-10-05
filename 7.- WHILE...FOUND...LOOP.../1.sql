SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_subir_sal(p_deptno NUMBER,
                                            p_importe NUMBER,
                                            p_porcentaje NUMBER) IS
    v_aumento_porcentual NUMBER;

BEGIN

    IF p_importe < 0
        THEN
            RAISE_APPLICATION_ERROR(-20001, 'importe no puede ser negativo');
    END IF;
    IF p_importe < 0 OR p_importe > 100
        THEN
            RAISE_APPLICATION_ERROR(-20002, 'porcentaje debe ser entre 1 y 100');
    END IF;

    UPDATE
        EMP
    SET
        SAL = SAL + GREATEST(p_importe, (SAL * (p_porcentaje/100)))
    WHERE
        DEPTNO = p_deptno;
    COMMIT;

EXCEPTION
    WHEN OTHERS
        THEN
            ROLLBACK;
END;
/

EXEC proc_subir_sal(50, 100, 9)

SELECT * FROM EMP;

UPDATE EMP SET SAL = 5000 WHERE EMPNO = 7944;