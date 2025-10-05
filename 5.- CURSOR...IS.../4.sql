SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_show_emp_top_5 IS
    CURSOR C1 IS SELECT
                    ename "LASTNAME",
                    (sal + NVL(comm, 0)) "SAL"
                FROM
                    EMP
                ORDER BY
                    sal DESC
                FETCH FIRST 5 ROWS ONLY;
    CC1 C1%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Apellido', 10) || '|' || RPAD('Salario', 10));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') || '|' || RPAD('-', 10, '-'));
    OPEN C1;
        LOOP
            FETCH C1 INTO CC1;
            EXIT WHEN C1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(RPAD(CC1.LASTNAME, 10) || '|' || ' €' ||
                                RPAD(TO_CHAR(CC1.SAL,'FM9,999.90'), 10));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Empleados: '|| C1%ROWCOUNT);
    CLOSE C1;
END;
/

EXECUTE proc_show_emp_top_5;