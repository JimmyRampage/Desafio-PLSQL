SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE consultar_dept(condicion VARCHAR2,
                            valor VARCHAR2) AS
    id_cursor INTEGER;
    v_comando VARCHAR2(2000);
    v_dummy NUMBER;
    v_deptno dept.deptno%TYPE;
    v_dnname dept.dnombre%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    id_cursor := DBMS_SQL.OPEN_CURSOR;
    v_comando := 'SELECT deptno, dname, loc FROM dept WHERE ' || condicion || ':val_1';

    DBMS_OUTPUT.PUT_LINE(v_comando);
    DBMS_SQL.PARSE(id_cursor, v_comando, DBMS_SQL.NATIVE);
    DBMS_SQL.BIND_VARIABLE(id_cursor, ':val_1', valor);
    /* A continuación se especifican las variables que recibirán los valores de la selección*/
    DBMS_SQL.DEFINE_COLUMN(id_cursor, 1, v_deptno);
    DBMS_SQL.DEFINE_COLUMN(id_cursor, 2, v_dnname,14);
    DBMS_SQL.DEFINE_COLUMN(id_cursor, 3, v_loc, 14);
    v_dummy := DBMS_SQL.EXECUTE(id_cursor);
    /* La función FETCH_ROWS recupera filas y retorna el número de filas que quedan */
    WHILE DBMS_SQL.FETCH_ROWS(id_cursor) > 0 LOOP
        /* A continuación se depositarán los valores recuperados en las variables PL/SQL */
        DBMS_SQL.COLUMN_VALUE(id_cursor, 1, v_deptno);
        DBMS_SQL.COLUMN_VALUE(id_cursor, 2, v_dnname);
        DBMS_SQL.COLUMN_VALUE(id_cursor, 3, v_loc);
        DBMS_OUTPUT.PUT_LINE(v_deptno || '*' || v_dnname || '*' || v_loc);
    END LOOP;
    DBMS_SQL.CLOSE_CURSOR(id_cursor);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_SQL.CLOSE_CURSOR(id_cursor);
        RAISE;
END consultar_dept;