# Desafío PL/SQL

## Introducción

Este documento es una desafío de aprendizaje en PL/SQL, el lenguaje procedural de Oracle para bases de datos. A través de una serie de ejercicios prácticos, he explorado y aplicado una amplia gama de conceptos, desde la sintaxis más básica hasta las características más avanzadas.

Cada sección de este `README.md` corresponde a un tema específico, presentando el problema, el código de la solución y notas explicativas sobre las técnicas y comandos utilizados. El objetivo no es solo resolver los ejercicios propuestos, sino también construir una guía de referencia personal que demuestre la aplicación práctica de la teoría.

Este repositorio documenta mi progreso y la consolidación de mis habilidades en la creación de procedimientos, funciones, triggers, paquetes y el uso de SQL dinámico, todo ello enfocado en construir soluciones de base de datos robustas, eficientes y mantenibles.

---

## 1.- DECLARE...BEGIN...END

### 1.- Hola

Escribir un bloque PL/SQL que escriba el texto ‘Hola’

```sql
SET SERVEROUTPUT ON;

-- bloque anónimo
DECLARE
    v_nombre VARCHAR2(10) := 'James';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hola ' || v_nombre || ', bienvenido a PL/SQL');
END;
/
```

> [!NOTE]
>
> El bloque anónimo se compone de tres partes `DECLARE`, `BEGIN` y `END`
>
> - DECLARE: para crear variables y definir tipos de datos antes de que comience la ejecución del bloque.
> - BEGIN: contiene las sentencias ejecutables, donde se realiza el procesamiento de datos, cálculos y llamadas a procedimientos o funciones.
> - END: marca el final del bloque PL/SQL y cierra su ejecución.

---

## 2.- CREATE OR REPLACE PROCEDURE

### 1.- Suma

Escribir un procedimiento que reciba dos números y visualice su suma

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_sumar(n1 NUMBER, n2 NUMBER) IS
    v_resultado NUMBER;
BEGIN
    v_resultado := n1 + n2;
    DBMS_OUTPUT.PUT_LINE('-> ' || n1 || '+' || n2 || '= ' || v_resultado);
END;
/

EXEC proc_sumar(1, 3);
/
```

> [!NOTE]
>
> El procedimiento almacenado se declara con `CREATE OR REPLACE PROCEDURE nombre_procedimiento`, este reemplaza el `DECLARE`.

---

### 2.- seveR

Codificar un procedimiento que reciba una cadena y la visualice al revés

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_voltear_cadena(cadena VARCHAR2) IS
    v_anedac VARCHAR2(20) := '';
BEGIN
    FOR I IN 1..LENGTH(cadena) LOOP
        v_anedac := SUBSTR(cadena, I, 1) || v_anedac;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_anedac);
END;
/

EXEC proc_voltear_cadena('jimmy');
```

> [!NOTE]
> `SUBSTR(string, start_position [, length ])`
>
> Permite obtener una sección de una cadena.
>
> - `string`: La cadena a recortar.
> - `start_position`: Posicion de inicio (incluido).
> - `length`: Opcional, selecciona cuantos caracteres.

---

### 3.- Get year

Escribir una función que reciba una fecha y devuelva el año, en número, correspondiente a esa fecha

```sql
CREATE OR REPLACE PROCEDURE proc_get_year(fecha DATE) IS
    v_year NUMBER;
BEGIN
    v_year := EXTRACT(YEAR FROM fecha);
    DBMS_OUTPUT.PUT_LINE('Año: ' || v_year);
END;
/

CREATE OR REPLACE FUNCTION func_get_year(fecha DATE) RETURN NUMBER IS
    v_year NUMBER;
BEGIN
    v_year := EXTRACT(YEAR FROM fecha);
    RETURN v_year;
END;
/
```

> [!NOTE]
>
> `EXTRACT(parte FROM date)`
>
> `EXTRACT` permite extraer partes de una fecha como `YEAR`, `MONTH`, `DAY`, `HOUR`, `MINUTE`, `SECOND`.
>
> `date` puede ser tipo `DATE`, `TIMESTAMP` o `INTERVAL`.

---

> [!NOTE]
>
> El bloque para crear una función es `CREATE OR REPLACE FUNCTION funcion_name(parameter p_type) RETURN r_type IS`. Aunque es similar al procedimiento almacenado, su diferencia principal radica en el `RETURN`, ya que una función siempre devuelve un valor.
>
> - `parameter`: Es un argumento de entrada que la función recibe para su procesamiento. Puede haber múltiples parámetros separados por comas.
> - `p_type`: Define el tipo de dato del parámetro, por ejemplo, NUMBER, VARCHAR2, DATE, etc.
> - `r_type`: Es el tipo de dato que la función retorna. Debe ser compatible con la lógica de la función.
> - `RETURN`: Indica el valor que la función devuelve. Este valor se asigna dentro de la lógica de la función utilizando la sentencia `RETURN valor`;

---

## 3.- CREATE OR REPLACE FUNCTION

### 1.- Usando Get year

Escribir un bloque PL/SQL que haga uso de la función anterior

```sql
SET SERVEROUTPUT ON;

DECLARE
    cumple_jimmy DATE := TO_DATE('05-09-1994', 'DD-MM-YYYY');
    cumple_mari DATE := TO_DATE('18-01-1992', 'DD-MM-YYYY');
    v_anio NUMBER;
BEGIN
    proc_get_year(cumple_jimmy);
    v_anio := func_get_year(cumple_mari);
    DBMS_OUTPUT.PUT_LINE('Año: ' || v_anio);
END;
/
```

---

### 2.- Analisis

Dado el Siguiente procedimiento

```sql
CREATE OR REPLACE PROCEDURE crear_depart (
    v_num_dept dept.deptno%TYPE,
    v_dnombre dept.dname%TYPE DEFAULT 'PROVISIONAL',
    v_loc dept.loc%TYPE DEFAULT 'PROVISIONAL')
IS
BEGIN
    INSERT INTO dept
    VALUES (v_num_dept, v_dnombre, v_loc);
END crear_depart;
```

> [!NOTE]
> Se ejecuta en bd_scott.

Indicar cuáles de las siguientes llamadas son correctas y cuáles incorrectas, en este último caso escribir la llamada correcta usando la notación posicional (en los casos que se pueda):

| Llamada | Resultado |
|-|-|
| `EXEC crear_depart;` | 'Incorrecto -> Se necesite parametro `v_num_dept`' |
| `EXEC crear_depart(50)` | 'Correcto -> Solo se crea con contenido provisional' |
| `EXEC crear_depart('COMPRAS');` | 'Incorrecto -> Parametro `v_num_dept` obligatorio' |
| `EXEC crear_depart(50,'COMPRAS');` | 'Correcto -> Se agrega con una locacion provisional' |
| `EXEC crear_depart('COMPRAS', 50);` | 'Incorrecto -> El primer parametro debe ser el numero de dpto' |
| `EXEC crear_depart('COMPRAS', 'VALENCIA');` | 'Incorrecto -> Parametro `v_num_dept` obligatorio' |
| `EXEC crear_depart(50, 'COMPRAS', 'VALENCIA');` | 'Correcto -> cumple con todo' |
| `EXEC crear_depart('COMPRAS', 50, 'VALENCIA');` | 'Incorrecto -> El primer parametro debe ser el numero de dpto' |
| `EXEC crear_depart('VALENCIA', ‘COMPRAS’);` | 'Incorrecto -> Parametro `v_num_dept` obligatorio' |
| `EXEC crear_depart('VALENCIA', 50);` | 'Incorrecto -> El primer parametro debe ser el numero de dpto' |

---

### 3.- Diff between years

Desarrollar una función que devuelva el número de años completos que hay entre dos fechas que se pasan como argumentos

```sql
CREATE OR REPLACE FUNCTION func_years_between(
                                p_fecha_uno DATE,
                                p_fecha_dos DATE) RETURN NUMBER IS
    v_months_betweeen NUMBER;
    v_years NUMBER;
BEGIN
    v_months_betweeen := MONTHS_BETWEEN(p_fecha_uno, p_fecha_dos);
    v_years := TRUNC(v_months_betweeen/12);
    RETURN ABS(v_years);
END;
/

DECLARE
    date_uno DATE := TO_DATE('05-09-1994', 'DD-MM-YY');
    date_dos DATE := TO_DATE('05-09-1992', 'DD-MM-YY');
    v_years NUMBER;
BEGIN
    v_years := func_years_between(date_uno, date_dos);
    DBMS_OUTPUT.PUT_LINE('Años de diferencia: ' || v_years);
END;
/
```

> [!NOTE]
>
> Calcula la diferencia entre dos fechas.
>
> `MONTHS_BETWEEN( date1, date2 )` Retorna la diferencia de dos fechas en meses.
>
> `date1` y `date2`: Corresponden a las fechas a consultar.

---

> `ABS(numero)`
>
> Retorna el valor absoluto de `numero`

---

### 4.- Get trienios

Escribir una función que, haciendo uso de la función anterior devuelva los trienios que hay entre dos fechas. (Un trienio son tres años completos)

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION func_get_trienios_between(
                                p_fecha_uno DATE,
                                p_fecha_dos DATE) RETURN NUMBER IS
    v_years NUMBER;
    v_trienios NUMBER;
BEGIN
    v_years := func_years_between(p_fecha_uno, p_fecha_dos);
    v_trienios := TRUNC(v_years / 3);
    RETURN v_trienios;
END;
/

DECLARE
    date_uno DATE := TO_DATE('05-09-1990', 'DD-MM-YYYY');
    date_dos DATE := SYSDATE;
    v_trienios NUMBER;
BEGIN
    v_trienios := func_get_trienios_between(date_uno, date_dos);
    DBMS_OUTPUT.PUT_LINE('Años de diferencia: ' || v_trienios);
END;
/
```

---

## 4.- PROCEDIMIENTOS Y FUNCIONES

### 1.- Sumar lista

Codificar un procedimiento que reciba una lista de hasta 5 números y visualice su suma

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_suma_varray IS
    TYPE V_arr IS VARRAY(5) OF NUMBER;
    numeros V_arr := V_arr(6, 3, 4, 1, 2);
    v_total NUMBER := 0;
BEGIN
    FOR I IN 1..numeros.COUNT LOOP
        v_total := v_total + numeros(I);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total: ' || v_total);
END;
/

EXEC PROC_SUMA_VARRAY; -- Total: 16
```

> [!NOTE]
> `VARRAY(5) OF NUMBER` define un array de tamaño fijo en PL/SQL, con un máximo de 5 elementos del tipo de dato `NUMBER`.
>
> - `VARRAY`: Es una colección indexada con un tamaño predefinido.
> - `(5)`: Indica que el arreglo puede contener hasta 5 elementos.
> - `OF NUMBER`: Especifica que los elementos almacenados serán del tipo de dato `NUMBER`.

---

### 2.- Filtrado de caracteres

Escribir una función que devuelva solamente caracteres alfabéticos sustituyendo cualquier otro tipo de carácter por blancos a partir de una cadena que se pasará en la llamada

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_only_abc(p_cadena VARCHAR2) IS
    v_relleno CHAR := ' ';
    c_regex_abc VARCHAR2(11) := '^[A-Za-z]+$';
    v_char VARCHAR2(2) := '';
    v_new_cadena VARCHAR(50) := '';
BEGIN
    FOR I IN 1..LENGTH(p_cadena) LOOP
        v_char := SUBSTR(p_cadena, I, 1);
        IF REGEXP_LIKE(v_char, c_regex_abc)
            THEN v_new_cadena := v_new_cadena || v_char;
        ELSE
            v_new_cadena := v_new_cadena || v_relleno;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_new_cadena);
END;
/

EXEC proc_only_abc('hola123?¡como¨*estas?');
```

> [!NOTE]
> `REGEXP_LIKE(cadena, expresion)`
>
> Retorna un booleano comparando la `cadena`, con la expresión `'^[A-Za-z]+$'` que busca caracteres del alfabeto inglés.
>
> [fuente](https://www.techonthenet.com/oracle/regexp_like.php)

---

### 3.- Pesetas

Implementar un procedimiento que reciba un importe y visualice el desglose del cambio en unidades monetarioas de 1, 5, 10, 25, 50, 100, 200, 500, 1000, 2000, 5000 Ptas. en orden inverso al que aparecen aquí enumeradas

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_detalle_ptas(p_monto NUMBER) IS
    TYPE MONEDAS IS VARRAY(11) OF NUMBER;
    v_monedas MONEDAS := MONEDAS(5000, 2000, 1000, 500, 200, 100, 50, 25, 10, 2, 1);
    TYPE MONEDERO IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    v_monedero MONEDERO;
    v_index BINARY_INTEGER;
    v_cantidad NUMBER;
    v_monto NUMBER := p_monto;
BEGIN
    FOR I IN 1..v_monedas.COUNT LOOP
        v_cantidad := FLOOR(v_monto / v_monedas(I));
        IF v_cantidad >= 1
            THEN v_monedero(v_monedas(I)) := v_cantidad;
        END IF;
        v_monto := v_monto - (v_cantidad * v_monedas(I));
    END LOOP;
    v_index := v_monedero.LAST;
    WHILE v_index IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('Moneda: ' || v_index);
        DBMS_OUTPUT.PUT_LINE( ' - Cantidad: ' || v_monedero(v_index));
        v_index := v_monedero.PRIOR(v_index);
    END LOOP;
END;
/

EXEC PROC_DETALLE_PTAS(13238);
```

> [!NOTE]
> `TYPE MONEDERO IS TABLE OF NUMBER INDEX BY BINARY_INTEGER`; define una tabla asociativa en PL/SQL, también conocida como un array indexado.
>
> - `TYPE MONEDERO`: Declara un tipo de colección llamada `MONEDERO`.
> - `TABLE OF NUMBER`: Especifica que almacenará valores del tipo de dato `NUMBER`.
> - `INDEX BY BINARY_INTEGER`: Indica que los elementos serán indexados utilizando números enteros (`BINARY_INTEGER`).

---

### 4.- Delete emp

Codificar un procedimiento que permita borrar un empleado cuyo número se pasará en la llamada

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_delete_emp_by_id(id NUMBER) IS
BEGIN
    DELETE FROM emp WHERE empno = id;
END;
/
```

---

### 5.- Modificar localidad de un dept

Escribir un procedimiento que modifique la localidad de un departamento. El procedimiento recibirá como parámetros el número del departamento y la localidad nueva

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_modify_dept_loc(p_depno NUMBER, p_loc VARCHAR2) IS
BEGIN
    UPDATE dept
    SET loc = p_loc
    WHERE deptno = p_depno;
END;
/
```

---

### 6.- Listar procedimientos y funciones

Visualizar todos los procedimientos y funciones del usuario almacenados en la base de datos y su situación (valid o invalid)

```sql
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS
FROM ALL_OBJECTS
WHERE OBJECT_TYPE IN ('FUNCTION','PROCEDURE')
AND OWNER = 'BD_SCOTT_JO'
ORDER BY OBJECT_TYPE;
```

> [!NOTE]
>
> Consultando sobre `ALL_OBJECTS` se puede filtrar para obtener la información solicitada
>
> [fuente](https://stackoverflow.com/questions/1819447/get-a-list-of-all-functions-and-procedures-in-an-oracle-database)

---

## 5.- CURSOR...IS...-

### 1.- Ver empleados y fecha de alta

Desarrollar un procedimiento que visualice el apellido y la fecha de alta de todos los empleados ordenados por apellido

```sql
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
```

> [!NOTE]
> `CURSOR C1 IS SELECT ENAME, HIREDATE FROM EMP ORDER BY ENAME ASC;` define un cursor explícito en PL/SQL para recorrer registros de una consulta ordenada.
>
> - `CURSOR C1`: Declara un cursor con el nombre `C1`.
> - `IS SELECT ENAME, HIREDATE FROM EMP`: Especifica la consulta que recupera los nombres (`ENAME`) y fechas de contratación (`HIREDATE`) de la tabla `EMP`.

---

### 2.- Ver nombre dept y total de empleados en el

Codificar un procedimiento que muestre el nombre de cada departameto y el número de empleados que tiene

```sql
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

```

---

### 3.- Buscar por apellido

Escribir un procedimiento que reciba una cadena y visualice el apellido y el número de empleado de todos los empleados cuyo apellido contenga la cadena especificada. Al finalizar visualizar el númerp de empleados mostrados

```sql
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE proc_show_emp_like(test VARCHAR2) IS
    CURSOR C1 IS SELECT empno, ename FROM EMP WHERE ENAME LIKE '%' || test || '%';
    CC1 C1%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Nombre', 10) || '|' || RPAD('N° Emp', 10));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') || '|' || RPAD('-', 10, '-'));
    OPEN C1;
        LOOP
            FETCH C1 INTO CC1;
            EXIT WHEN C1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(RPAD(CC1.ename, 10) || '|' || RPAD(CC1.empno, 10));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Empleados: '|| C1%ROWCOUNT);
    CLOSE C1;
END;
/

EXECUTE proc_show_emp_like('AM');
```

---

### 4.- Ver max 5 mejores sueldos

Escribir un programa que visualice el apellido y el salario de los cinco empleados que tienen el salario más alto

```sql
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
```

> [!NOTE]
>
> `FETCH FIRST n ROWS ONLY` limita el número `n` de resultados a mostrar
>
> [fuente](https://www.w3schools.com/sql/sql_top.asp)

---

## 6.- OPEN...FETCH...-

### 1.- Ver mejores dos de cada job

Codificar un programa que visualice los dos empleados que ganan menos de cada oficio

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_dos_por_job IS
    CURSOR C1(job_name VARCHAR2) IS SELECT ename, sal, job FROM emp
                    WHERE job = job_name
                    ORDER BY sal asc, ename asc
                    FETCH FIRST 2 ROWS ONLY;
    CC1 C1%ROWTYPE;

    TYPE Tabla IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
    t_jobs Tabla;
    v_index BINARY_INTEGER := 0;
BEGIN
    FOR I IN (SELECT DISTINCT job FROM emp ORDER BY job ASC) LOOP
        t_jobs(v_index) := I.JOB;
        v_index := v_index + 1;
    END LOOP;

    v_index := t_jobs.FIRST;
    WHILE v_index IS NOT NULL LOOP
        OPEN C1(t_jobs(v_index));
            LOOP
                FETCH C1 INTO CC1;
                EXIT WHEN C1%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE(RPAD(CC1.ENAME, 10) || '|' || '€' ||
                                    RPAD(TO_CHAR(CC1.sal, '9,999.90'), 10) || '|' ||
                                    RPAD(CC1.job, 10) || '|');
            END LOOP;
        CLOSE C1;
        v_index := t_jobs.NEXT(v_index);
    END LOOP;
END;
/

EXEC proc_dos_por_job;
```

- Se declara un cursor `C1` con parametro `job_name`.
- Se crea un `TYPE TABLE` para almacenar el nombre de los trabajos.
- Uso de `FOR I IN (SELECT...) LOOP` para rellenar la tabla de trabajo con indice asc y `job_name`.
- Recorremos la tabla y dentro de cada iteracion se abre el cursor con el parametro `job_name` obteniendo el resultado de la consulta.

---

### 2.- Ver deptos resumen y empleados detalle

Escribir un programa que muestre, en formato similar a las rupturas de control o secuencia vistas en SQL*plus los siguientes datos

- Para cada empleado: apellido y salario.
- Para cada departamento: Número de empleados y suma de los salarios del departamento.
- Al final del listado: Número total de empleados y suma de todos los salarios

```sql
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
```

- Cursor `C1` retorna el resumen de cada nombre de departamento.
- Cursor `C2(p_deptno_name)` retorna a los trabajadores de un departamento `p_deptno_name`.
- Se recorre `C1` obteniendo el nombre de cada depto y asignandolo a `C2(p_deptno_name)` dentro de `C1`.

---

### 3.- Add new dept

Desarrollar un procedimiento que permita insertar nuevos departamentos según las siguientes especificaciones

- Se pasará al procedimiento el nombre del departamento y la localidad.
- El procedimiento insertará la fila nueva asignando como número de departamento la decena siguiente al número mayor de la tabla.
- Se incluirá gestión de posibles errores.

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_depto_nuevo(p_dept_name VARCHAR2,
                                            p_dept_loc VARCHAR2) IS
    v_deptno_max NUMBER;
BEGIN
    SELECT MAX(deptno) INTO v_deptno_max FROM dept;
    INSERT INTO dept VALUES(
                            (10 + v_deptno_max),
                            p_dept_name,
                            p_dept_loc);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;
/

EXEC proc_depto_nuevo('DESARROLLO', 'CHILE');
```

---

### 4.- add emp

Escribir un procedimiento que reciba todos los datos de un nuevo empleado. precese la transaccion de alta, gestionando posibles errores

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_emp_nuevo(p_emp_name VARCHAR2 DEFAULT 'NONAME',
                                            p_emp_job VARCHAR2 DEFAULT 'NOJOB',
                                            p_emp_sal NUMBER DEFAULT NULL,
                                            p_emp_deptno NUMBER DEFAULT NULL) IS
    v_empno_max NUMBER;
BEGIN

    IF MOD(p_emp_deptno, 10) = 0 OR p_emp_deptno < 0
        THEN
            RAISE_APPLICATION_ERROR(-20001, 'numero de depto invalido - debe ser numero positivo multiplo de 10');
    END IF;

    SELECT MAX(empno) INTO v_empno_max FROM emp;
    INSERT INTO emp VALUES((10 + v_empno_max), -- empno
                            UPPER(p_emp_name), -- ename
                            UPPER(p_emp_job), -- job
                            null, -- mgr
                            p_emp_sal, -- sal
                            null, -- comm
                            p_emp_deptno, -- deptno
                            SYSDATE -- hiredate
                            );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;
/

EXEC proc_emp_nuevo('Jimmy', 'Dev', 5000, 30);
EXEC proc_emp_nuevo();
```

---

## 7.- WHILE...FOUND...LOOP...-

### 1.- Subir sueldo

Codificar un procedimiento que reciba como parámetros un número de departamento, un importe y un porcentaje; y suba el salario a todos los empreado del departamento indicado en la llamada (el que sea más beneficioso para el empleado en cada caso empleado).

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_subir_sal(p_deptno NUMBER,
                                            p_importe NUMBER,
                                            p_porcentaje NUMBER) IS
    v_aumento_porcentual NUMBER;

BEGIN

    IF p_importe < 0
        THEN
            RAISE_APPLICATION_ERROR(-20001, 'importe no puede ser negativo');
    END IF;
    IF p_importe < 0 OR p_importe > 100
        THEN
            RAISE_APPLICATION_ERROR(-20002, 'porcentaje debe ser entre 1 y 100');
    END IF;

    UPDATE
        EMP
    SET
        SAL = SAL + GREATEST(p_importe, (SAL * (p_porcentaje/100)))
    WHERE
        DEPTNO = p_deptno;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;
/

EXEC proc_subir_sal(50, 100, 9)
```

> [!NOTE]
>
> `GREATEST(exp1,...)` retorna el mayor de todas las expresiones
>
> [fuente](https://www.techonthenet.com/oracle/functions/greatest.php)

---

### 2.- Subir sueldo bajo media

Escribir un procedimiento que suba el sueldo de todos los empleados que ganen menos que el salaraio medio de su oficio. La subira derá del 50% de la diferencia entre el salario del empleado y la media de su oficio. Se deberá asegurar que la transacción no se quede a medias y se gestionarán posibles errores.

```sql
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE proc_subir_sal_media IS
BEGIN
    UPDATE
        EMP e
    SET
        SAL = SAL + (((SELECT ROUND(AVG(SAL), 2) FROM EMP WHERE JOB = e.JOB) - SAL) / 2)
    WHERE
        SAL < (SELECT
                    ROUND(AVG(SAL), 2)
                FROM
                    EMP
                WHERE
                    JOB = e.JOB);
    DBMS_OUTPUT.PUT_LINE('Empleados afectados: ' || SQL%ROWCOUNT);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Error: ' || SQLERRM);
END;
/

EXEC proc_subir_sal_media;
```

---

### 3.- Liquidacion

Diseñar una aplicación que simule un listado de liquidación de los empleados según las siguientes especificaciones:

```txt
*********************************************************************
Liquidación del empleado:...................(1)
Dpto:.................(2) Oficio:...........(3)
Salario : ............ (4)
Trienios ............. (5)
Comp. Responsabil .............. (6)
Comisión ............. (7)
Total ..............(8)
*********************************************************************
```

Donde:

- 1 ,2, 3 y 4 Corresponden al apellido, departamento, oficio y salario del empleado.
- 5 Es el importe en concepto de trienios. Cada trienio son tres años completos desde la fecha de alta hasta la de emisión y supone 50€.
- 6 Es el complemento por responsabilidad. Será de 100€ por cada empleado que se encuentre directamente a cargo del empleado en cuestión.
- 7 Es la comisión. Los valores nulos serán sustituidos por ceros.
- 8 Suma de todos los conceptos anteriores.

```sql
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
```

- Cursor `C1` lista a todos los trabajadores con sus resposables, esa información se almacena en `t_responsabilidad` como K:V empno:n_responsables.

---

### 4.- Crear Tabla Liquidaciones

Crear la tabla `T_liquidacion` con las columnas apellido, departamento, oficio, salario, trienios, comp_responsabilidad, comisión y total; y modificar la aplicación anterior para que en lugar de realizar el listado directamente en pantalla, guarde los datos en la tabla. Se controlarán todas las posibles incidencias que puedan ocurrir durante el proceso.

```sql
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
```

> [!NOTE]
>
> Se utiliza `DELETE` en lugar de `TRUNCATE` ya que DELETE soporta un `ROLLBACK` y `TRUNCATE` no.

---

## 8.- CREATE OR REPLACE TRIGGER

> [!IMPORTANT]
>
> No se pueden hacer commits o rollback en los Triggers.

---

### 1.- Trigger que audite

Construir un disparador de base de datos que permita auditar las operaciones de inserción o borrado de datos que se realicen en la tabla `emp` según las siguientes especificaciones:

- En primer lugar se creará desde SQL*Plus la tabla `auditaremp` con la columna `col1 VRACHAR2(200)`.
- Cuando se produzca cualquier manipulación se insertará una fila en dicha tabla que contendrá:
- Fecha y hora
- Número de empleado
- Apellido
- La operación de actualización INSERCIÓN o BORRADO

```sql
CREATE TABLE AUDITAREMP (
    COL1 VARCHAR2(200)
)

CREATE OR REPLACE TRIGGER trg_auditar_emp
AFTER INSERT OR UPDATE OR DELETE ON emp
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AUDITAREMP VALUES((
                    TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') ||
                    ' Empleado nuevo: N°' || :NEW.empno || ' ' || :NEW.ename));
    ELSIF DELETING THEN
        INSERT INTO AUDITAREMP VALUES((
                    TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') ||
                    ' Empleado eliminado: N°' || :OLD.empno || ' ' || :OLD.ename));
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error en el trigger: ' || SQLERRM);
END;
/
```

---

### 2.- Trigger autitar cambios

Escribir un trigger de base de datos un que permita auditar las modificaciones en la tabla empleados insertado en la tabla auditaremple los siguientes datos:

- Fecha y hora
- Número de empleado
- Apellido
- La operación de actualización: MODIFICACIÓN.
- El valor anterior y el valor nuevo de cada columna modificada. (solo las columnas modificadas).

```sql
CREATE OR REPLACE TRIGGER trg_auditar_emp_modificaciones
    AFTER UPDATE ON emp
    FOR EACH ROW
DECLARE
    v_cambios VARCHAR(150);
BEGIN
    IF UPDATING THEN
        v_cambios := '';
        IF :OLD.EMPNO != :NEW.EMPNO THEN
            v_cambios := v_cambios || ' EMPNO: ' || :OLD.EMPNO || ' -> ' || :NEW.EMPNO;
        END IF;
        IF :OLD.ENAME != :NEW.ENAME THEN
            v_cambios := v_cambios || ' ENAME: ' || :OLD.ENAME || ' -> ' || :NEW.ENAME;
        END IF;
        IF :OLD.JOB != :NEW.JOB THEN
            v_cambios := v_cambios || ' JOB: ' || :OLD.JOB || ' -> ' || :NEW.JOB;
        END IF;
        IF :OLD.MGR != :NEW.MGR THEN
            v_cambios := v_cambios || ' MGR: ' || :OLD.MGR || ' -> ' || :NEW.MGR;
        END IF;
        IF :OLD.SAL != :NEW.SAL THEN
            v_cambios := v_cambios || ' SAL: ' || :OLD.SAL || ' -> ' || :NEW.SAL;
        END IF;
        IF :OLD.COMM != :NEW.COMM THEN
            v_cambios := v_cambios || ' COMM: ' || :OLD.COMM || ' -> ' || :NEW.COMM;
        END IF;
        IF :OLD.DEPTNO != :NEW.DEPTNO THEN
            v_cambios := v_cambios || ' DEPTNO: ' || :OLD.DEPTNO || ' -> ' || :NEW.DEPTNO;
        END IF;
        IF :OLD.HIREDATE != :NEW.HIREDATE THEN
            v_cambios := v_cambios || ' HIREDATE: ' || :OLD.HIREDATE || ' -> ' || :NEW.HIREDATE;
        END IF;
        INSERT INTO AUDITAREMP VALUES((
                    TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') ||
                    ' Empleado actualizado: N°' || :NEW.empno || ' ' || :NEW.ename) ||
                    ' Cambios:' || v_cambios);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error en el trigger: ' || SQLERRM);
END;
/
```

---

### 3.- Trigger evitar abusos

Escribir un disparador de base de datos que haga fallar cualquier operación de
modificación del apellido o del número de un empleado, o que suponga una subida de
sueldo superior al 10%.

```sql
CREATE OR REPLACE TRIGGER trg_auditar_emp_control_modificacion
    BEFORE UPDATE ON emp
    FOR EACH ROW
DECLARE
    v_msg_error VARCHAR(150);
BEGIN
    IF UPDATING THEN
        v_msg_error := '';
        IF :OLD.EMPNO != :NEW.EMPNO THEN
            v_msg_error := v_msg_error || ' No puedes cambiar tu numero de empleado ';
        END IF;
        IF :OLD.ENAME != :NEW.ENAME THEN
            v_msg_error := v_msg_error || ' No puedes cambiar tu nombre ';
        END IF;
        IF (:OLD.SAL * 1.10) < :NEW.SAL THEN
            v_msg_error := v_msg_error || ' Salario no puede ser mayor a : ' || (:OLD.SAL * 1.10);
        END IF;
    END IF;
    IF v_msg_error IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error en la modificacion: ' || v_msg_error);
    END IF;
END;
/
```

---

### 4.- Trigger vistas

Suponiendo que disponemos de la vista:

```sql
CREATE VIEW DEPARTAM AS
SELECT DEPT.DEPTNO, DEPT.DNAME, DEPT.LOC, COUNT(EMP.EMPNO) TOT_EMP, NVL(ROUND(SUM(EMP.SAL), 2), 0) TOT_SAL
FROM EMP, DEPT
WHERE EMP.DEPTNO (+) = DEPT.DEPTNO
GROUP BY DEPT.DEPTNO, DEPT.DNAME, DEPT.LOC
ORDER BY TOT_EMP DESC;
```

Construir un disparador que permita realizar operaciones de actualización en la tabla depart a partir de la vista dptos, de forma similar al ejemplo del trigger `t_ges_emplead`. Se contemplarán las siguientes operaciones:

- Insertar departamento.
- Borrar departamento.
- Modificar la localidad de un departamento.

```sql
CREATE VIEW DEPARTAM AS
    SELECT DEPT.DEPTNO, DEPT.DNAME, DEPT.LOC, COUNT(EMP.EMPNO) TOT_EMP, NVL(ROUND(SUM(EMP.SAL), 2), 0) TOT_SAL
    FROM EMP, DEPT
    WHERE EMP.DEPTNO (+) = DEPT.DEPTNO
    GROUP BY DEPT.DEPTNO, DEPT.DNAME, DEPT.LOC
    ORDER BY TOT_EMP DESC;
/

CREATE OR REPLACE TRIGGER ges_depart
    INSTEAD OF DELETE OR INSERT OR UPDATE
    ON DEPARTAM
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO DEPT
        VALUES(:NEW.DEPTNO, :NEW.DNAME, :NEW.loc);
    ELSIF DELETING THEN
        DELETE FROM DEPT WHERE DEPTNO = :OLD.DEPTNO;
    ELSIF UPDATING('LOC') THEN
        UPDATE DEPT SET LOC = :NEW.LOC
        WHERE DEPTNO = :OLD.DEPTNO;
    ELSE
        RAISE_APPLICATION_ERROR (-20001,'Error en la actualización');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error en el trigger: ' || SQLERRM);
END;
/

SELECT * FROM DEPARTAM;
```

---

## 9.- CREATE OR REPLACE PACKAGE...-

### 1.- Paquete gest_depart

Escribir un paquete completo para gestionar los departamentos. El paquete sellamará `pkg_gest_depart` y deberá incluir, al menos los siguientes subprogramas.

- `insertar_nuevo_depart`: permite insertar un departamento nuevo. El procedimiento recibe el nombre y la localidad del nuevo departamento. Creará el nuevo departamento comprobando que el nombre no se duplique y le asignará como número de departamento la decena siguiente al último número de departamento utilizado.
- `borrar_depart`: permite borrar un departamento. El procedimiento recibirá dos números de departamento de los cuales el primero corresponde al departamento que queremos borrar y el segundo al departamento al que pasarán los empleados del departamento que se va eliminar. El procedimiento se encargará de realizar los cambios oportunos en los números de departamento de los empleados correspondientes.
- `modificar_loc_depart`: modifica la localidad del departamento. El procedimiento recibirá el número del departamento a modificar y la nueva localidad, y realizará el cambio solicitado.
- `visualizar_datos_depart`: visualizará los datos de un departamento cuyo número se pasará en la llamada. Además de los datos relativos al departamento, se visualizará el número de empleados que pertenecen actualmente al departamento.
- `visualizar_datos_depart`: versión sobrecargada del procedimiento anterior que, en lugar del número del departamento, recibirá el nombre del departamento. Realizará una llamada a la función buscar_depart_por_nombre que se indica en el apartado siguiente.
- `buscar_depart_por_nombre`: función local al paquete. Recibe el nombre de un departamento y devuelve el número del mismo.

```sql
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
```

---

### 2.- Paquete gest_emp

Escribir un paquete completo para gestionar los empleados. El paquete se llamará `pkg_gest_emple` e incluirá, al menos lo siguientes subprogramas:

- insertar_nuevo_emple
- borrar_emple. Cuando se borra un empleado todos los empleados que dependían de él pasarán a depender del director del empleado borrado.
- modificar_oficio_emple
- modificar_dept_emple
- modificar_dir_emple
- modificar_salario_emple
- modificar_comision_emple
- visualizar_datos_emple. También se incluirá una versión sobrecargada del procedimiento que recibirá el nombre del empleado.
- buscar_emple_por_nombre. Función local que recibe el nombre y devuelve el número.

Todos los procedimientos recibirán el número del empleado seguido de los demás datos necesarios. También se incluirán en el paquete cursores y declaraciones de tipo registro, así como siguientes procedimientos que afectarán a todos los empleados:

- subida_salario_pct: incrementará el salario de todos los empleados el porcentaje indicado en la llamada que no podrá ser superior al 25%.
- subida_salario_imp: sumará al salario de todos los empleados el importe indicado en la llamada. Antes de proceder a la incrementar los salarios se comprobará que el importe indicado no supera el 25% del salario medio.

```sql
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
```

---

## 10.- SQL DINÁMICO - Paquete DBMS_SQL

### 1.- Uno

Crear un procedimiento que permita consultar todos los datos de la tabla depart a
partir de una condición que se indicará en la llamada al procedimiento.

```sql
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
```

> [!Note] Explicación del ejercicio propuesto
>
> Si bien es cierto el desarrollo ya esta planteado. intentare explicarlo.
>
> `SQL dinamico`: El SQL dinámico crea y ejecuta consultas en tiempo de ejecución según datos variables. Ideal para consultas adaptables y flexibles.
>
> `DBMS_SQL`: El módulo DBMS_SQL proporciona un conjunto de procedimientos para ejecutar SQL dinámico en Oracle.
>
> - `OPEN_CURSOR` y `CLOSE_CURSOR`: Abre y cierre un cursor para utilizar una sentencia `SQL`. Es el primer paso al momento de preparar o ejecutar una consulta dinámica.
>
> - `PARSE`: Analiza la sentencia y la prepara para su ejecucion.
>
> - `NATIVE`: Es un modo de parseo que indica que la sentencia sera interpretada por el motor PLSQL directamente. Esto hace más eficiente la ejecucion dentro de bloques PLSQL
>
> - `BIND_VARIABLE`: Funciona como un placeholder de Java `?`
>
> - `DEFINE_COLUMN`: Permite definir que campos se quiere recuperar.
>
> - `EXECUTE`: Ejecuta la consulta previamente tratada.
>
> - `FETCH_ROWS` Recupera los registros del resultado una a una o en bloque.
>
> - `COLUMN_VALUE`: Extrae el valor de una columna especifica.

---

## Conclusión

A lo largo de este completo recorrido, he construido una base de conocimientos sólida y práctica en PL/SQL, abarcando desde los conceptos más fundamentales hasta técnicas avanzadas de programación en bases de datos Oracle.

Mi aprendizaje comenzó con la estructura esencial de los **bloques anónimos** (`DECLARE, BEGIN, END`), progresando rápidamente hacia la creación de código modular y reutilizable mediante **procedimientos** y **funciones**. A través de estos ejercicios, he logrado comprender cómo parametrizar estos subprogramas y gestionar sus diferencias, como el valor de retorno en las funciones.

He adquirido una habilidad crucial en el manejo de conjuntos de datos a través de **cursores explícitos** (`OPEN`, `FETCH`, `CLOSE`), lo que ahora me permite procesar resultados de consultas fila por fila, una técnica indispensable para la generación de informes complejos y la manipulación detallada de datos.

La robustez de mis soluciones se ha visto reforzada por una sólida **gestión de errores** y **control de transacciones** (`COMMIT`, `ROLLBACK`), asegurando la integridad de los datos incluso cuando surgen problemas inesperados.

Uno de los puntos más destacados de mi aprendizaje ha sido el trabajo con **triggers**, donde he implementado lógicas de auditoría (`AFTER INSERT, UPDATE, DELETE`), validación de reglas de negocio (`BEFORE UPDATE`) e incluso he logrado que vistas no actualizables se comporten como tablas reales mediante triggers `INSTEAD OF`. Esto demuestra una comprensión profunda de cómo automatizar y proteger los procesos de la base de datos.

Finalmente, he organizado la lógica de negocio de manera profesional utilizando **paquetes** (`PACKAGE` y `PACKAGE BODY`), encapsulando procedimientos, funciones y variables relacionadas para crear módulos cohesivos y fáciles de mantener, como `pkg_gest_depart` y `pkg_gest_emp`. Además, me he introducido en la flexibilidad del **SQL Dinámico** con `DBMS_SQL`, abriendo la puerta a la construcción de consultas en tiempo de ejecución.

En resumen, este conjunto de ejercicios no solo refleja mi aprendizaje de la sintaxis de PL/SQL, sino también la aplicación práctica de estos conceptos para construir aplicaciones de base de datos eficientes, seguras y bien estructuradas.
