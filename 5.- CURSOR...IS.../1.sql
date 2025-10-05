SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_show_emp IS
    CURSOR C1 IS SELECT ENAME, HIREDATE FROM EMP ORDER BY ENAME ASC;
    CC1 C1%ROWTYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('NOMBRE', 10) || '| ' ||
                            RPAD('F ALTA', 10) || '|');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') || '|' ||
                            RPAD('-', 11, '-') || '|');
    OPEN C1;
    LOOP
        FETCH C1 INTO CC1;
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(RPAD(CC1.ENAME, 10) || '| ' ||
                            RPAD(CC1.HIREDATE, 10) || '|');
    END LOOP;
    CLOSE C1;
END;
/

EXEC proc_show_emp;

SELECT * FROM emp;
