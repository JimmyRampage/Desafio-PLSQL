CREATE TABLE AUDITAREMP (
    COL1 VARCHAR2(200)
)

CREATE OR REPLACE TRIGGER trg_auditar_emp_modificaciones
    AFTER UPDATE ON emp
    FOR EACH ROW
DECLARE
    v_cambios VARCHAR(150);
BEGIN
    IF UPDATING THEN
        v_cambios := '';
        IF :OLD.EMPNO != :NEW.EMPNO THEN
            v_cambios := v_cambios || ' EMPNO: ' || :OLD.EMPNO || ' -> ' || :NEW.EMPNO;
        END IF;
        IF :OLD.ENAME != :NEW.ENAME THEN
            v_cambios := v_cambios || ' ENAME: ' || :OLD.ENAME || ' -> ' || :NEW.ENAME;
        END IF;
        IF :OLD.JOB != :NEW.JOB THEN
            v_cambios := v_cambios || ' JOB: ' || :OLD.JOB || ' -> ' || :NEW.JOB;
        END IF;
        IF :OLD.MGR != :NEW.MGR THEN
            v_cambios := v_cambios || ' MGR: ' || :OLD.MGR || ' -> ' || :NEW.MGR;
        END IF;
        IF :OLD.SAL != :NEW.SAL THEN
            v_cambios := v_cambios || ' SAL: ' || :OLD.SAL || ' -> ' || :NEW.SAL;
        END IF;
        IF :OLD.COMM != :NEW.COMM THEN
            v_cambios := v_cambios || ' COMM: ' || :OLD.COMM || ' -> ' || :NEW.COMM;
        END IF;
        IF :OLD.DEPTNO != :NEW.DEPTNO THEN
            v_cambios := v_cambios || ' DEPTNO: ' || :OLD.DEPTNO || ' -> ' || :NEW.DEPTNO;
        END IF;
        IF :OLD.HIREDATE != :NEW.HIREDATE THEN
            v_cambios := v_cambios || ' HIREDATE: ' || :OLD.HIREDATE || ' -> ' || :NEW.HIREDATE;
        END IF;
        INSERT INTO AUDITAREMP VALUES((
                    TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') ||
                    ' Empleado actualizado: N°' || :NEW.empno || ' ' || :NEW.ename) ||
                    ' Cambios:' || v_cambios);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error en el trigger: ' || SQLERRM);
END;
/

SELECT * FROM EMP;
UPDATE emp SET sal = 5000 WHERE empno = 7944;
SELECT * FROM AUDITAREMP;
