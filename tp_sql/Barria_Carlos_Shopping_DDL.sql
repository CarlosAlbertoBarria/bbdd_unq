-- este TP fue trabajado tanto en consola UBUNTU como en pgAdmin13 por lo que la creacion de la base de datos y el ingreso a la misma difiere entre ambas

-- punto 1)a. 

-- Pasos para creación de base de datos desde consola UBUNTU
-- Ingresé como usuario postgres psql a la terminal utilizando los siguientes comandos:
-- "sudo -i -u postgres", y luego me pidió la contraseña de usuario root y la ingresé
--"psql" para ingresar a las bases de datos
--luego cree la base de datos tp_barria con el comando

--CREATE DATABASE tp_barria;

--una vez creada la base de datos, ingresé especificamente a la misma mediante el comando: 

--"\c nombre_base_de_datos 

--para poder crear las tablas en la base de datos 




-- Desde pgAdmin creé la base de datos "tp_barria" desde la interfaz web
--me dirigí al Browser en Server --> PostgreSQL click derecho en Databases --> Create --> Database
-- Llené el campo Database con el nombre tp_barria y le di click a Save
-- me dirigí al Browser en Server --> PostgreSQL --> Databases --> click derecho sobre la base de datos tp_barria --> Query Tool
-- y en la ventana Query Editor trabajé las sentencias para la creación de tablas e ingreso de datos




-- punto 1)b) creación de tablas y querys
 
-- el primer paso fue crear la tabla cliente, la cual no dependia de ninguna otra y podian cargarse los datos sin
--problemas de dependencia (no tenia atributos como FK)

CREATE TABLE cliente(
id SERIAL PRIMARY KEY,
nombre VARCHAR(20),
fecha_nac DATE,
telefono INT,
dni INT
)
;
-- el segundo paso fue crear la tabla empleado,  la cual no dependia de ninguna otra y podian cargarse los datos sin
--problemas de dependencia (no tenia atributos como FK)

CREATE TABLE empleado(
id SERIAL PRIMARY KEY,
nombre VARCHAR(20),
telefono INT,
direccion VARCHAR(20),
id_tienda INT,
rol VARCHAR(20),
inf_medica INT
)
;
-- el tercer paso fue crear la tabla informacion_medica, la cual no dependia de ninguna otra y podian cargarse los datos sin
--problemas de dependencia (no tenia atributos como FK)

CREATE TABLE informacion_medica(
id SERIAL PRIMARY KEY,
grupo_sanguineo VARCHAR(5),
alergias VARCHAR(200),
obra_social VARCHAR(20)
)
;

-- el cuarto paso fue crear la tabla producto y la tabla tienda, sin agregar restricciones en ella aun

CREATE TABLE producto(
id SERIAL PRIMARY KEY,
tienda INT,
tipo VARCHAR(20),
nombre VARCHAR(20),
precio INT
)
;

CREATE TABLE tienda(
id SERIAL PRIMARY KEY,
nombre VARCHAR(20),
local INT,
encargado INT
)
;
-- una vez creada las tablas producto y tienda, anteriormente mencionadas agrego las restricciones(FKs)
--a las tablas empleado, tienda y producto

ALTER TABLE empleado
ADD CONSTRAINT fk_empleado_idtienda
FOREIGN KEY (id_tienda)
REFERENCES tienda (id)
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE empleado
ADD CONSTRAINT fk_empleado_infmedica
FOREIGN KEY (inf_medica)
REFERENCES informacion_medica (id)
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE tienda
ADD CONSTRAINT fk_tienda
FOREIGN KEY (encargado)
REFERENCES empleado (id)
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE producto
ADD CONSTRAINT fk_producto
FOREIGN KEY (tienda)
REFERENCES tienda (id)
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- agrego a la tabla informacion_medica, un nuevo campo llamado contacto_emergencia, el cual se pide en el punto 1)c. del trabajo practico

ALTER TABLE informacion_medica
ADD COLUMN contacto_emergencia
VARCHAR(35)
;

-- creo la tabla local que se pide en el punto 1)d.

CREATE TABLE local(
id SERIAL PRIMARY KEY,
sector VARCHAR(50),
tamaño DECIMAL)
;


-- agrego restriccion a la tabla tienda, la cual hace referencia mediante una FK en en campo "local" al campo "id" de la tabla local

ALTER TABLE tienda
ADD CONSTRAINT fk_tienda_local
FOREIGN KEY (local)
REFERENCES local (id)
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- se crea la tabla ventas junto con la restriccion PK

CREATE TABLE venta(
cliente INT,
producto INT,
tienda INT,
fecha TIMESTAMP,
descuento INT,
CONSTRAINT venta_pk_cliente PRIMARY KEY(cliente, producto, tienda)
)
;

-- agrego restricciones a la tabla venta, las cuales hacen referencia mediante FK en los campos "cliente", "producto" y "tienda", a la "id" de las tablas cliente, producto y venta
ALTER TABLE venta  
ADD CONSTRAINT fk_venta_cliente
FOREIGN KEY (cliente)
REFERENCES cliente (id)
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE venta
ADD CONSTRAINT fk_venta_producto
FOREIGN KEY (producto)
REFERENCES producto (id)
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE venta
ADD CONSTRAINT fk_venta_tienda
FOREIGN KEY (tienda)
REFERENCES tienda (id)
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- se sabe que los siguientes comandos no son DLL sino que son DML pero se utilizaron en este archivo
-- para tener a la vista la creacion de la base de datos y poder corroborar resultados obtenidos en las consultas DML


-- inserté de datos de tabla cliente

INSERT INTO cliente (id, nombre, fecha_nac, telefono, dni)
VALUES (DEFAULT, 'Miguel', '15/12/1965', 98623569, 10645342),  
	(DEFAULT, 'Macarena', '02/08/1990', 98653120, 35201145),
	(DEFAULT, 'Florencia', '18/12/1992', 98536241, 37179457),
	(DEFAULT, 'Hernan', '09/10/1997', 98345122, 40121622),
	(DEFAULT, 'Alberto', '31/07/1958', 98133743, 09345364),
	(DEFAULT, 'Carlos', '31/08/1990', 98653254, 35792264),
	(DEFAULT, 'Gerardo', '12/12/1989', 98451236, 34594132),
	(DEFAULT, 'Johana', '22/04/1997', 98547878, 40289049),
	(DEFAULT, 'Gisel', '15/02/1992', 98232365, 35123679),
	(DEFAULT, 'Melissa', '16/06/1993', 98555222, 37555499),
        (DEFAULT, 'Luciana', '20/12/1991', 98123456, 36222157),
        (DEFAULT, 'Luis', '05/11/1990', 98369258, 35369258),
        (DEFAULT, 'Dario', '04/08/1985', 98091847, 31157444);
 
-- inserté de datos de tabla local
        
INSERT INTO local (id, sector, tamaño)
VALUES (DEFAULT, 'Planta Baja A', 50.5),
       (DEFAULT, 'Primer Piso D', 65.2),
       (DEFAULT, 'Segundo Piso G', 70.5),
       (DEFAULT, 'Segundo Piso H', 70.5),
       (DEFAULT, 'Planta Baja A', 55.5),
       (DEFAULT, 'Primer Piso D', 45.5),
       (DEFAULT, 'Segundo Piso G', 68.0),
       (DEFAULT, 'Segundo Piso F', 80.5);

-- inserté de datos de tabla informacion_medica

INSERT INTO informacion_medica (id, grupo_sanguineo, alergias, obra_social, contacto_emergencia)
VALUES (DEFAULT, 'AB-', 'Acaros, polen, insulina','OSDE', 'cargar@despues.com'),
       (DEFAULT, 'O-', 'Ninguna', 'ANDAR', NULL),
       (DEFAULT, 'O-', 'Picadura de abeja', 'APRESS', 'juliana@gmail.com'),
       (DEFAULT, 'O-', 'Ninguna', 'GALENO', NULL),
       (DEFAULT, 'A+', 'Ninguna', 'GALENO', NULL),
       (DEFAULT, 'B+', 'Colageno', 'OSDE', 'cargar@despues.com'),
       (DEFAULT, 'A-', 'Ninguna', 'OSDE', 'mauro@gmail.com'),
       (DEFAULT, 'B+', 'Ninguna', 'SWISS MEDICAL', 'luciana@gmail.com'),
       (DEFAULT, 'O-', 'Ninguna', 'OSDE', 'raul@gmail.com'),
       (DEFAULT, 'AB+', 'Ninguna', 'APRESS', 'laura@gmail.com'),
       (DEFAULT, 'B-', 'Ninguna', 'SWISS MEDICAL', 'cargar@despues.com'),
       (DEFAULT, 'B+', 'Ninguna', 'OSDE', 'cargar@despues.com'),
       (DEFAULT, 'A+', 'Ninguna', 'OSDE', 'cargar@despues.com'),
       (DEFAULT, 'O-', 'Polen', 'GALENO', 'maximo@gmail.com'),
       (DEFAULT, 'B-', 'Ninguna', 'GALENO', 'gabriela@gmail.com'),
       (DEFAULT, 'O-', 'Ninguna', 'GALENO', 'luis@yahoo.com.ar');

--inserté de datos de tabla tienda, con valores en NULL en los campos FK, los cuales dependian de otras tablas

INSERT INTO tienda (id, nombre, local, encargado)
VALUES (DEFAULT, 'Daniel Hechter', NULL, NULL),
       (DEFAULT, 'La Parfumerie', NULL, NULL),
       (DEFAULT, 'Puma', NULL, NULL),
       (DEFAULT, 'Pigmento', NULL, NULL),
       (DEFAULT, 'Sony', NULL, NULL),
       (DEFAULT, 'Compumundo', NULL, NULL),
       (DEFAULT, 'Swell', NULL, NULL),
       (DEFAULT, 'Silbon', NULL, NULL),
       (DEFAULT, 'Nike', NULL, NULL);

-- asigné mediante actualización, los datos del campo "local" para cada una de las tiendas

UPDATE tienda
SET local = 1
WHERE id = 1
;  

UPDATE tienda
SET local = 3
WHERE id = 2
;

UPDATE tienda
SET local = 2
WHERE id = 3
;

UPDATE tienda
SET local = 4
WHERE id = 4
;

UPDATE tienda
SET local = 7
WHERE id = 5
;

UPDATE tienda
SET local = 6
WHERE id = 6
;

UPDATE tienda
SET local = 5
WHERE id = 7
;

UPDATE tienda 
SET local = 1
WHERE id = 8
;

UPDATE tienda
SET local = 8
WHERE id = 9
;

--inserté de datos de tabla tienda, con valores en NULL en los campos FK, los cuales dependian de otras tablas

INSERT INTO empleado (id, nombre, telefono, direccion, id_tienda, rol, inf_medica)
VALUES (DEFAULT, 'Carlos', 98653120, 'Craviotto 2742', NULL, 'Encargadx', NULL),
       (DEFAULT, 'Roberto', 98222000, 'San Martin 1740', NULL, 'venta', NULL),
       (DEFAULT, 'Juliana', 98226474, 'Andres Baranda 1542', NULL, 'venta', NULL),
       (DEFAULT, 'Nicolas', 98765543, 'Irigoyen 542', NULL, 'Encargadx', NULL),
       (DEFAULT, 'Melanie', 98326554, 'San Martin 1740', NULL, 'Encargadx', NULL),
       (DEFAULT, 'Jonnatan', 98006556, 'Moreno 552', NULL, 'venta', NULL),
       (DEFAULT, 'Mauro', 98001444, 'Craviotto 2742', NULL, 'venta', NULL),
       (DEFAULT, 'Luciana', 98987898, 'Alte. Brown 455', NULL, 'Community Manager', NULL),
       (DEFAULT, 'Raul', 98458123, 'Alvear 1556', NULL, 'Encargadx', NULL),
       (DEFAULT, 'Laura', 98357159, 'Belgrano 1512', NULL, 'Encargadx', NULL),
       (DEFAULT, 'Matias', 98515165, 'Hernandez 455', NULL, 'Community Manager', NULL),
       (DEFAULT, 'Ramiro', 98652178,'Zapiola 875', NULL, 'Encargadx', NULL),
       (DEFAULT, 'Romina', 98349756, 'Liniers 979', NULL, 'Encargadx', NULL),
       (DEFAULT, 'Maximo', 98263574, 'Uruguay 350', NULL, 'venta', NULL),
       (DEFAULT, 'Gabriela', 98899889, 'Uruguay 350', NULL, 'Encargadx', NULL),
       (DEFAULT, 'Luis', 98236546, 'La Madrid 454', NULL, 'Encargadx', NULL);

-- asigné mediante actualización, el dato que hace referencia a la tienda en la que trabaja cada empleado con rol encargado

UPDATE empleado 
SET id_tienda = 1
WHERE id = 1 
AND rol = 'Encargadx'	     
;


UPDATE empleado 
SET id_tienda = 2
WHERE id = 5
AND rol = 'Encargadx' 	     
;	     


UPDATE empleado 
SET id_tienda = 3
WHERE id = 16 	     
AND rol = 'Encargadx'
;


UPDATE empleado 
SET id_tienda = 4
WHERE id = 4 	     
AND rol = 'Encargadx'
;


UPDATE empleado 
SET id_tienda = 5
WHERE id = 10 	     
AND rol = 'Encargadx'
;


UPDATE empleado 
SET id_tienda = 6
WHERE id = 9 	     
AND rol = 'Encargadx'
;


UPDATE empleado 
SET id_tienda = 7
WHERE id = 12	     
AND rol = 'Encargadx'
;


UPDATE empleado 
SET id_tienda = 8
WHERE id = 13
AND rol = 'Encargadx'
;


UPDATE empleado 
SET id_tienda = 9
WHERE id = 15
AND rol = 'Encargadx'
;


-- asigné al resto de los empleados que no son encargados, sus respectivas tiendas

UPDATE empleado 
SET id_tienda = 1
WHERE id = 2 	     
;


UPDATE empleado 
SET id_tienda = 2
WHERE id = 3 	     
;


UPDATE empleado 
SET id_tienda = 3
WHERE id = 4 	     
;


UPDATE empleado 
SET id_tienda = 4
WHERE id = 6 	     
;


UPDATE empleado 
SET id_tienda = 5
WHERE id = 7	     
;


UPDATE empleado 
SET id_tienda = 6
WHERE id = 8 	     
;


UPDATE empleado 
SET id_tienda = 7
WHERE id =11 	     
;


UPDATE empleado 
SET id_tienda = 8
WHERE id = 14 	     
;



-- asigné mediante actualización, el dato que hace referencia al encargado que tiene cada tienda

UPDATE tienda
SET encargado = 1
WHERE id = 1
;

UPDATE tienda
SET encargado = 5
WHERE id = 2
;

UPDATE tienda
SET encargado = 16
WHERE id = 3
;

UPDATE tienda
SET encargado = 4
WHERE id = 4
;

UPDATE tienda
SET encargado = 10
WHERE id = 5
;

UPDATE tienda
SET encargado = 9
WHERE id = 6
;

UPDATE tienda
SET encargado = 12
WHERE id = 7
;

UPDATE tienda
SET encargado = 15
WHERE id = 8
;

UPDATE tienda
SET encargado = 13
WHERE id = 9
;

--asigné mediante actualizacion, el dato que hace referencia a la informacion medica de cada empleado

UPDATE empleado 
SET inf_medica = 2
WHERE id = 1 	     
;

UPDATE empleado 
SET inf_medica = 4
WHERE id = 2 	     
;

UPDATE empleado 
SET inf_medica = 5
WHERE id = 3 	     
;

UPDATE empleado 
SET inf_medica = 10
WHERE id = 4 	     
;

UPDATE empleado 
SET inf_medica = 11
WHERE id = 5 	     
;

UPDATE empleado 
SET inf_medica = 15
WHERE id = 6 	     
;

UPDATE empleado 
SET inf_medica = 9
WHERE id = 7 	     
;

UPDATE empleado 
SET inf_medica = 8
WHERE id = 8 	     
;

UPDATE empleado 
SET inf_medica = 6
WHERE id = 9 	     
;

UPDATE empleado 
SET inf_medica = 16
WHERE id = 10 	     
;

UPDATE empleado 
SET inf_medica = 01
WHERE id = 11 	     
;

UPDATE empleado 
SET inf_medica = 14
WHERE id = 12 	     
;

UPDATE empleado 
SET inf_medica = 12
WHERE id = 13 	     
;

UPDATE empleado 
SET inf_medica = 13
WHERE id = 14 	     
;

UPDATE empleado 
SET inf_medica = 3
WHERE id = 15 	     
;

UPDATE empleado 
SET inf_medica = 7
WHERE id = 16 	     
;

--inserté de datos de tabla producto, con valores cargados en base a obtener resultados en cada una de las consultas realizadas en el archivo DML

INSERT INTO producto (id, tienda, tipo, nombre, precio)
VALUES (DEFAULT, 1, 'Traje', 'Traje negro', 8500),
       (DEFAULT, 3, 'Tercera edad', 'Sandalias Cuero', 3000),
       (DEFAULT, 4, 'Perfume', '212 VIP', 9000),
       (DEFAULT, 2, 'Perfume', 'Aromas del arrabal', 5000),
       (DEFAULT, 3, 'Sandalias', 'El pie fresco', 4000),
       (DEFAULT, 4, 'Perfume', 'Aromas del arrabal', 3000),
       (DEFAULT, 9, 'Camisa', 'Camisa Lunares', 1500),
       (DEFAULT, 1, 'Camisa', 'Camisa Lisa', 400),
       (DEFAULT, 7, 'Sandalias', 'La separadedos', 2000),
       (DEFAULT, 7, 'Camisa', 'Camisa Lisa', 4000),
       (DEFAULT, 1, 'Corbata', 'Corbata Lunares', 3000),
       (DEFAULT, 5, 'Consola', 'Playstation 5', 120000),
       (DEFAULT, 6, 'Computadora', 'Notebook Dell', 160000),
       (DEFAULT, 2, 'Perfume', '212 VIP', 9000),
       (DEFAULT, 8, 'Traje', 'Traje', 5500),
       (DEFAULT, 9, 'Zapatilla', 'Airmax', 8500),
       (DEFAULT, 3, 'Zapatilla', 'Stefan Janoski', 11500);
       

--inserté de datos de tabla venta, con valores cargados en base a obtener resultados en cada una de las consultas realizadas en el archivo DML

INSERT INTO venta(cliente, producto, tienda, fecha, descuento)
VALUES (3, 2, 3, '05/11/2020', 25),    
       (5, 1, 1, '09/09/2020', 0),
       (3, 3, 4, '10/10/2020', 10),
       (9, 4, 2, '09/05/2020', 0),
       (4, 6, 4, '02/02/2020', 5),
       (4, 13, 6, '25/12/2020', 0),
       (1, 7, 9, '30/11/2020', 0),
       (3, 10, 7, '25/10/2020', 0),
       (10, 9, 7, '15/09/2020', 50),
       (11, 5, 3, '30/11/2020', 50),
       (12, 16, 9, '06/09/2019', 0),
       (13, 12, 5, '25/09/2020', 0),
       (11, 13, 6, '20/09/2020', 10),
       (8, 8, 1, '19/12/2020', 0),
       (4, 3, 4, '02/09/2020', 0),
       (7, 6, 4, '08/09/2019', 0),
       (2, 12, 2, '20/10/2020', 0),
       (11, 17, 3, '01/12/2019', 20)
       ;


