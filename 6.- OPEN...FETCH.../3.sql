SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_depto_nuevo(p_dept_name VARCHAR2,
                                            p_dept_loc VARCHAR2) IS
    v_deptno_max NUMBER;
BEGIN
    SELECT MAX(deptno) INTO v_deptno_max FROM dept;
    INSERT INTO dept VALUES(
                            (10 + v_deptno_max),
                            p_dept_name,
                            p_dept_loc);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;
/

EXEC proc_depto_nuevo('DESARROLLO', 'CHILE');

SELECT * FROM dept;

DELETE FROM dept WHERE deptno = 50;