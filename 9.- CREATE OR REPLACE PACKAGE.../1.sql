SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE pkg_gest_depart IS

    PROCEDURE insertar_nuevo_depart(p_dname VARCHAR2, p_loc VARCHAR2);
    PROCEDURE borrar_depart(p_deptno_del NUMBER, p_deptno_add NUMBER);
    PROCEDURE modificar_loc_depart(p_deptno NUMBER, p_new_loc VARCHAR2);
    PROCEDURE visualizar_datos_depart(p_deptno NUMBER);
    PROCEDURE visualizar_datos_depart(p_dname VARCHAR2);
    FUNCTION buscar_depart_por_nombre(p_dname VARCHAR2) RETURN NUMBER;
    FUNCTION depart_exist(p_deptno NUMBER) RETURN BOOLEAN;

END pkg_gest_depart;

CREATE OR REPLACE PACKAGE BODY pkg_gest_depart IS
    ----------------------------------------------------------------------
    PROCEDURE insertar_nuevo_depart(p_dname VARCHAR2, p_loc VARCHAR2) IS
        v_max_deptno NUMBER;
        v_dname_exists NUMBER;
    BEGIN
        SELECT COUNT(dname) INTO v_dname_exists FROM dept WHERE dname = p_dname;

        IF v_dname_exists = 0 THEN
            SELECT MAX(deptno) INTO v_max_deptno FROM dept;
            INSERT INTO dept VALUES((v_max_deptno + 10), p_dname, p_loc);
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END insertar_nuevo_depart;
    ----------------------------------------------------------------------
    PROCEDURE borrar_depart(p_deptno_del NUMBER, p_deptno_add NUMBER) IS
        CURSOR C1(n_depto NUMBER) IS SELECT * FROM EMP WHERE DEPTNO = n_depto;
    BEGIN
        FOR I IN C1(p_deptno_del) LOOP
            UPDATE EMP
            SET DEPTNO = p_deptno_add
            WHERE EMPNO = I.EMPNO;
        END LOOP;
        DELETE FROM DEPT WHERE DEPTNO = p_deptno_del;
        COMMIT;
    EXCEPTION
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END borrar_depart;
    ----------------------------------------------------------------------
    PROCEDURE modificar_loc_depart(p_deptno NUMBER, p_new_loc VARCHAR2) IS
    BEGIN
        UPDATE DEPT
        SET LOC = p_new_loc
        WHERE DEPTNO = p_deptno;
        COMMIT;
    EXCEPTION
        WHEN OTHERS
            THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END modificar_loc_depart;
    ----------------------------------------------------------------------
    PROCEDURE visualizar_datos_depart(p_deptno NUMBER) IS
    BEGIN
        IF depart_exist(p_deptno)
            THEN
            FOR I IN (SELECT * FROM DEPT WHERE DEPTNO = p_deptno) LOOP
                DBMS_OUTPUT.PUT_LINE('Nombre: ' || I.DNAME);
                DBMS_OUTPUT.PUT_LINE('Número: ' || I.DEPTNO);
                DBMS_OUTPUT.PUT_LINE('Locación: ' || I.LOC);
            END LOOP;
            FOR I IN (SELECT * FROM EMP WHERE DEPTNO = p_deptno) LOOP
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
            RAISE_APPLICATION_ERROR(-20003, 'Departamento no existe');
        END IF;
    END visualizar_datos_depart;
    ----------------------------------------------------------------------
    PROCEDURE visualizar_datos_depart(p_dname VARCHAR2) IS
        v_deptno NUMBER;
    BEGIN
        v_deptno := buscar_depart_por_nombre(p_dname);
        visualizar_datos_depart(v_deptno);
    END visualizar_datos_depart;
    ----------------------------------------------------------------------
    FUNCTION buscar_depart_por_nombre(p_dname VARCHAR2) RETURN NUMBER IS
        v_deptno NUMBER;
    BEGIN
        SELECT MAX(DEPTNO)
        INTO v_deptno
        FROM DEPT
        WHERE DNAME = p_dname;
        RETURN v_deptno;
    END buscar_depart_por_nombre;
    ----------------------------------------------------------------------
    FUNCTION depart_exist(p_deptno NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(DNAME) INTO v_count FROM DEPT WHERE DEPTNO = p_deptno;
        IF v_count != 0
            THEN
                RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END;
    ----------------------------------------------------------------------
END pkg_gest_depart;
/

EXECUTE PKG_GEST_DEPART.VISUALIZAR_DATOS_DEPART('VENTAS');