SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_show_dpt_q IS
    CURSOR C1 IS SELECT a.deptno "A", MIN(a.loc) "B", COUNT(a.loc) "C"
                    FROM DEPT a LEFT JOIN EMP b
                    ON a.deptno = b.deptno
                    GROUP BY a.deptno;
    CC1 C1%ROWTYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('N° Depto', 15) || '| ' ||
                        RPAD('Locación', 15) || '| ' ||
                        RPAD('N° Empleados', 15) || '|');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 15, '-') || '|' ||
                        RPAD('-', 16, '-') || '|' ||
                        RPAD('-', 16, '-') || '|');
    OPEN C1;
    LOOP
        FETCH C1 INTO CC1;
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(RPAD(CC1.A, 15) || '| ' ||
                            RPAD(CC1.B, 15) || '| ' ||
                            RPAD(CC1.C, 15) || '|');
    END LOOP;
    CLOSE C1;
END;
/

EXEC PROC_SHOW_DPT_Q;
