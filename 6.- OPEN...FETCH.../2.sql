SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_show_detalle IS
    CURSOR C1 IS SELECT DNAME, COUNT(ENAME) EMPS, SUM(SAL) SAL
                    FROM (SELECT a.*, b.*
                            FROM dept a
                            INNER JOIN emp b
                            ON a.deptno = b.deptno)
                    GROUP BY DNAME;
    C_DEPT_RES C1%ROWTYPE;
    v_dname dept.DNAME%TYPE;

    CURSOR C2(p_depto_name VARCHAR2) IS SELECT deptno, ename, sal + NVL(comm, 0) salario
                                FROM emp
                                WHERE deptno IN (SELECT deptno
                                                FROM dept
                                                WHERE dname = p_depto_name);
    C_EMP_DET C2%ROWTYPE;
BEGIN
    OPEN C1;
        LOOP
            FETCH C1 INTO C_DEPT_RES;
            EXIT WHEN C1%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE('Nombre: ' || C_DEPT_RES.DNAME);
            DBMS_OUTPUT.PUT_LINE('Total de empleados: ' || C_DEPT_RES.EMPS);
            DBMS_OUTPUT.PUT_LINE('Total de salarios: ' || C_DEPT_RES.SAL);
            v_dname := C_DEPT_RES.DNAME;
            OPEN C2(v_dname);
                DBMS_OUTPUT.PUT_LINE(RPAD('-', 38, '-'));
                LOOP
                    FETCH C2 INTO C_EMP_DET;
                    EXIT WHEN C2%NOTFOUND;
                    DBMS_OUTPUT.PUT_LINE('| ' || RPAD(v_dname, 12) || '| ' ||
                                        RPAD(C_EMP_DET.ename, 8) || '| €' ||
                                        LPAD(TO_CHAR(C_EMP_DET.salario, 'FM9,999.90'), 10) || '|');
                END LOOP;
                DBMS_OUTPUT.PUT_LINE(RPAD('-', 38, '-'));
            CLOSE C2;
        END LOOP;
    CLOSE C1;
END;
/
EXEC proc_show_detalle;