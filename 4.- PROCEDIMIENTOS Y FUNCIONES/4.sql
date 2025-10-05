SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_delete_emp_by_id(id NUMBER) IS
BEGIN
    DELETE FROM emp WHERE empno = id;
END;
/

INSERT INTO emp VALUES(6464, 'Jimmy', 'CLERK', 7902, 7200, 100, 10, sysdate);

SELECT * FROM EMP;

EXEC proc_delete_emp_by_id(6464);