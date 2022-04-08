
CREATE TABLE gps (
    id_ubicacion NUMBER(10),
    nombre VARCHAR2(50),
    pais VARCHAR2(50),
    estado VARCHAR2(50),
    direccion VARCHAR2(100),
    calificacion NUMBER(10,2), 
    descripcion VARCHAR2(200)
);

------------------------------------------------
------------------------------------------------
------------------------------------------------

----------> Cabecera del paquete <----------
CREATE OR REPLACE PACKAGE pqt_gps AS

CURSOR cursor_gps RETURN gps%ROWTYPE;

-- Insertar una ubicacion
PROCEDURE insertar_nueva_ubicacion (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_nombre        gps.nombre%TYPE,
    n_pais          gps.pais%TYPE,
    n_estado        gps.estado%TYPE,
    n_direccion     gps.direccion%TYPE,
    n_calificacion  gps.calificacion%TYPE,
    n_descripcion   gps.descripcion%TYPE );

-- Borrar una ubicacion
PROCEDURE borrar_ubicacion (n_id_ubicacion gps.id_ubicacion%TYPE);

-- Modificar Nombre 1
PROCEDURE modificar_nombre (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_nombre        gps.nombre%TYPE );
    
--- Modificar Pais 2
PROCEDURE modificar_pais (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_pais          gps.pais%TYPE );

-- Modificar Estado 3
PROCEDURE modificar_estado (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_estado        gps.estado%TYPE );
    
-- Modificar Direccion 4
PROCEDURE modificar_direccion (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_direccion     gps.direccion%TYPE );
    
-- Modificar Calificacion 5
PROCEDURE modificar_calificacion (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_calificacion  gps.calificacion%TYPE );
    
-- Ver una ubicacion por ID
PROCEDURE ver_ubicacion( n_id_ubicacion gps.id_ubicacion%TYPE );

-- Ver una ubicacion por nombre
PROCEDURE ver_ubicacion( n_nombre gps.nombre%TYPE );

-- Reiniciar calificaciones
PROCEDURE reinicia_calificaciones( n_calificacion  gps.calificacion%TYPE );

-- Aumentar el ID
PROCEDURE aumentar_ID( n_id_ubicacion gps.id_ubicacion%TYPE );

END pqt_gps;
----------> FIN Cabecera del paquete <----------

------------------------------------------------
------------------------------------------------
------------------------------------------------

----------> Cuerpo del paquete <----------

CREATE OR REPLACE PACKAGE BODY pqt_gps IS

CURSOR cursor_gps RETURN gps%ROWTYPE IS SELECT * FROM gps;

-- Insertar ubicacion
PROCEDURE insertar_nueva_ubicacion(
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_nombre        gps.nombre%TYPE,
    n_pais          gps.pais%TYPE,
    n_estado        gps.estado%TYPE,
    n_direccion     gps.direccion%TYPE,
    n_calificacion  gps.calificacion%TYPE,
    n_descripcion   gps.descripcion%TYPE ) IS

insert_reg EXCEPTION;

BEGIN DECLARE
    id_ubi gps.id_ubicacion%TYPE;
BEGIN

    SELECT id_ubicacion INTO id_ubi FROM gps
    WHERE id_ubicacion = n_id_ubicacion;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE insertar_nueva_ubicacion.insert_reg;
    END;

    DBMS_OUTPUT.PUT_LINE('ERROR: Ya hay una ubicacion con ese ID.');

    EXCEPTION
        WHEN insert_reg THEN
            INSERT INTO gps VALUES(
                n_id_ubicacion,
                n_nombre,
                n_pais,
                n_estado,
                n_direccion,
                n_calificacion,
                n_descripcion
            );
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('El registro se agrego correctamente.');
END insertar_nueva_ubicacion;

-- Borrar ubicacion
PROCEDURE borrar_ubicacion (n_id_ubicacion gps.id_ubicacion%TYPE) IS
BEGIN
    DELETE FROM gps WHERE id_ubicacion = n_id_ubicacion;
    COMMIT;
END borrar_ubicacion;

-- Modificar Nombre 1
PROCEDURE modificar_nombre (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_nombre        gps.nombre%TYPE ) IS
BEGIN
    UPDATE gps SET nombre = n_nombre
    WHERE id_ubicacion = n_id_ubicacion;
    COMMIT;
END modificar_nombre;

--- Modificar Pais 2
PROCEDURE modificar_pais (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_pais          gps.pais%TYPE ) IS
BEGIN
    UPDATE gps SET pais = n_pais
    WHERE id_ubicacion = n_id_ubicacion;
    COMMIT;
END modificar_pais;

-- Modificar Estado 3
PROCEDURE modificar_estado (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_estado        gps.estado%TYPE ) IS
BEGIN
    UPDATE gps SET estado = n_estado
    WHERE id_ubicacion = n_id_ubicacion;
    COMMIT;
END modificar_estado;

-- Modificar Direccion 4
PROCEDURE modificar_direccion (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_direccion     gps.direccion%TYPE ) IS
BEGIN
    UPDATE gps SET direccion = n_direccion
    WHERE id_ubicacion = n_id_ubicacion;
    COMMIT;
END modificar_direccion;

-- Modificar Calificacion 5
PROCEDURE modificar_calificacion (
    n_id_ubicacion  gps.id_ubicacion%TYPE,
    n_calificacion  gps.calificacion%TYPE ) IS
BEGIN
    UPDATE gps SET calificacion = n_calificacion
    WHERE id_ubicacion = n_id_ubicacion;
    COMMIT;
END modificar_calificacion;

-- Ver una ubicacion por ID
PROCEDURE ver_ubicacion( n_id_ubicacion gps.id_ubicacion%TYPE ) IS
ubicaciones gps%ROWTYPE;
BEGIN
    SELECT * INTO ubicaciones FROM gps WHERE id_ubicacion = n_id_ubicacion;
    DBMS_OUTPUT.PUT_LINE('La ubicacion con ID: ' || ubicaciones.id_ubicacion || ', es ' || ubicaciones.nombre);
    DBMS_OUTPUT.PUT_LINE('Su direccion es: ' || ubicaciones.pais || ', ' || ubicaciones.estado || ', ' || ubicaciones.direccion);
    DBMS_OUTPUT.PUT_LINE('Su calificacion es: '|| ubicaciones.calificacion);
    DBMS_OUTPUT.PUT_LINE('Descripcion: '|| ubicaciones.descripcion );
END ver_ubicacion;

-- Funcion para buscar el ID por nombre
FUNCTION buscar_ubicacion_nombre(n_nombre gps.nombre%TYPE) RETURN NUMBER;
-- Funcion para buscar el ID por nombre
FUNCTION buscar_ubicacion_nombre(n_nombre gps.nombre%TYPE) RETURN NUMBER IS
idUbi gps.id_ubicacion%TYPE;
BEGIN
    SELECT id_ubicacion INTO idUbi FROM gps WHERE nombre = n_nombre;
    RETURN idUbi;
END buscar_ubicacion_nombre;

-- Ver una ubicacion por nombre
PROCEDURE ver_ubicacion( n_nombre gps.nombre%TYPE ) IS
idUbi gps.id_ubicacion%TYPE;
ubicaciones gps%ROWTYPE;
BEGIN
    idUbi := buscar_ubicacion_nombre(n_nombre);
    
    SELECT * INTO ubicaciones FROM gps WHERE id_ubicacion = idUbi;
    
    DBMS_OUTPUT.PUT_LINE('La ubicacion con ID: ' || ubicaciones.id_ubicacion || ', es ' || ubicaciones.nombre);
    DBMS_OUTPUT.PUT_LINE('Su direccion es: ' || ubicaciones.pais || ', ' || ubicaciones.estado || ', ' || ubicaciones.direccion);
    DBMS_OUTPUT.PUT_LINE('Su calificacion es: '|| ubicaciones.calificacion);
    DBMS_OUTPUT.PUT_LINE('Descripcion: '|| ubicaciones.descripcion );
END ver_ubicacion;

-- Reiniciar calificaciones
PROCEDURE reinicia_calificaciones(n_calificacion  gps.calificacion%TYPE) IS
reinicio_error EXCEPTION;
BEGIN
    IF n_calificacion < 0 THEN
        RAISE reinicio_error;
    END IF;
    FOR ubicacion IN cursor_gps LOOP
        UPDATE gps SET calificacion = n_calificacion
        WHERE id_ubicacion = ubicacion.id_ubicacion;
    END LOOP;
    COMMIT;
    EXCEPTION
        WHEN reinicio_error THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No se puede reiniciar a calificacion negativa.');    
END reinicia_calificaciones;

-- Aumentar el ID
PROCEDURE aumentar_ID( n_id_ubicacion gps.id_ubicacion%TYPE ) IS
id_neg EXCEPTION;
BEGIN    
    IF n_id_ubicacion <= 0 THEN
        RAISE id_neg;
    END IF;
    FOR ubicacion IN cursor_gps LOOP
        UPDATE gps SET id_ubicacion = id_ubicacion + n_id_ubicacion
        WHERE id_ubicacion = ubicacion.id_ubicacion AND nombre = ubicacion.nombre
        AND estado = ubicacion.estado AND direccion = ubicacion.direccion;
    END LOOP;
    COMMIT;    
    EXCEPTION
        WHEN id_neg THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No se permiten aumentos negativos o de 0.');
END aumentar_ID;

END pqt_gps;

----------> FIN Cuerpo del paquete <----------

------------------------------------------------
------------------------------------------------
------------------------------------------------

----------> Usando el Paquete <----------
SET SERVEROUTPUT ON;

SELECT * FROM gps;

DELETE FROM gps;

COMMIT;

ROLLBACK;

BEGIN
--    pqt_gps.insertar_nueva_ubicacion(1, 'Taqueria Arandas', 'Mexico', 'CDMX', 'Av. Siempre Viva, No.12', 5, 'Muy buenos tacos');
--    pqt_gps.insertar_nueva_ubicacion(2, 'Mc Donalds', 'USA', 'New York', '1st Av, 34', 3, 'Only Hamburguers');
--    pqt_gps.insertar_nueva_ubicacion(3, 'Barbacoa: El borrego feliz', 'Mexico', 'EdoDeMex', 'Av Toreo, No.35', 4, 'Barbacoa regular, pero la mejor del rumbo');
--    pqt_gps.insertar_nueva_ubicacion(4, 'Jochos Lokos', 'Mexico', 'CDMX', 'Av. de los maestros, No.124', 5, 'Los mejores jochos');
--    pqt_gps.insertar_nueva_ubicacion(5, 'Quesidogos KonQso', 'Mexico', 'Monterrey', 'Calle loos leones, 44', 5, 'Los mejores quesidogos del rumbo');
    
--    pqt_gps.borrar_ubicacion(3);
--    pqt_gps.modificar_nombre(2, 'Tlayudas Oaxaca');
--    pqt_gps.modificar_pais(2, 'Mexico');
--    pqt_gps.modificar_estado(2, 'Oaxaca');
--    pqt_gps.modificar_direccion(2, 'Av. Martin Huerta No.18');    
--    pqt_gps.modificar_calificacion(2, 10);    
--    pqt_gps.ver_ubicacion('Jochos Lokos');
--    pqt_gps.ver_ubicacion(5);
    pqt_gps.reinicia_calificaciones(1);
--    pqt_gps.aumentar_ID(1);
END;


