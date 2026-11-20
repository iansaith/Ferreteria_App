DROP PROCEDURE IF EXISTS p_encriptar_password;
DELIMITER $$

CREATE PROCEDURE p_encriptar_password(
    IN p_password VARCHAR(255),
    OUT p_hash VARCHAR(255)
)
BEGIN
    DECLARE v_salt VARCHAR(64);
    SET v_salt = UUID();
    SET p_hash = CONCAT(v_salt, ':', SHA2(CONCAT(p_password, v_salt), 256));
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_registrar_usuario;
DELIMITER $$

CREATE PROCEDURE sp_registrar_usuario(
    IN p_nombre VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_rol INT
)
BEGIN
    DECLARE v_hash VARCHAR(255);

    CALL p_encriptar_password(p_password, v_hash);

    INSERT INTO Usuarios (Nombre, Roles_idRoles, Contrasena)
    VALUES (p_nombre, p_rol, v_hash);

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_login;
DELIMITER $$

CREATE PROCEDURE sp_login(
    IN p_id INT,
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE v_hash VARCHAR(255);
    DECLARE v_salt VARCHAR(64);
    DECLARE v_hash_guardado VARCHAR(128);
    DECLARE v_hash_calculado VARCHAR(128);

    SELECT Contrasena INTO v_hash
    FROM Usuarios
    WHERE idUsuarios = p_id;

    IF v_hash IS NULL THEN
        SELECT 'Usuario no existe' AS mensaje;
    ELSE
        SET v_salt = SUBSTRING_INDEX(v_hash, ':', 1);
        SET v_hash_guardado = SUBSTRING_INDEX(v_hash, ':', -1);
        SET v_hash_calculado = SHA2(CONCAT(p_password, v_salt), 256);

        IF v_hash_calculado = v_hash_guardado THEN
            SELECT 'Login correcto' AS mensaje;
        ELSE
            SELECT 'Contraseña incorrecta' AS mensaje;
        END IF;
    END IF;

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_registrar_movimiento;
DELIMITER $$

CREATE PROCEDURE sp_registrar_movimiento(
    IN p_fecha DATETIME,
    IN p_tipo VARCHAR(20),
    IN p_cantidad INT,
    IN p_usuario INT,
    IN p_producto INT
)
BEGIN
    INSERT INTO Movimiento_Inventario 
    (Fecha_Movimiento, Tipo_Movimiento, Cantidad_Movimiento, Usuarios_idUsuarios, Producto_idProducto)
    VALUES (p_fecha, p_tipo, p_cantidad, p_usuario, p_producto);
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_stock_producto;
DELIMITER $$

CREATE PROCEDURE sp_stock_producto(
    IN p_producto INT
)
BEGIN
    SELECT 
        p.Nombre_Producto,
        IFNULL(SUM(
            CASE 
                WHEN m.Tipo_Movimiento = 'Entrada' THEN m.Cantidad_Movimiento
                WHEN m.Tipo_Movimiento = 'Salida' THEN -m.Cantidad_Movimiento
            END
        ),0) AS Stock_Actual
    FROM Producto p
    LEFT JOIN Movimiento_Inventario m 
        ON p.idProducto = m.Producto_idProducto
    WHERE p.idProducto = p_producto
    GROUP BY p.Nombre_Producto;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_generar_alerta;
DELIMITER $$

CREATE PROCEDURE sp_generar_alerta(
    IN p_producto INT
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_minimo INT;

    SELECT IFNULL(SUM(
        CASE 
            WHEN Tipo_Movimiento = 'Entrada' THEN Cantidad_Movimiento
            WHEN Tipo_Movimiento = 'Salida' THEN -Cantidad_Movimiento
        END
    ),0)
    INTO v_stock
    FROM Movimiento_Inventario
    WHERE Producto_idProducto = p_producto;

    SELECT Stock_Minimo INTO v_minimo
    FROM Producto
    WHERE idProducto = p_producto;

    IF v_stock <= v_minimo THEN
        INSERT INTO Alerta_stock (Stock, Estado_alerta, Producto_idProducto)
        VALUES (v_stock, 'Bajo', p_producto);
    END IF;

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_productos_alerta;
DELIMITER $$

CREATE PROCEDURE sp_productos_alerta()
BEGIN
    SELECT p.Nombre_Producto, a.Stock, a.Estado_alerta
    FROM Alerta_stock a
    INNER JOIN Producto p 
        ON a.Producto_idProducto = p.idProducto;
END$$

DELIMITER ;