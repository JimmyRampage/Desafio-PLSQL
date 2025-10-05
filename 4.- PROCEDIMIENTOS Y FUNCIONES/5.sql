SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_modify_dept_loc(p_depno NUMBER, p_loc VARCHAR2) IS
BEGIN
    UPDATE dept
    SET loc = p_loc
    WHERE deptno = p_depno;
END;
/

INSERT INTO dept VALUES(50, 'pruebas', 'nada');

SELECT * FROM dept;

EXEC proc_modify_dept_loc(50, 'NY');