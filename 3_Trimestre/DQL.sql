
-- Obtiene todos los registros y columnas de la tabla Producto
SELECT * FROM Producto;

-- Obtiene todos los registros y columnas de la tabla Usuarios
SELECT * FROM Usuarios;

-- Lista únicamente el nombre y el stock mínimo definido para cada producto
SELECT Nombre_Producto, Stock_Minimo 
FROM Producto;


-- Consulta las alertas de stock cuyo estado actual es 'Bajo'
SELECT * FROM Alerta_stock 
WHERE Estado_alerta = 'Bajo';

-- Recupera el listado de nombres de todos los proveedores registrados
SELECT Nombre_Proveedor 
FROM Proveedor;


-- Subconsultas Selecciona productos cuyo stock mínimo es superior al promedio de stock mínimo global
SELECT Nombre_Producto 
FROM Producto 
WHERE Stock_Minimo > (SELECT AVG(Stock_Minimo) FROM Producto);

-- Subconsultas Lista los nombres de usuarios que han realizado al menos un movimiento de inventario
SELECT Nombre 
FROM Usuarios 
WHERE idUsuarios IN (
    SELECT DISTINCT Usuarios_idUsuarios 
    FROM Movimiento_Inventario
);

-- Subconsultas Identifica los nombres de productos que tienen registros en la tabla de alertas
SELECT Nombre_Producto 
FROM Producto 
WHERE idProducto IN (
    SELECT Producto_idProducto 
    FROM Alerta_stock
);

-- Subconsultas Obtiene productos pertenecientes específicamente a la categoría 'Pinturas'
SELECT Nombre_Producto 
FROM Producto 
WHERE Categoria_idCategoria = (
    SELECT idCategoria 
    FROM Categoria 
    WHERE Nombre_Categoria = 'Pinturas'
);

-- Subconsultas Lista proveedores que tienen al menos un producto asociado en el inventario
SELECT Nombre_Proveedor 
FROM Proveedor 
WHERE idProveedor IN (
    SELECT Proveedor_idProveedor 
    FROM Producto
);

-- Subconsultas Busca usuarios filtrando por el nombre del rol 'Encargado del Inventario' en lugar de usar el ID directamente
SELECT Nombre 
FROM Usuarios 
WHERE Roles_idRoles = (
    SELECT idRoles 
    FROM Roles 
    WHERE Nombre_Rol = 'Encargado del Inventario'
);


-- Subconsultas Cruza productos con sus respectivas categorías para mostrar el nombre de ambas
SELECT p.Nombre_Producto, c.Nombre_Categoria
FROM Producto p
INNER JOIN Categoria c 
    ON p.Categoria_idCategoria = c.idCategoria;

-- Reporte de Reabastecimiento: Productos en estado crítico y su contacto de proveedor
SELECT 
    p.Nombre_Producto, 
    a.Estado_alerta, 
    pr.Nombre_Proveedor, 
    pr.idProveedor -- Podrías agregar teléfono/email si existen en la tabla
FROM Alerta_stock a
JOIN Producto p ON a.Producto_idProducto = p.idProducto
JOIN Proveedor pr ON p.Proveedor_idProveedor = pr.idProveedor
WHERE a.Estado_alerta = 'Bajo';



-- Joins Últimos movimientos realizados, mostrando producto y quién lo hizo
SELECT 
    m.idMovimiento_Inventario,
    m.Tipo_Movimiento,
    m.Cantidad_Movimiento,
    p.Nombre_Producto,
    u.Nombre AS Usuario_Responsable
FROM Movimiento_Inventario m
JOIN Producto p ON m.Producto_idProducto = p.idProducto
JOIN Usuarios u ON m.Usuarios_idUsuarios = u.idUsuarios
ORDER BY m.idMovimiento_Inventario DESC
LIMIT 4;


-- [INNER JOIN] Vincula productos con sus proveedores para visualizar quién suministra qué
SELECT p.Nombre_Producto, pr.Nombre_Proveedor
FROM Producto p
INNER JOIN Proveedor pr 
    ON p.Proveedor_idProveedor = pr.idProveedor;

-- [INNER JOIN] Muestra los nombres de usuario junto con el nombre descriptivo de su Rol
SELECT u.Nombre, r.Nombre_Rol
FROM Usuarios u
INNER JOIN Roles r 
    ON u.Roles_idRoles = r.idRoles;

-- [INNER-JOIN] Reporte detallado de movimientos incluye tipo, cantidad, producto y nombre del usuario responsable
SELECT 
    m.Tipo_Movimiento, 
    m.Cantidad_Movimiento, 
    p.Nombre_Producto, 
    u.Nombre AS Responsable
FROM Movimiento_Inventario m
INNER JOIN Producto p 
    ON m.Producto_idProducto = p.idProducto
INNER JOIN Usuarios u 
    ON m.Usuarios_idUsuarios = u.idUsuarios;

-- [INNER-JOIN] Vista completa de productos con su categoría y proveedor asociado
SELECT p.Nombre_Producto, c.Nombre_Categoria, pr.Nombre_Proveedor
FROM Producto p
INNER JOIN Categoria c 
    ON p.Categoria_idCategoria = c.idCategoria
INNER JOIN Proveedor pr 
    ON p.Proveedor_idProveedor = pr.idProveedor;

-- [LEFT JOIN] Lista todos los productos y su alerta; si no tienen alerta, muestra 'Sin Alerta' usando COALESCE
SELECT 
    p.Nombre_Producto, 
    COALESCE(a.Estado_alerta, 'Sin Alerta') AS Estado
FROM Producto p
LEFT JOIN Alerta_stock a 
    ON p.idProducto = a.Producto_idProducto;

-- Consulta de seguridad lista ID, Nombre y Contraseña de la tabla Usuarios
SELECT idUsuarios, Nombre, Contrasena 
FROM Usuarios;


-- Busca cualquier producto que contenga la palabra "Pintura" en cualquier parte


-- Cuenta cuántos usuarios hay registrados en total


-- Filtra todos los movimientos de inventario que correspondan a ingresos (Entradas)

