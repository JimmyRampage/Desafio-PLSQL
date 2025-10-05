CREATE OR REPLACE PROCEDURE crear_depart (
    v_num_dept dept.deptno%TYPE,
    v_dnombre dept.dname%TYPE DEFAULT 'PROVISIONAL',
    v_loc dept.loc%TYPE DEFAULT 'PROVISIONAL')
IS
BEGIN
    INSERT INTO dept
    VALUES (v_num_dept, v_dnombre, v_loc);
END crear_depart;

SELECT * FROM DEPT;

DELETE FROM dept WHERE deptno = 50;

-- EXEC crear_depart;
-- EXEC crear_depart(50);
-- EXEC crear_depart('COMPRAS');
-- EXEC crear_depart(50,'COMPRAS');
-- EXEC crear_depart('COMPRAS', 50);
-- EXEC crear_depart('COMPRAS', 'VALENCIA');
-- EXEC crear_depart(50, 'COMPRAS', 'VALENCIA');
-- EXEC crear_depart('COMPRAS', 50, 'VALENCIA');
-- EXEC crear_depart('VALENCIA', ‘COMPRAS’);
-- EXEC crear_depart('VALENCIA', 50);