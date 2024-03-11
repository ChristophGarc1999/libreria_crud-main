-- Drop database MidnightSlayerGDL;
-- Drop database MidnightSlayerMTY;
-- Drop database MidnightSlayerCDMX;
-- Drop database MidnightSlayerCORP;


-- Sucursal GDL
CREATE DATABASE MidnightSlayerGDL;

USE MidnightSlayerGDL;
CREATE TABLE `MidnightSlayerGDL`.`Autores` (
    ID_Autor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Anio_Nacimiento INT,
    Pais_Nacimiento VARCHAR(200)
);

CREATE TABLE `MidnightSlayerGDL`.`Editoriales` (
    ID_Editorial INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(100),
    Direccion VARCHAR(255),
    Telefono VARCHAR(20)
);

CREATE TABLE `MidnightSlayerGDL`.`Generos` (
    ID_Genero INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(100)
);

CREATE TABLE `MidnightSlayerGDL`.`Libros` (
    ID_Libro INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Titulo VARCHAR(100),
    ID_Autor INT,
    ID_Editorial INT, 
    ISBN BIGINT,
    ID_Genero INT,  
    Anio_publicacion INT,
    Precio DECIMAL(10,2),
    Paginas INT,
    TipoPasta VARCHAR(50),
    FOREIGN KEY (ID_Autor) REFERENCES Autores(ID_Autor),
    FOREIGN KEY (ID_Editorial) REFERENCES Editoriales(ID_Editorial),
    FOREIGN KEY (ID_Genero) REFERENCES Generos(ID_Genero)
);

CREATE TABLE `MidnightSlayerGDL`.`Ventas` (
    ID_Venta INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Cliente INT,
    FechaVenta DATE,
    Total DECIMAL(10,2)
);

CREATE TABLE `MidnightSlayerGDL`.`DetalleVenta` (
    ID_DetalleVenta INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Venta INT,
    ID_Libro INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    TotalLinea DECIMAL(10,2),
    FOREIGN KEY (ID_Venta) REFERENCES Ventas(ID_Venta),
    FOREIGN KEY (ID_Libro) REFERENCES Libros(ID_Libro)
);

CREATE TABLE `MidnightSlayerGDL`.`Inventario` (
    ID_Inventario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Libro INT,
    CantidadDisponible INT,
    FOREIGN KEY (ID_Libro) REFERENCES Libros(ID_Libro)
);

CREATE TABLE `MidnightSlayerGDL`.`Compras` (
    ID_Compra INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Proveedor INT,
    FechaCompra DATE,
    Total DECIMAL(10,2)
);

CREATE TABLE `MidnightSlayerGDL`.`DetalleCompra` (
    ID_DetalleCompra INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Compra INT,
    ID_Libro INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    TotalLinea DECIMAL(10,2),
    FOREIGN KEY (ID_Compra) REFERENCES Compras(ID_Compra),
    FOREIGN KEY (ID_Libro) REFERENCES Libros(ID_Libro)
);

CREATE TABLE `MidnightSlayerGDL`.`EmpleadosBasicos` (
    ID_Empleado INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Matricula VARCHAR(10) UNIQUE,
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Sexo VARCHAR(100),
    Puesto VARCHAR(100),
    Correo VARCHAR(255),
    Sucursal VARCHAR(100)
);

INSERT INTO `MidnightSlayerGDL`.`Autores` (Nombre, Apellido, Anio_Nacimiento, Pais_Nacimiento) VALUES
('Stephen', 'King',1947, 'Estados Unidos'),
('John', 'Katzenbach',1950,'Estados Unidos'),
('Robert Louis', 'Stevenson',1850, 'Reino Unido');


INSERT INTO `MidnightSlayerGDL`.`Editoriales`(Nombre, Direccion, Telefono) VALUES
('Longmans','CONOCIDA','3322885577'),
('Debolsillo','CONOCIDA','4488667730'),
('Ediciones B','CONOCIDA','1177428910');

INSERT INTO `MidnightSlayerGDL`.`Generos`(Nombre) VALUES
('Terror'),
('Novela Gotica'),
('Thriller');

INSERT INTO `MidnightSlayerGDL`.`Libros` (Titulo, ID_Autor, ID_Editorial, ISBN, ID_Genero, Anio_Publicacion, Precio, Paginas, TipoPasta) VALUES
('Carrie',1,2,97812345678,1,1974,221.54,304,'Blanda'),
('El Psicoanalista',2,3,9788466610681,3,2002,404.10,464,'Blanda'),
('El Misterioso Caso Del Dr Jekyll y Mr Hyde',3,1,9780192817402,2,1886,42.10,104,'Blanda');

INSERT INTO `MidnightSlayerGDL`.`Inventario`(ID_Libro,CantidadDisponible) VALUES
(1,78),
(3,105),
(2,98);

Insert into `MidnightSlayerGDL`.`Compras` (ID_Proveedor, FechaCompra, Total) VALUES
(1,	'2023-12-06',1281.6),
(1,'2023-12-05', 3202.5);

Insert into `MidnightSlayerGDL`.`DetalleCompra`( ID_Compra, ID_Libro, Cantidad, PrecioUnitario) VALUES
(1,1,4,320.4),
(2,2,7,457.5);

INSERT INTO `MidnightSlayerGDL`.`Ventas` (ID_Cliente, FechaVenta, Total) VALUES
(1, '2023-12-10', 1012.1),
(2, '2023-12-12', 346.1);

INSERT INTO `MidnightSlayerGDL`.`DetalleVenta` (ID_Venta, ID_Libro, Cantidad, PrecioUnitario) VALUES
(1, 1, 2, 304),
(1, 2, 1, 404.10),
(2, 3, 3, 42.10),
(2, 1, 1, 304);

DELIMITER //
CREATE TRIGGER ActualizarInventarioDespuesVenta
AFTER INSERT ON MidnightSlayerGDL.DetalleVenta
FOR EACH ROW
BEGIN
    -- Actualizar la cantidad disponible en el inventario
    UPDATE MidnightSlayerGDL.Inventario 
    SET CantidadDisponible = CantidadDisponible - NEW.Cantidad WHERE ID_Libro = NEW.ID_Libro;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER ActualizarInventarioDespuesCompra
AFTER INSERT ON MidnightSlayerGDL.DetalleCompra
FOR EACH ROW
BEGIN
    -- Actualizar la cantidad disponible en el inventario después de una compra
    UPDATE MidnightSlayerGDL.Inventario 
    SET CantidadDisponible = CantidadDisponible + NEW.Cantidad WHERE ID_Libro = NEW.ID_Libro;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER CalcularTotalLineaAntesDeInsertarVenta
BEFORE INSERT ON MidnightSlayerGDL.DetalleVenta
FOR EACH ROW
BEGIN
    SET NEW.TotalLinea = NEW.Cantidad * NEW.PrecioUnitario;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER CalcularTotalLineaAntesDeInsertarCompra
BEFORE INSERT ON MidnightSlayerGDL.DetalleCompra
FOR EACH ROW
BEGIN
    SET NEW.TotalLinea = NEW.Cantidad * NEW.PrecioUnitario;
END //
DELIMITER ;


-- Sucursal MTY
CREATE DATABASE MidnightSlayerMTY;

USE MidnightSlayerMTY;

CREATE TABLE `MidnightSlayerMTY`.`Autores` (
    ID_Autor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Anio_Nacimiento INT,
    Pais_Nacimiento VARCHAR(200)
);

CREATE TABLE `MidnightSlayerMTY`.`Editoriales` (
    ID_Editorial INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(100),
    Direccion VARCHAR(255),
    Telefono VARCHAR(20)
);

CREATE TABLE `MidnightSlayerMTY`.`Generos` (
    ID_Genero INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(100)
);

CREATE TABLE `MidnightSlayerMTY`.`Libros` (
    ID_Libro INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Titulo VARCHAR(100),
    ID_Autor INT,
    ID_Editorial INT, 
    ISBN BIGINT,
    ID_Genero INT,  
    Anio_publicacion INT,
    Precio DECIMAL(10,2),
    Paginas INT,
    TipoPasta VARCHAR(50),
    FOREIGN KEY (ID_Autor) REFERENCES Autores(ID_Autor),
    FOREIGN KEY (ID_Editorial) REFERENCES Editoriales(ID_Editorial),
    FOREIGN KEY (ID_Genero) REFERENCES Generos(ID_Genero)
);


CREATE TABLE `MidnightSlayerMTY`.`Ventas` (
    ID_Venta INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Cliente INT,
    FechaVenta DATE,
    Total DECIMAL(10,2)
);

CREATE TABLE `MidnightSlayerMTY`.`DetalleVenta` (
    ID_DetalleVenta INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Venta INT,
    ID_Libro INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    TotalLinea DECIMAL(10,2),
    FOREIGN KEY (ID_Venta) REFERENCES Ventas(ID_Venta),
    FOREIGN KEY (ID_Libro) REFERENCES Libros(ID_Libro)
);

CREATE TABLE `MidnightSlayerMTY`.`Inventario` (
    ID_Inventario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Libro INT,
    CantidadDisponible INT,
    FOREIGN KEY (ID_Libro) REFERENCES Libros(ID_Libro)
);

CREATE TABLE `MidnightSlayerMTY`.`Compras` (
    ID_Compra INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Proveedor INT,
    FechaCompra DATE,
    Total DECIMAL(10,2)
);

CREATE TABLE `MidnightSlayerMTY`.`DetalleCompra` (
    ID_DetalleCompra INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Compra INT,
    ID_Libro INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    TotalLinea DECIMAL(10,2),
    FOREIGN KEY (ID_Compra) REFERENCES Compras(ID_Compra),
    FOREIGN KEY (ID_Libro) REFERENCES Libros(ID_Libro)
);

CREATE TABLE `MidnightSlayerMTY`.`EmpleadosBasicos` (
    ID_Empleado INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Matricula VARCHAR(10) UNIQUE,
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Sexo VARCHAR(100),
    Puesto VARCHAR(100),
    Correo VARCHAR(255),
    Sucursal VARCHAR(100)
);

-- Inserciones para MidnightSlayerMTY
INSERT INTO `MidnightSlayerMTY`.`Autores` (Nombre, Apellido, Anio_Nacimiento, Pais_Nacimiento) VALUES
('Isaac', 'Asimov', 1920, 'Rusia (ahora Bielorrusia)'),
('Jane', 'Austen', 1775, 'Reino Unido'),
('J.R.R.', 'Tolkien', 1892, 'Reino Unido');

INSERT INTO `MidnightSlayerMTY`.`Generos` (Nombre) VALUES
('Ciencia Ficción'),
('Romance'),
('Fantasía');

INSERT INTO `MidnightSlayerMTY`.`Editoriales`(Nombre, Direccion, Telefono) VALUES
('Penguin Random House','CONOCIDA','3322885577'),
('HarperCollins','CONOCIDA','4488667730'),
('Houghton Mifflin Harcourt','CONOCIDA','1177428910');

INSERT INTO `MidnightSlayerMTY`.`Libros` (Titulo, ID_Autor, ID_Editorial, ISBN, ID_Genero, Anio_Publicacion, Precio, Paginas, TipoPasta)
VALUES
('Fundación', 1, 2, 9780553293357, 1, 1951, 150.50, 250, 'Blanda'),
('Orgullo y Prejuicio', 2, 3, 9788499896377, 2, 1813, 120.75, 300, 'Blanda'),
('El Señor de los Anillos: La Comunidad del Anillo', 3, 1, 9788445000731, 3, 1954, 180.25, 400, 'Blanda');


INSERT INTO `MidnightSlayerMTY`.`Inventario`(ID_Libro, CantidadDisponible) VALUES
(1, 50),
(2, 30),
(3, 40);


INSERT INTO `MidnightSlayerMTY`.`Compras` (ID_Proveedor, FechaCompra, Total) VALUES
(2, '2023-12-06', 602),
(4, '2023-12-05', 845.25);

INSERT INTO `MidnightSlayerMTY`.`DetalleCompra` (ID_Compra, ID_Libro, Cantidad, PrecioUnitario) VALUES
(1, 1, 4, 150.5),
(2, 2, 7, 120.75);

INSERT INTO `MidnightSlayerMTY`.`Ventas` (ID_Cliente, FechaVenta, Total) VALUES
(5, '2023-12-10', 843.5),
(6, '2023-12-12', 1202.25);


INSERT INTO `MidnightSlayerMTY`.`DetalleVenta` (ID_Venta, ID_Libro, Cantidad, PrecioUnitario) VALUES
(1, 1, 4, 150.5),
(1, 2, 2, 120.75),
(2, 3, 5, 180.25),
(2, 1, 2, 150.5);


DELIMITER //

CREATE TRIGGER ActualizarInventarioDespuesVenta_MTY
AFTER INSERT ON MidnightSlayerMTY.DetalleVenta
FOR EACH ROW
BEGIN
    -- Actualizar la cantidad disponible en el inventario
    UPDATE MidnightSlayerMTY.Inventario
    SET CantidadDisponible = CantidadDisponible - NEW.Cantidad
    WHERE ID_Libro = NEW.ID_Libro;
END //

CREATE TRIGGER ActualizarInventarioDespuesCompra_MTY
AFTER INSERT ON MidnightSlayerMTY.DetalleCompra
FOR EACH ROW
BEGIN
    -- Actualizar la cantidad disponible en el inventario después de una compra
    UPDATE MidnightSlayerMTY.Inventario
    SET CantidadDisponible = CantidadDisponible + NEW.Cantidad
    WHERE ID_Libro = NEW.ID_Libro;
END //

CREATE TRIGGER CalcularTotalLineaAntesDeInsertarVenta_MTY
BEFORE INSERT ON MidnightSlayerMTY.DetalleVenta
FOR EACH ROW
BEGIN
    SET NEW.TotalLinea = NEW.Cantidad * NEW.PrecioUnitario;
END //

CREATE TRIGGER CalcularTotalLineaAntesDeInsertarCompra_MTY
BEFORE INSERT ON MidnightSlayerMTY.DetalleCompra
FOR EACH ROW
BEGIN
    SET NEW.TotalLinea = NEW.Cantidad * NEW.PrecioUnitario;
END //

DELIMITER ;

-- Sucursal CDMX
CREATE DATABASE MidnightSlayerCDMX;

USE MidnightSlayerCDMX;

CREATE TABLE `MidnightSlayerCDMX`.`Autores` (
    ID_Autor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Anio_Nacimiento INT,
    Pais_Nacimiento VARCHAR(200)
);

CREATE TABLE `MidnightSlayerCDMX`.`Editoriales` (
    ID_Editorial INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(100),
    Direccion VARCHAR(255),
    Telefono VARCHAR(20)
);

CREATE TABLE `MidnightSlayerCDMX`.`Generos` (
    ID_Genero INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(100)
);

CREATE TABLE `MidnightSlayerCDMX`.`Libros` (
    ID_Libro INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Titulo VARCHAR(100),
    ID_Autor INT,
    ID_Editorial INT, 
    ISBN BIGINT,
    ID_Genero INT,  
    Anio_publicacion INT,
    Precio DECIMAL(10,2),
    Paginas INT,
    TipoPasta VARCHAR(50),
    FOREIGN KEY (ID_Autor) REFERENCES Autores(ID_Autor),
    FOREIGN KEY (ID_Editorial) REFERENCES Editoriales(ID_Editorial),
    FOREIGN KEY (ID_Genero) REFERENCES Generos(ID_Genero)
);


CREATE TABLE `MidnightSlayerCDMX`.`Ventas` (
    ID_Venta INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Cliente INT,
    FechaVenta DATE,
    Total DECIMAL(10,2)
);

CREATE TABLE `MidnightSlayerCDMX`.`DetalleVenta` (
    ID_DetalleVenta INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Venta INT,
    ID_Libro INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    TotalLinea DECIMAL(10,2),
    FOREIGN KEY (ID_Venta) REFERENCES Ventas(ID_Venta),
    FOREIGN KEY (ID_Libro) REFERENCES Libros(ID_Libro)
);

CREATE TABLE `MidnightSlayerCDMX`.`Inventario` (
    ID_Inventario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Libro INT,
    CantidadDisponible INT,
    FOREIGN KEY (ID_Libro) REFERENCES Libros(ID_Libro)
);


CREATE TABLE `MidnightSlayerCDMX`.`Compras` (
    ID_Compra INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Proveedor INT,
    FechaCompra DATE,
    Total DECIMAL(10,2)
);

CREATE TABLE `MidnightSlayerCDMX`.`DetalleCompra` (
    ID_DetalleCompra INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ID_Compra INT,
    ID_Libro INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    TotalLinea DECIMAL(10,2),
    FOREIGN KEY (ID_Compra) REFERENCES Compras(ID_Compra),
    FOREIGN KEY (ID_Libro) REFERENCES Libros(ID_Libro)
);

CREATE TABLE `MidnightSlayerCDMX`.`EmpleadosBasicos` (
    ID_Empleado INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Matricula VARCHAR(10) UNIQUE,
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Sexo VARCHAR(100),
    Puesto VARCHAR(100),
    Correo VARCHAR(255),
    Sucursal VARCHAR(100)
);

INSERT INTO `MidnightSlayerCDMX`.`Autores` (Nombre, Apellido, Anio_Nacimiento, Pais_Nacimiento) VALUES
('Agatha', 'Christie', 1890, 'Reino Unido'),
('Hilary', 'Mantel', 1952, 'Reino Unido'),
('Mark', 'Twain', 1835, 'Estados Unidos');

INSERT INTO `MidnightSlayerCDMX`.`Generos` (Nombre) VALUES
('Misterio'),
('Histórica'),
('Humor');

INSERT INTO `MidnightSlayerCDMX`.`Editoriales` (Nombre, Direccion, Telefono) VALUES
('Vintage Crime/Black Lizard', 'CONOCIDA', '3322885577'),
('Henry Holt and Co.', 'CONOCIDA', '4488667730'),
('Penguin Classics', 'CONOCIDA', '1177428910');

INSERT INTO `MidnightSlayerCDMX`.`Libros` (Titulo, ID_Autor, ID_Editorial, ISBN, ID_Genero, Anio_Publicacion, Precio, Paginas, TipoPasta) VALUES
('Diez negritos', 1, 2, 9780062073471, 1, 1939, 275.80, 256, 'Blanda'),
('Wolf Hall', 2, 3, 9780061950728, 2, 2009, 396.25, 432, 'Blanda'),
('Las aventuras de Tom Sawyer', 3, 1, 9780143107332, 3, 1876, 256.40, 320, 'Blanda');


INSERT INTO `MidnightSlayerCDMX`.`Inventario` (ID_Libro, CantidadDisponible) VALUES
(1, 60),
(2, 40),
(3, 50);

-- Inserciones para la tabla Compras
INSERT INTO `MidnightSlayerCDMX`.`Compras` (ID_Proveedor, FechaCompra, Total) VALUES
(3, '2023-12-06', 2377.5),
(4, '2023-12-05', 2403.45);

INSERT INTO `MidnightSlayerCDMX`.`DetalleCompra` (ID_Compra, ID_Libro, Cantidad, PrecioUnitario) VALUES
(1, 2, 6, 396.25),
(2, 1, 8, 2206.4);

-- Inserciones para la tabla Ventas
INSERT INTO `MidnightSlayerCDMX`.`Ventas` (ID_Cliente, FechaVenta, Total) VALUES
(3, '2023-12-10', 1619.9),
(4, '2023-12-12', 1301.4);

-- Inserciones para la tabla DetalleVenta
INSERT INTO `MidnightSlayerCDMX`.`DetalleVenta` (ID_Venta, ID_Libro, Cantidad, PrecioUnitario) VALUES
(1, 1, 3, 275.8),
(1, 2, 2, 396.25),
(2, 3, 4, 256.4),
(2, 1, 1, 275.8);


DELIMITER //

CREATE TRIGGER ActualizarInventarioDespuesVenta_CDMX
AFTER INSERT ON MidnightSlayerCDMX.DetalleVenta
FOR EACH ROW
BEGIN
    -- Actualizar la cantidad disponible en el inventario
    UPDATE MidnightSlayerCDMX.Inventario
    SET CantidadDisponible = CantidadDisponible - NEW.Cantidad
    WHERE ID_Libro = NEW.ID_Libro;
END //

CREATE TRIGGER ActualizarInventarioDespuesCompra_CDMX
AFTER INSERT ON MidnightSlayerCDMX.DetalleCompra
FOR EACH ROW
BEGIN
    -- Actualizar la cantidad disponible en el inventario después de una compra
    UPDATE MidnightSlayerCDMX.Inventario
    SET CantidadDisponible = CantidadDisponible + NEW.Cantidad
    WHERE ID_Libro = NEW.ID_Libro;
END //

CREATE TRIGGER CalcularTotalLineaAntesDeInsertarVenta_CDMX
BEFORE INSERT ON MidnightSlayerCDMX.DetalleVenta
FOR EACH ROW
BEGIN
    SET NEW.TotalLinea = NEW.Cantidad * NEW.PrecioUnitario;
END //

CREATE TRIGGER CalcularTotalLineaAntesDeInsertarCompra_CDMX
BEFORE INSERT ON MidnightSlayerCDMX.DetalleCompra
FOR EACH ROW
BEGIN
    SET NEW.TotalLinea = NEW.Cantidad * NEW.PrecioUnitario;
END //

DELIMITER ;

-- Base de datos corporativa
CREATE DATABASE MidnightSlayerCorp;

USE MidnightSlayerCorp;
CREATE TABLE `MidnightSlayerCorp`.`Clientes` (
    ID_Cliente INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    CorreoElectronico VARCHAR(255),
    Telefono VARCHAR(20),
    Direccion VARCHAR(200)
);

INSERT INTO `MidnightSlayerCorp`.`Clientes` (Nombre, Apellido, CorreoElectronico, Telefono, Direccion) VALUES
('Belen','Cardona','belen@gmail.com',3322778899,'CONOCIDA'),
('Juan','Perez','juan@gmail.com',3322114455,'CONOCIDA'),
('Maria','Mendoza','Maria@gmail.com',3322568855,'CONOCIDA'),
('Luis','Garcia','lgarcia@gmail.com',3312458963,'CONOCIDA'),
('Ana', 'Martinez', 'ana@gmail.com', 3312345678, 'CONOCIDA'),
('Pedro', 'Lopez', 'pedro@gmail.com', 3331234567, 'CONOCIDA');



CREATE TABLE `MidnightSlayerCorp`.`Proveedores` (
    ID_Proveedor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    NombreProveedor VARCHAR(100),
    Contacto VARCHAR(100),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(255),
    Direccion VARCHAR(200)
);

INSERT INTO `MidnightSlayerCorp`.`Proveedores` (NombreProveedor, Contacto, Telefono, CorreoElectronico, Direccion) VALUES
('Gonvill','Francisco Mendoza',3322448899,'jperez@gonvill.com','CONOCIDA'),
('Gandhi', 'Pablo Figueroa',3374859612,'pfigueroa@gandhi.com','CONOCIDA'),
('Librería Porrúa','Ana Sánchez',3345789652,'asanchez@porrua.com','CONOCIDA'),
('El Sótano','Luis Martínez',3387456987,'lmartinez@elsotano.com','CONOCIDA'),
('Fondo de Cultura Económica','Carlos Gómez',3312345678,'cgomez@fce.com','CONOCIDA'),
('Casa del Libro','Laura Ramírez',3312457896,'lramirez@casadellibro.com','CONOCIDA');

CREATE TABLE `MidnightSlayerCorp`.`EmpleadosBasicos` (
    ID_Empleado INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Matricula VARCHAR(10) UNIQUE,
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Sexo VARCHAR(100),
    Puesto VARCHAR(100),
    Correo VARCHAR(255),
    Sucursal VARCHAR(100)
);


CREATE TABLE `MidnightSlayerCorp`.`EmpleadosDetalles` (
    Matricula VARCHAR(10) PRIMARY KEY NOT NULL,
    TipoSangre VARCHAR(10),
    Salario DECIMAL(10,2),
    FechaIngreso DATE,
    FechaNacimiento DATE,
    ContactoEmergencia VARCHAR(100),
    NumeroEmergencia VARCHAR(20),
    NumeroSeguroSocial VARCHAR(20),
    Domicilio VARCHAR(200)
);

INSERT INTO `MidnightSlayerGDL`.`EmpleadosBasicos` (Matricula, Nombre, Apellido, Sexo, Puesto, Correo, Sucursal) VALUES
('1001', 'Juan', 'Pérez', 'Masculino', 'Asistente Administrativo', 'juan.perez@midnightslayer.net', 'GDL'),
('1002', 'María', 'López', 'Femenino', 'Gerente de Sucursal', 'maria.lopez@midnightslayer.net', 'GDL'),
('1003', 'José', 'Ramírez', 'Masculino', 'Aistente de Gerente de Sucursal', 'jose.ramirez@midnightslayer.net', 'GDL'),
('1004', 'Ana', 'González', 'Femenino', 'Vendedor', 'ana.gonzalez@midnightslayer.net', 'GDL'),
('1005', 'Pedro', 'Martínez', 'Masculino', 'Vendedor', 'pedro.martinez@midnightslayer.net', 'GDL'),
('1006', 'Laura', 'Sánchez', 'Femenino', 'Cajero', 'laura.sanchez@midnightslayer.net', 'GDL');

INSERT INTO `MidnightSlayerCDMX`.`EmpleadosBasicos` (Matricula, Nombre, Apellido, Sexo, Puesto, Correo, Sucursal)
VALUES
('1007', 'Carlos', 'Gómez', 'Masculino', 'Gerente de Sucursal', 'carlos.gomez@midnightslayer.net', 'CDMX'),
('1008', 'Luisa', 'Hernández', 'Femenino', 'Asistente de Gerente de Sucursal', 'luisa.hernandez@midnightslayer.net', 'CDMX'),
('1009', 'Fernando', 'Díaz', 'Masculino', 'Cajero', 'fernando.diaz@midnightslayer.net', 'CDMX'),
('1010', 'Mónica', 'Rodríguez', 'Femenino', 'Vendedora', 'monica.rodriguez@midnightslayer.net', 'CDMX'),
('1011', 'Roberto', 'Pérez', 'Masculino', 'Técnico de Soporte', 'roberto.perez@midnightslayer.net', 'CDMX'),
('1012', 'Paula', 'García', 'Femenino', 'Asistente Administrativo', 'paula.garcia@midnightslayer.net', 'CDMX');

INSERT INTO `MidnightSlayerMTY`.`EmpleadosBasicos` (Matricula, Nombre, Apellido, Sexo, Puesto, Correo, Sucursal)
VALUES
('1013', 'Eduardo', 'Martínez', 'Masculino', 'Gerente de Sucursal', 'eduardo.martinez@midnightslayer.net', 'MTY'),
('1014', 'Lorena', 'Gómez', 'Femenino', 'Asistente de Gerente de Sucursal', 'lorena.gomez@midnightslayer.net', 'MTY'),
('1015', 'Héctor', 'Fernández', 'Masculino', 'Cajero', 'hector.fernandez@midnightslayer.net', 'MTY'),
('1016', 'Marisol', 'Díaz', 'Femenino', 'Vendedora', 'marisol.diaz@midnightslayer.net', 'MTY'),
('1017', 'Daniel', 'Pérez', 'Masculino', 'Técnico de Soporte', 'daniel.perez@midnightslayer.net', 'MTY'),
('1018', 'Patricia', 'García', 'Femenino', 'Asistente Administrativo', 'patricia.garcia@midnightslayer.net', 'MTY');

INSERT INTO `MidnightSlayerCorp`.`EmpleadosBasicos` (Matricula, Nombre, Apellido, Sexo, Puesto, Correo, Sucursal)
VALUES
('1019', 'Roberto', 'García', 'Masculino', 'Gerente de RRHH', 'roberto.garcia@midnightslayer.net', 'Corporativo'),
('1020', 'Luisa', 'Hernández', 'Femenino', 'Analista de Datos', 'luisa.hernandez@midnightslayer.net', 'Corporativo'),
('1021', 'Fernando', 'Martínez', 'Masculino', 'Contador', 'fernando.martinez@midnightslayer.net', 'Corporativo'),
('1022', 'Monica', 'Rodríguez', 'Femenino', 'Asistente de Finanzas', 'monica.rodriguez@midnightslayer.net', 'Corporativo'),
('1023', 'Carlos', 'López', 'Masculino', 'Direccion General', 'carlos.lopez@midnightslayer.net', 'Corporativo'),
('1024', 'Paola', 'Gómez', 'Femenino', 'Administrador de Sistemas', 'paola.gomez@midnightslayer.net', 'Corporativo');


-- Inserciones para la tabla EmpleadosDetalles en MidnightSlayerCorp
INSERT INTO `MidnightSlayerCorp`.`EmpleadosDetalles` (Matricula, TipoSangre, Salario, FechaIngreso, FechaNacimiento, ContactoEmergencia, NumeroEmergencia, NumeroSeguroSocial, Domicilio) VALUES
('1001', 'O+', 2500.00, '2020-01-15', '1990-05-20', 'Maria Gonzalez', '332-123-4567', '123-456-7890', 'Calle Solidaridad #123, Guadalajara'),
('1002', 'A-', 2800.00, '2018-07-20', '1985-09-12', 'Fernando Vazquez', '334-987-6543', '234-567-8901', 'Avenida Segunda #456, Guadalajara'),
('1003', 'B+', 3200.00, '2019-03-10', '1992-11-30', 'Cesar Triana', '336-456-7890', '345-678-9012', 'Boulevard de la Paz #789, Guadalajara'),
('1004', 'AB-', 2900.00, '2021-09-05', '1988-07-15', 'Aide Consuelo', '337-789-0123', '456-789-0123', 'Calle Malvaste #234, Guadalajara'),
('1005', 'O-', 2700.00, '2017-05-28', '1995-03-25', 'Diana Padilla', '338-234-5678', '567-890-1234', 'Avenida Patria #567, Guadalajara'),
('1006', 'A+', 3000.00, '2020-11-12', '1998-12-10', 'Eduardo Oceguera', '318-678-9012', '678-901-2345', 'Boulevard Miguel de la Madrid #890, Guadalajara'),
('1007', 'O+', 5000.00, '2020-01-15', '1990-05-10', 'Javier López', '555-111-2222', '1234567890', 'Prolongacion Vallarta #123, Ciudad de México'),
('1008', 'A-', 4500.00, '2021-03-20', '1992-09-22', 'María Sánchez', '555-333-4444', '0987654321', 'Avenida Guadalupe #456, Ciudad de México'),
('1009', 'B+', 4000.00, '2019-07-10', '1988-11-05', 'Lucía Rodríguez', '555-555-6666', '1357924680', 'Calle Hidalgo #789, Ciudad de México'),
('1010', 'AB-', 5500.00, '2020-11-28', '1995-02-15', 'Diego Gutiérrez', '555-777-8888', '9876543210', 'Boulevard de la Patria #234, Ciudad de México'),
('1011', 'O-', 6000.00, '2018-05-05', '1985-08-30', 'Sofía Torres', '555-999-0000', '2468135790', 'Avenida Fray Angelico #567, Ciudad de México'),
('1012', 'A+', 4700.00, '2022-02-12', '1993-07-20', 'Jorge Martínez', '555-121-2121', '9876541230', 'Calle de la Madrid #345, Ciudad de México'),
('1013', 'O+', 5500.00, '2020-02-20', '1987-11-15', 'Carlos López', '818-111-2222', '1234567890', 'Avenida Libertador #123, Monterrey'),
('1014', 'A-', 4800.00, '2021-04-25', '1990-06-10', 'Laura Sánchez', '818-333-4444', '0987654321', 'Calzada Independencia #456, Monterrey'),
('1015', 'B+', 4200.00, '2019-08-15', '1989-09-05', 'Diego Rodríguez', '818-555-6666', '1357924680', 'Calle sin Nombre #789, Monterrey'),
('1016', 'AB-', 5700.00, '2020-12-10', '1994-03-20', 'Sofía Gutiérrez', '818-777-8888', '9876543210', 'Boulevard Pabellon #234, Monterrey'),
('1017', 'O-', 6200.00, '2018-06-08', '1986-05-30', 'Javier Torres', '818-999-0000', '2468135790', 'Avenida Lopez #567, Monterrey'),
('1018', 'A+', 4900.00, '2022-03-18', '1991-08-12', 'María Martínez', '818-121-2121', '9876541230', 'Calle Bethoveen #345, Monterrey'),
('1019', 'O+', 6500.00, '2018-06-15', '1985-04-10', 'Ana García', '+52 555-111-2222', '1234567890', 'Calle Principal #123, Guanajuato'),
('1020', 'A-', 6000.00, '2017-03-20', '1987-01-22', 'Pedro Hernández', '+52 555-333-4444', '0987654321', 'Avenida Juárez #456, Guanajuato'),
('1021', 'B+', 5500.00, '2019-07-10', '1989-02-05', 'Roberto Martínez', '+52 555-555-6666', '1357924680', 'Boulevard Miguel Hidalgo #789, Guanajuato'),
('1022', 'AB-', 7000.00, '2016-11-28', '1991-05-15', 'María Rodríguez', '+52 555-777-8888', '9876543210', 'Prolongación Reforma #1011, Guanajuato'),
('1023', 'O-', 18000.00, '2015-05-05', '1980-08-30', 'Carlos López', '+52 555-999-0000', '2468135790', 'Pabellón de Arteaga #1213, Guanajuato'),
('1024', 'A+', 7000.00, '2020-02-12', '1990-07-20', 'Luisa Gómez', '+52 555-121-2121', '9876541230', 'Avenida Constitución #1415, Guanajuato');



