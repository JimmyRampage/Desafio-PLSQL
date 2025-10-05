SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_subir_sal_media IS
BEGIN
    UPDATE
        EMP e
    SET
        SAL = SAL + (((SELECT ROUND(AVG(SAL), 2) FROM EMP WHERE JOB = e.JOB) - SAL) / 2)
    WHERE
        SAL < (SELECT
                    ROUND(AVG(SAL), 2)
                FROM
                    EMP
                WHERE
                    JOB = e.JOB);
    DBMS_OUTPUT.PUT_LINE('Empleados afectados: ' || SQL%ROWCOUNT);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Error: ' || SQLERRM);
END;
/

EXEC proc_subir_sal_media;

SELECT JOB, ROUND(AVG(SAL), 2)MID_SAL FROM EMP GROUP BY JOB;

SELECT EMPNO, JOB, SAL FROM EMP WHERE JOB = p_job;

SELECT * FROM EMP e WHERE SAL < (SELECT ROUND(AVG(SAL), 2) FROM EMP WHERE JOB = e.JOB);
SELECT * FROM EMP WHERE JOB = 'CLERK';