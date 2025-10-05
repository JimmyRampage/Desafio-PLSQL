CREATE TABLE AUDITAREMP (
    COL1 VARCHAR2(200)
)

CREATE OR REPLACE TRIGGER trg_auditar_emp
AFTER INSERT OR UPDATE OR DELETE ON emp
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AUDITAREMP VALUES((
                    TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') ||
                    ' Empleado nuevo: N°' || :NEW.empno || ' ' || :NEW.ename));
    ELSIF UPDATING THEN
        INSERT INTO AUDITAREMP VALUES((
                    TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') ||
                    ' Empleado actualizado: N°' || :NEW.empno || ' ' || :NEW.ename));
    ELSIF DELETING THEN
        INSERT INTO AUDITAREMP VALUES((
                    TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') ||
                    ' Empleado eliminado: N°' || :OLD.empno || ' ' || :OLD.ename));
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error en el trigger: ' || SQLERRM);
END;
/

SELECT * FROM EMP;

INSERT INTO emp VALUES (8001, 'Mario', 'Tobar', 7944, 3000, 500, 50, SYSDATE);

UPDATE emp SET sal = 3500, comm = 600 WHERE empno = 8001;

DELETE FROM emp WHERE empno = 8001;

SELECT * FROM AUDITAREMP;