SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_dos_por_job IS
    CURSOR C1(job_name VARCHAR2) IS SELECT ename, sal, job FROM emp
                    WHERE job = job_name
                    ORDER BY sal asc, ename asc
                    FETCH FIRST 2 ROWS ONLY;
    CC1 C1%ROWTYPE;

    TYPE Tabla IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
    t_jobs Tabla;
    v_index BINARY_INTEGER := 0;
BEGIN
    FOR I IN (SELECT DISTINCT job FROM emp ORDER BY job ASC) LOOP
        t_jobs(v_index) := I.JOB;
        v_index := v_index + 1;
    END LOOP;

    v_index := t_jobs.FIRST;
    WHILE v_index IS NOT NULL LOOP
        OPEN C1(t_jobs(v_index));
            LOOP
                FETCH C1 INTO CC1;
                EXIT WHEN C1%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE(RPAD(CC1.ENAME, 10) || '|' || '€' ||
                                    RPAD(TO_CHAR(CC1.sal, '9,999.90'), 10) || '|' ||
                                    RPAD(CC1.job, 10) || '|');
            END LOOP;
        CLOSE C1;
        v_index := t_jobs.NEXT(v_index);
    END LOOP;
END;
/

EXEC proc_dos_por_job;