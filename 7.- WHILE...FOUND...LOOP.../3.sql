SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_liquidaciones IS
    CURSOR C1 IS
                SELECT a.EMPNO, COUNT(b.EMPNO) CANTIDAD
                FROM EMP a
                LEFT JOIN EMP b
                ON a.EMPNO = b.MGR
                GROUP BY a.EMPNO;

    TYPE TABLA IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    t_responsabilidad TABLA;

    CURSOR C2 IS SELECT
                    a.deptno DEPTNO, a.dname DNAME,
                    b.empno ID, b.ename NAME, b.job JOB,
                    b.sal SAL, NVL(b.comm, 0) COMM, b.hiredate HIREDATE
                FROM
                    dept a
                INNER JOIN
                    emp b
                ON a.deptno = b.deptno
                ORDER BY DNAME ASC;
    CC2 C2%ROWTYPE;

    v_trienios NUMBER;
    v_comp_responsabilidad NUMBER;
    v_total NUMBER;
BEGIN
    FOR I IN C1 LOOP
        t_responsabilidad(I.EMPNO) := I.CANTIDAD;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(LPAD('*', 50, '*'));
    OPEN C2;
        LOOP
            FETCH C2 INTO CC2;
            EXIT WHEN C2%NOTFOUND;
            v_trienios := 50 * TRUNC(MONTHS_BETWEEN(CC2.HIREDATE, SYSDATE) / 36);
            v_comp_responsabilidad := 100 * (t_responsabilidad(CC2.ID));
            v_total := CC2.SAL + v_trienios + v_comp_responsabilidad + CC2.COMM;
            DBMS_OUTPUT.PUT_LINE('Liquidación del empleado: ' || LPAD(CC2.NAME, 24, '.'));
            DBMS_OUTPUT.PUT_LINE('Depto: (' || CC2.DEPTNO || ') ' || LPAD(CC2.DNAME, 12, '.') || -- o 13
                                ' Oficio: ' || LPAD(CC2.JOB, 17, '.'));
            DBMS_OUTPUT.PUT_LINE('Salario: €' || LPAD(TO_CHAR(CC2.SAL, 'FM9,999,990.90'), 40, '.'));
            DBMS_OUTPUT.PUT_LINE('Trienios: €' || LPAD(TO_CHAR(v_trienios, 'FM9,999,990.90'), 39, '.'));
            DBMS_OUTPUT.PUT_LINE('Comp. Responsabilidad: €' || LPAD(TO_CHAR(v_comp_responsabilidad, 'FM9,999,990.90'), 26, '.'));
            DBMS_OUTPUT.PUT_LINE('Comisión: €' || LPAD(TO_CHAR(CC2.COMM, 'FM9,999,990.90'), 39, '.'));
            DBMS_OUTPUT.PUT_LINE('Total: €' || LPAD(TO_CHAR(v_total, 'FM9,999,990.90'), 42, '.'));
            DBMS_OUTPUT.PUT_LINE(LPAD('*', 50, '*'));
        END LOOP;
    CLOSE C2;
END;
/

EXEC proc_liquidaciones;