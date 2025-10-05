CREATE TABLE AUDITAREMP (
    COL1 VARCHAR2(200)
)

CREATE OR REPLACE TRIGGER trg_auditar_emp_control_modificacion
    BEFORE UPDATE ON emp
    FOR EACH ROW
DECLARE
    v_msg_error VARCHAR(150);
BEGIN
    IF UPDATING THEN
        v_msg_error := '';
        IF :OLD.EMPNO != :NEW.EMPNO THEN
            v_msg_error := v_msg_error || ' No puedes cambiar tu numero de empleado ';
        END IF;
        IF :OLD.ENAME != :NEW.ENAME THEN
            v_msg_error := v_msg_error || ' No puedes cambiar tu nombre ';
        END IF;
        IF (:OLD.SAL * 1.10) < :NEW.SAL THEN
            v_msg_error := v_msg_error || ' Salario no puede ser mayor a : ' || (:OLD.SAL * 1.10);
        END IF;
    END IF;
    IF v_msg_error IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error en la modificacion: ' || v_msg_error);
    END IF;
END;
/

SELECT * FROM EMP;
UPDATE emp SET sal = 5500 WHERE empno = 7944;
SELECT * FROM AUDITAREMP;
