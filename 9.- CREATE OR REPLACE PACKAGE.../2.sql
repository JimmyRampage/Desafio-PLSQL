SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE pkg_gest_emp IS

    PROCEDURE insertar_nuevo_emple(p_ename VARCHAR2,
                                    p_job VARCHAR2,
                                    p_n_jefe NUMBER,
                                    p_sal NUMBER,
                                    p_comm NUMBER,
                                    p_deptno NUMBER);
    PROCEDURE borrar_emple(p_empno NUMBER);
    PROCEDURE modificar_oficio_emple(p_empno NUMBER,
                                    p_new_job VARCHAR2);
    PROCEDURE modificar_dept_emple(p_empno NUMBER,
                                    p_new_deptno NUMBER);
    PROCEDURE modificar_dir_emple(p_empno NUMBER,
                                    p_new_n_jefe NUMBER);
    PROCEDURE modificar_salario_emple(p_empno NUMBER,
                                        p_new_sal NUMBER);
    PROCEDURE modificar_commision_emple(p_empno NUMBER,
                                        p_new_comm NUMBER);
    PROCEDURE visualizar_datos_emple(p_ename VARCHAR2);
    PROCEDURE subida_salario_pct(p_porcentaje NUMBER);
    PROCEDURE subida_salario_imp(p_importe NUMBER);
    ----------------------------------------------------------------------
    FUNCTION buscar_emple_por_nombre(p_ename VARCHAR2) RETURN NUMBER;
    FUNCTION emple_exists(p_empno NUMBER) RETURN BOOLEAN;
END pkg_gest_emp;
/
CREATE OR REPLACE PACKAGE BODY pkg_gest_emp IS
    e_porcentaje_fuera_de_limites EXCEPTION;
    e_importe_fuera_de_limites EXCEPTION;
    e_emple_no_exists EXCEPTION;
    ----------------------------------------------------------------------
    PROCEDURE insertar_nuevo_emple(p_ename VARCHAR2,
                                    p_job VARCHAR2,
                                    p_n_jefe NUMBER,
                                    p_sal NUMBER,
                                    p_comm NUMBER,
                                    p_deptno NUMBER) IS
    v_max_empno NUMBER;
    BEGIN
        SELECT MAX(empno) INTO v_max_empno FROM emp;
        INSERT INTO emp
        VALUES(
            (v_max_empno + 10),
            p_ename,
            p_job,
            p_n_jefe,
            p_sal,
            p_comm,
            p_deptno,
            SYSDATE
            );
        COMMIT;
    EXCEPTION
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END insertar_nuevo_emple;
    ----------------------------------------------------------------------
    PROCEDURE borrar_emple(p_empno NUMBER) IS
        v_empno_dir_superior NUMBER;
    BEGIN
        IF emple_exists(p_empno) THEN
            SELECT mgr INTO v_empno_dir_superior FROM emp WHERE empno = p_empno;
            --
            UPDATE emp
            SET mgr = v_empno_dir_superior
            WHERE mgr = p_empno;
            --
            DELETE FROM EMP
            WHERE empno = p_empno;
        ELSE
            RAISE e_emple_no_exists;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_emple_no_exists
            THEN
                DBMS_OUTPUT.PUT_LINE('Empleado no encontrado.');
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END borrar_emple;
    ----------------------------------------------------------------------
    PROCEDURE modificar_oficio_emple(p_empno NUMBER,
                                    p_new_job VARCHAR2) IS
    BEGIN
        IF emple_exists(p_empno) THEN
            UPDATE emp
            SET JOB = p_new_job
            WHERE empno = p_empno;
        ELSE
            RAISE e_emple_no_exists;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_emple_no_exists
            THEN
                DBMS_OUTPUT.PUT_LINE('Empleado no encontrado.');
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END modificar_oficio_emple;
    ----------------------------------------------------------------------
    PROCEDURE modificar_dept_emple(p_empno NUMBER,
                                    p_new_deptno NUMBER) IS
    BEGIN
        IF emple_exists(p_empno) THEN
            UPDATE emp
            SET deptno = p_new_deptno
            WHERE empno = p_empno;
        ELSE
            RAISE e_emple_no_exists;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_emple_no_exists
            THEN
                DBMS_OUTPUT.PUT_LINE('Empleado no encontrado.');
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END modificar_dept_emple;
    ----------------------------------------------------------------------
    PROCEDURE modificar_dir_emple(p_empno NUMBER,
                                    p_new_n_jefe NUMBER) IS
    BEGIN
        IF emple_exists(p_empno) THEN
            UPDATE emp
            SET mgr = p_new_n_jefe
            WHERE empno = p_empno;
        ELSE
            RAISE e_emple_no_exists;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_emple_no_exists
            THEN
                DBMS_OUTPUT.PUT_LINE('Empleado no encontrado.');
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END modificar_dir_emple;
    ----------------------------------------------------------------------
    PROCEDURE modificar_salario_emple(p_empno NUMBER,
                                        p_new_sal NUMBER) IS
    BEGIN
        IF emple_exists(p_empno) THEN
            UPDATE emp
            SET sal = p_new_sal
            WHERE empno = p_empno;
        ELSE
            RAISE e_emple_no_exists;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_emple_no_exists
            THEN
                DBMS_OUTPUT.PUT_LINE('Empleado no encontrado.');
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END modificar_salario_emple;
    ----------------------------------------------------------------------
    PROCEDURE modificar_commision_emple(p_empno NUMBER,
                                        p_new_comm NUMBER) IS
    BEGIN
        IF emple_exists(p_empno) THEN
            UPDATE emp
            SET comm = p_new_comm
            WHERE empno = p_empno;
        ELSE
            RAISE e_emple_no_exists;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_emple_no_exists
            THEN
                DBMS_OUTPUT.PUT_LINE('Empleado no encontrado.');
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END modificar_commision_emple;
    ----------------------------------------------------------------------
    PROCEDURE visualizar_datos_emple(p_ename VARCHAR2) IS
        v_empno NUMBER;
    BEGIN
        v_empno := buscar_emple_por_nombre(p_ename);
        IF v_empno IS NOT NULL THEN
            FOR I IN (SELECT * FROM emp WHERE empno = v_empno) LOOP
                DBMS_OUTPUT.PUT_LINE('ID: ' || LPAD(I.EMPNO, 4) ||
                                        ' ENAME: ' || RPAD(I.ENAME, 10) ||
                                        ' JOB: ' || RPAD(I.JOB, 10) ||
                                        ' MGR: ' || LPAD(I.MGR, 4) ||
                                        ' SAL: ' || LPAD(TO_CHAR(I.SAL, 'FM9,990.90'), 7) ||
                                        ' COMM: ' || LPAD(TO_CHAR(NVL(I.COMM, 0), 'FM9,990.90'), 7) ||
                                        ' DEPTNO: ' || RPAD(I.DEPTNO, 2) ||
                                        ' HIREDATE: ' || TO_CHAR(I.HIREDATE, 'DD-MM-YYYY')
                                        );
            END LOOP;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Empleado no encontrado');
        END IF;
    END visualizar_datos_emple;
    ----------------------------------------------------------------------
    FUNCTION buscar_emple_por_nombre(p_ename VARCHAR2) RETURN NUMBER IS
        v_empno NUMBER;
    BEGIN
        SELECT MAX(empno)
        INTO v_empno
        FROM emp
        WHERE ename = p_ename;
        RETURN v_empno;
    EXCEPTION
        WHEN OTHERS
            THEN
                RETURN NULL;
    END buscar_emple_por_nombre;
    ----------------------------------------------------------------------
    PROCEDURE subida_salario_pct(p_porcentaje NUMBER) IS
    BEGIN
        IF p_porcentaje <= 25 AND p_porcentaje > 0
            THEN
                UPDATE emp
                SET SAL = SAL + (SAL * (p_porcentaje/100));
        ELSE
            RAISE e_porcentaje_fuera_de_limites;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_porcentaje_fuera_de_limites
            THEN
                DBMS_OUTPUT.PUT_LINE('Porcendaje fuera de limites. Rango de 1 a 25');
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END subida_salario_pct;
    ----------------------------------------------------------------------
    PROCEDURE subida_salario_imp(p_importe NUMBER) IS
        v_salario_media NUMBER;
    BEGIN
        SELECT AVG(SAL) INTO v_salario_media FROM EMP;
        IF p_importe <=(v_salario_media/4)
            THEN
                UPDATE emp
                SET SAL = SAL + p_importe;
        ELSE
            RAISE e_importe_fuera_de_limites;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN e_importe_fuera_de_limites
            THEN
                DBMS_OUTPUT.PUT_LINE('Porcendaje fuera de limites. No debe ser superior al 25% de la media');
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END subida_salario_imp;
    ----------------------------------------------------------------------
    FUNCTION emple_exists(p_empno NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(ename)
        INTO v_count
        FROM emp
        WHERE empno = p_empno;
        IF v_count != 0
            THEN
                RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END emple_exists;
    ----------------------------------------------------------------------
END pkg_gest_emp;