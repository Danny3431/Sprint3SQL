-- se crea base de datos /Sprint3
-- Nombres:Alex Carreño / Daniela Puebla /Soraya Tapia / Max Jeldres

-- base de datos TeLoVendo
CREATE DATABASE IF NOT EXISTS TeLoVendo;
USE TeLoVendo;


-- Creacion de usuario con privilegios
CREATE USER 'Grupo8'@'localhost' IDENTIFIED BY '240721';
GRANT ALL PRIVILEGES ON TeLoVendo.* TO 'Grupo8'@'localhost';
FLUSH PRIVILEGES;

USE TeLoVendo;
-- creacion de tabla proveedor
CREATE TABLE Proveedor (
    ID_Proveedor INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Corporativo VARCHAR(100) NOT NULL,
    Representante_Legal VARCHAR(100) NOT NULL,
    Telefono1 VARCHAR(20) NOT NULL,
    Telefono2 VARCHAR(20) NULL,
    Nombre_Contacto VARCHAR(100) NOT NULL,
    Correo_Electronico VARCHAR(100) NOT NULL,
    Categoria VARCHAR(50) NOT NULL
);

-- creacion tabla cliente
CREATE TABLE Cliente (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Direccion VARCHAR(255) NOT NULL
);


-- creacion de tabla producto
CREATE TABLE Producto (
    ID_Producto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Precio INT NOT NULL,
    Stock INT NOT NULL,
    Categoria VARCHAR(50) NOT NULL,
    Color VARCHAR(50) NOT NULL
);


-- creacion de tabla relacion. Producto-Proveedor
CREATE TABLE Producto_Proveedor (
    ID_Producto INT,
    ID_Proveedor INT,
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto),
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedor(ID_Proveedor),
    PRIMARY KEY (ID_Producto, ID_Proveedor)
);


-- Ingreso de datos a tabla proveedor.
start  transaction; -- Inicio de transaccion
INSERT INTO Proveedor (Nombre_Corporativo, Representante_Legal, Telefono1, Telefono2, Nombre_Contacto, Correo_Electronico, Categoria)
VALUES 
('ElectroMart', 'Francisco Gómez', '+56912345678', '+56987654321', 'Sofía Martínez', 'ventas@electromart.cl', 'Electronica'),
('DigitalHome', 'Carolina Silva', '+56923456789' , '+56998765432', 'Laura González', 'contacto@digitalhome.cl', 'Electronica'),
('TechSupplier', 'Javier Paredes', '+56934567890', '+56909876543', 'Pablo Rojas', 'info@techsupplier.cl', 'Electronica'),
('GigaStore', 'María Torres', '+56945678901', '+56910987654', 'Andrés Ramírez', 'ventas@gigastore.cl', 'Electronica'),
('TechServices', 'Rodrigo Fernández', '+56956789012', '+56921098765', 'Natalia López', 'servicios@techservices.cl', 'Electronica');


-- Ingreso de datos Tabla Cliente
INSERT INTO Cliente (Nombre, Apellido, Direccion)
VALUES 
('Carlos', 'Méndez', 'Av. Providencia 1020, Santiago'),
('Ana', 'Riquelme', 'Calle Los Héroes 234, Viña del Mar'),
('Pedro', 'Arancibia', 'Pje. San Miguel 456, Rancagua'),
('Marta', 'López', 'Av. O\'Higgins 789, Concepcion'),
('Jorge', 'Soto', 'Calle San Martín 321, Antofagasta');


-- Ingreso de datos Tabla Producto
INSERT INTO Producto (Nombre, Precio, Stock, Categoria, Color)
VALUES 
('Televisor 4K 55"', 399999, 25, 'Electronica', 'Negro'),
('Smartphone Galaxy S21', 799999, 50, 'Electronica', 'Azul'),
('Laptop Dell XPS 13', 1299999, 15, 'Electronica', 'Plata'),
('Tablet iPad Air', 499999, 30, 'Electronica', 'Gris'),
('Monitor LED 27"', 199999, 40, 'Electronica', 'Blanco'),
('Mouse Gamer RGB', 29999, 100, 'Electronica', 'Negro'),
('Teclado Mecánico', 89999, 60, 'Electronica', 'Negro'),
('Auriculares Bluetooth', 59999, 70, 'Electronica', 'Blanco'),
('Impresora Multifuncional', 149999, 20, 'Electronica', 'Negro'),
('Cámara de Seguridad WiFi', 89999, 80, 'Electronica', 'Blanco');


-- Ingreso de datos tabla Producto_Proveedor
INSERT INTO Producto_Proveedor (ID_Producto, ID_Proveedor)
VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 1), (7, 2), (8, 3), (9, 4), (10, 5);


commit; -- Confirmacion de ingreso de datos exitoso.



-- Cuál es la categoría de productos que más se repite

SELECT Categoria, COUNT(*) AS cantidad
FROM telovendo.Producto
GROUP BY Categoria
ORDER BY cantidad DESC
LIMIT 1;

-- Cuáles son los productos con mayor stock
SELECT Nombre, Stock
FROM telovendo.Producto
ORDER BY Stock DESC
LIMIT 5;

--  Qué color de producto es más común en nuestra tienda.
SELECT Color, COUNT(*) AS cantidad
FROM telovendo.Producto
GROUP BY Color
ORDER BY cantidad DESC
LIMIT 1;

-- Cual o cuales son los proveedores con menor stock de productos.


SELECT p.Nombre_Corporativo, SUM(pr.Stock) AS Total_Stock
FROM Proveedor p
JOIN Producto_Proveedor pp ON p.ID_Proveedor = pp.ID_Proveedor
JOIN Producto pr ON pp.ID_Producto = pr.ID_Producto
GROUP BY p.Nombre_Corporativo
ORDER BY Total_Stock ASC;

-- Por último: Cambien la categoría de productos más popular por ‘Electrónica y computación’.


UPDATE Telovendo.Producto
SET Categoria = 'Electronica y computacion'
WHERE Categoria = 'Electronica';


UPDATE Telovendo.Producto 
SET Categoria = 'Electronica y computacion' 
WHERE Categoria = 'Electronica' AND id_producto IS NOT NULL;

SET SQL_SAFE_UPDATES = 0;

SELECT *FROM Telovendo.Producto;


-- Nos dimos cuenta que hay que crear una nueva tabla para que tenga relacion con la tabla cliente
USE TeLoVendo;
	CREATE TABLE Venta (
    ID_Venta INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT,
    ID_Producto INT,
    Fecha DATE NOT NULL,
    Cantidad INT NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Producto) REFERENCES Producto(ID_Producto)
);


USE TeLoVendo;
INSERT INTO Venta (ID_Cliente, ID_Producto, Fecha, Cantidad)
VALUES
(1, 1, '2024-08-23', 2),
(2, 3, '2024-08-23', 1),
(3, 5, '2024-08-23', 4),
(4, 7, '2024-08-23', 1),
(5, 9, '2024-08-23', 3);

