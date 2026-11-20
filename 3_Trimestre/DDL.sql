drop database proyectof;
CREATE DATABASE proyectof;
USE proyectof;

CREATE TABLE Categoria (
    idCategoria INT PRIMARY KEY AUTO_INCREMENT,
    Nombre_Categoria VARCHAR(50) NOT NULL UNIQUE,
    Descripcion VARCHAR(50),
    Simbologia VARCHAR(50)
);

CREATE TABLE Proveedor (
    idProveedor INT PRIMARY KEY AUTO_INCREMENT,
    Nombre_Proveedor VARCHAR(50) NOT NULL UNIQUE,
    Contacto VARCHAR(30)
);

CREATE TABLE Roles (
    idRoles INT PRIMARY KEY AUTO_INCREMENT, 
    Nombre_Rol VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Usuarios (
    idUsuarios INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Roles_idRoles INT,
    Contrasena VARCHAR(255) NOT NULL,
    CONSTRAINT fk_usuario_rol 
        FOREIGN KEY (Roles_idRoles) 
        REFERENCES Roles(idRoles)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE Producto (
    idProducto INT PRIMARY KEY AUTO_INCREMENT,
    Nombre_Producto VARCHAR(50) NOT NULL UNIQUE,
    Stock_Minimo INT NOT NULL CHECK (Stock_Minimo >= 0),
    ubicacion VARCHAR(50),
    Categoria_idCategoria INT,
    Proveedor_idProveedor INT,
    CONSTRAINT fk_producto_categoria 
        FOREIGN KEY (Categoria_idCategoria) 
        REFERENCES Categoria(idCategoria)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_producto_proveedor 
        FOREIGN KEY (Proveedor_idProveedor) 
        REFERENCES Proveedor(idProveedor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE Alerta_stock (
    idAlerta_stock INT PRIMARY KEY AUTO_INCREMENT,
    Fecha_alerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    Stock INT,
    Estado_alerta VARCHAR(20) DEFAULT 'Bajo',
    Producto_idProducto INT,
    CONSTRAINT chk_estado 
        CHECK (Estado_alerta IN ('Bajo', 'Normal')),
    CONSTRAINT fk_alerta_producto 
        FOREIGN KEY (Producto_idProducto) 
        REFERENCES Producto(idProducto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Movimiento_Inventario (    
    idMovimiento_Inventario INT PRIMARY KEY AUTO_INCREMENT,
    Fecha_Movimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    Tipo_Movimiento VARCHAR(20) NOT NULL,
    Cantidad_Movimiento INT NOT NULL CHECK (Cantidad_Movimiento > 0),
    Usuarios_idUsuarios INT,
    Producto_idProducto INT,
    CONSTRAINT chk_tipo 
        CHECK (Tipo_Movimiento IN ('Entrada', 'Salida')),
    CONSTRAINT fk_mov_usuario 
        FOREIGN KEY (Usuarios_idUsuarios) 
        REFERENCES Usuarios(idUsuarios)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_mov_producto 
        FOREIGN KEY (Producto_idProducto) 
        REFERENCES Producto(idProducto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
