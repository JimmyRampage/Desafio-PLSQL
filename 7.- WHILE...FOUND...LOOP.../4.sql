SET SERVEROUTPUT ON;

CREATE TABLE T_LIQUIDACION (
    APELLIDO VARCHAR2(20),
    DEPARTAMENTO INT,
    OFICIO VARCHAR2(20),
    SALARIO NUMBER,
    TRIENIOS NUMBER,
    COMP_RESPONSABILIDAD NUMBER,
    TOTAL NUMBER
);

CREATE OR REPLACE PROCEDURE proc_table_liquidaciones IS
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
    v_contador NUMBER := 0;
BEGIN
    FOR I IN C1 LOOP
        t_responsabilidad(I.EMPNO) := I.CANTIDAD;
    END LOOP;

    DELETE FROM T_LIQUIDACION;

    OPEN C2;
        LOOP
            FETCH C2 INTO CC2;
            EXIT WHEN C2%NOTFOUND;
            v_trienios := TRUNC(MONTHS_BETWEEN(CC2.HIREDATE, SYSDATE) / 36);
            v_comp_responsabilidad := 100 * NVL(t_responsabilidad(CC2.ID), 0);
            v_total := CC2.SAL + v_trienios + v_comp_responsabilidad + CC2.COMM;
            INSERT INTO
                T_LIQUIDACION
            VALUES(
                CC2.NAME,
                CC2.DEPTNO,
                CC2.JOB,
                CC2.SAL,
                v_trienios,
                v_comp_responsabilidad,
                v_total
            );
            v_contador := v_contador + 1;
        END LOOP;
    CLOSE C2;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Filas afectadas: ' || v_contador);
EXCEPTION
    WHEN OTHERS
        THEN ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error, no se han realizado cambios');
END;
/

EXEC proc_table_liquidaciones;

SELECT * FROM T_LIQUIDACION;