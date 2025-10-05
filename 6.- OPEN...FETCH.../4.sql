SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_emp_nuevo(p_emp_name VARCHAR2 DEFAULT 'NONAME',
                                            p_emp_job VARCHAR2 DEFAULT 'NOJOB',
                                            p_emp_sal NUMBER DEFAULT NULL,
                                            p_emp_deptno NUMBER DEFAULT NULL) IS
    v_empno_max NUMBER;
BEGIN

    IF MOD(p_emp_deptno, 10) = 0 OR p_emp_deptno < 0
        THEN
            RAISE_APPLICATION_ERROR(-20001, 'numero de depto invalido - debe ser numero positivo multiplo de 10');
    END IF;

    SELECT MAX(empno) INTO v_empno_max FROM emp;
    INSERT INTO emp VALUES((10 + v_empno_max), -- empno
                            UPPER(p_emp_name), -- ename
                            UPPER(p_emp_job), -- job
                            null, -- mgr
                            p_emp_sal, -- sal
                            null, -- comm
                            p_emp_deptno, -- deptno
                            SYSDATE -- hiredate
                            );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;
/

EXEC proc_emp_nuevo('Jimmy', 'Dev', 5000, 30);
EXEC proc_emp_nuevo();

DELETE FROM emp WHERE EMPNO = 7954;

SELECT * FROM EMP ORDER BY EMPNO DESC;