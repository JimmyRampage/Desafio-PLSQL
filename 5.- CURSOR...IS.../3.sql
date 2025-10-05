SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_show_emp_like(test VARCHAR2) IS
    CURSOR C1 IS SELECT empno, ename FROM EMP WHERE ENAME LIKE '%' || test || '%';
    CC1 C1%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Nombre', 10) || '|' || RPAD('N° Emp', 10));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') || '|' || RPAD('-', 10, '-'));
    OPEN C1;
        LOOP
            FETCH C1 INTO CC1;
            EXIT WHEN C1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(RPAD(CC1.ename, 10) || '|' || RPAD(CC1.empno, 10));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Empleados: '|| C1%ROWCOUNT);
    CLOSE C1;
END;
/

EXECUTE proc_show_emp_like('AM');