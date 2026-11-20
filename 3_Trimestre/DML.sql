USE proyectof;

INSERT INTO Categoria (Nombre_Categoria) VALUES
('Herramientas'),
('Ferretería'),
('Herramientas Eléctricas'),
('Pinturas');

INSERT INTO Proveedor (Nombre_Proveedor, Contacto) VALUES
('Proveedor A', '32214224'),
('Proveedor B', '32323332'),
('Proveedor C', '31423132'),
('Proveedor D', '34534252');

INSERT INTO Roles (Nombre_Rol) VALUES
('Administrador'),
('Encargado del inventario');

INSERT INTO Producto (Nombre_Producto, Stock_Minimo, ubicacion, Categoria_idCategoria, Proveedor_idProveedor) VALUES
('Martillo', 10, 'Estante 1', 1, 1),
('Clavos 2”', 30, 'Estante 2', 2, 2),
('Taladro', 5, 'Estante 1', 3, 3),
('Pintura Blanca', 10, 'Estante 3', 4, 4),
('Brocha', 15, 'Estante 3', 4, 4);

CALL sp_registrar_usuario('Juan Perez', 'user1', 2);
CALL sp_registrar_usuario('Ana Gomez', 'user12', 2);
CALL sp_registrar_usuario('Carlos Ruiz', 'user123', 2);

CALL sp_registrar_movimiento(NOW(), 'Entrada', 30, 1, 1);
CALL sp_registrar_movimiento(NOW(), 'Salida', 10, 1, 1);
CALL sp_registrar_movimiento(NOW(), 'Entrada', 50, 2, 3);
CALL sp_registrar_movimiento(NOW(), 'Salida', 5, 3, 4);

INSERT INTO Alerta_stock (Stock, Estado_alerta, Producto_idProducto)
VALUES
(5, 'Bajo', 1),
(10, 'Bajo', 2);

select* From usuarios

