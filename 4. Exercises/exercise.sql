/*
* @file exercise.sql
* script para crear el esquema y las tablas de BD supermercado
* @author Byron Cuesta Quintero - byroncuesta@ufpso.edu.co
* Grupo de Investigación en Pensamiento Computacional (GIPCO)
* @date 07/03/2024

*/


CREATE SCHEMA supermarket;
--En caso de requerir borrar el esquema utilizar:
DROP SCHEMA supermarket CASCADE;
--En caso de requerir borrar las tablas utilizar:
DROP TABLE IF EXISTS supermarket.detalle_pedido;
DROP TABLE IF EXISTS supermarket.pedido;
DROP TABLE IF EXISTS supermarket.cliente;
DROP TABLE IF EXISTS supermarket.producto;


CREATE TABLE supermarket.cliente(
   id_c VARCHAR(5),
   nombre VARCHAR(50),
   sexo VARCHAR(1),
   CONSTRAINT ck_nom_cliente CHECK (nombre IS NOT NULL),
   CONSTRAINT ck_sexo_cliente CHECK (sexo IS NOT NULL),
   CONSTRAINT ck_sexo_valido CHECK (sexo IN ('M','F')),
   CONSTRAINT pk_cliente PRIMARY KEY(id_c)
 );

CREATE TABLE supermarket.producto(
   ref VARCHAR(2),
   pro VARCHAR(3),
   nombre VARCHAR(40),
   uni VARCHAR(10),
   precio INTEGER,
   CONSTRAINT ck_nom_producto CHECK (nombre IS NOT NULL),
   CONSTRAINT ck_uni_producto CHECK (uni IS NOT NULL),
   CONSTRAINT ck_precio_invalido CHECK (precio > 0),
   CONSTRAINT pk_producto PRIMARY KEY(ref, pro)
 );

CREATE TABLE supermarket.pedido(
   id_ped INTEGER,
   fecha DATE,
   id_c VARCHAR(5),
   total INTEGER,
   CONSTRAINT ck_fecha_pedido CHECK (fecha IS NOT NULL),
   CONSTRAINT fk_cliente_pedido FOREIGN KEY(id_c) 
   REFERENCES supermarket.cliente (id_c), 
   CONSTRAINT pk_pedido PRIMARY KEY(id_ped)
 );


CREATE TABLE supermarket.detalle_pedido(
   id_ped INTEGER,
   ord INTEGER,
   ref VARCHAR(2),
   id_pro VARCHAR(3),
   cant INTEGER,
   vlr_unit INTEGER,
   CONSTRAINT ck_cantidad_invalida CHECK (cant > 0),
   CONSTRAINT fk_pedido_det_ped FOREIGN KEY(id_ped) 
   REFERENCES supermarket.pedido (id_ped), 
   CONSTRAINT fk_producto_det_ped FOREIGN KEY(ref, id_pro) 
   REFERENCES supermarket.producto (ref, pro), 
   CONSTRAINT pk_detalle_pedido PRIMARY KEY(id_ped, ord)
 );



insert into supermarket.cliente (id_c, nombre, sexo)
values ('C0001', 'JUAN RIZO', 'M'),
('C0002', 'ANA LOPEZ', 'F'),
('C0003', 'MARIA ZEA', 'F'),
('C0004', 'LUIS GIL', 'M'),
('C0005', 'MARIA GOEZ', 'F');

SELECT * FROM supermarket.cliente;

insert into supermarket.producto (ref, pro, nombre, uni, precio)
values ('P0', '001', 'MANGO', 'KILO', '2000'),
('P0', '002', 'PAPAYA', 'KILO', '5000'),
('P1', '003', 'HIGO', 'KILO', '5000'),
('P1', '004', 'LULO', 'KILO', '4800'),
('P0', '005', 'MANZANA', 'UNI', NULL);

SELECT * FROM supermarket.producto;

insert into supermarket.pedido (id_ped, fecha, id_c, total)
values (10449, '10/04/2022', 'C0002', 27800),
(10028, '15/01/2022', 'C0003', 14100),
(10325, '14/03/2022', NULL, NULL),
(11456, '25/02/2023', 'C0001', 4000),
(10888, '21/09/2022', 'C0004', 9600),
(11045, '08/01/2023', 'C0004', 40000),
(10732, '22/06/2022', 'C0002', 4700),
(11555, '27/04/2023', 'C0002', 5000);

SELECT * FROM supermarket.pedido;

insert into supermarket.detalle_pedido (id_ped, ord, ref, id_pro, cant, vlr_unit)
values (10449, 1, 'P0', '001', 5, 1800),
(10028, 1, 'P0', '002', 3, 4700),
(10449, 2, 'P0', '002', 4, 4700),
(11456, 1, 'P0', '001', 2, 2000),
(10888, 1, 'P1', '003', 2, 4800),
(11045, 1, 'P0', '002', 8, 5000),
(10732, 1, 'P0', '002', 1, 4700),
(11555, 1, 'P1', '003', 1, 5000);

SELECT * FROM supermarket.detalle_pedido;

/*
solutions
*/

--Ejercicio 1. Productos con mayor precio.
--Listar el nombre y el precio del producto con el precio igual al mayor precio de los productos actuales, dónde el producto se haya pedido en enero de 2022. Ordenar por el nombre del producto.

SELECT p.nombre, p.precio
FROM supermarket.producto p INNER JOIN supermarket.detalle_pedido d
ON (p.ref = d.ref)
AND (p.pro = d.id_pro)
INNER JOIN supermarket.pedido pe
ON (d.id_ped = pe.id_ped)
WHERE p.precio = (SELECT MAX(precio) FROM supermarket.producto)
AND pe.fecha BETWEEN '01/01/2022' AND '31/01/2022'
ORDER BY 1;

--Ejercicio 2.Productos pedidos por año. 
--Listar el año y la cantidad de productos pedidos por año. Ordenar en forma descendente por el año.

SELECT extract(YEAR FROM p.fecha) as año, SUM(d.cant) as cantidad
FROM supermarket.pedido p INNER JOIN supermarket.detalle_pedido d
ON (p.id_ped = d.id_ped)
GROUP BY extract(YEAR FROM p.fecha)
ORDER BY 1;

--Ejercicio 3. Pedidos con más de un producto.
--Listar los pedidos y cuántos se pidieron, si el pedido incluyó más de un producto.

SELECT id_ped, COUNT(id_ped) as cantidad
FROM supermarket.detalle_pedido
GROUP BY id_ped
HAVING COUNT(id_ped) > 1
ORDER BY 1;

--Ejercicio 4.Productos que no han sido pedidos
--Listar el nombre y la unidad de medida de los productos que nunca se han pedido. Ordenar por el nombre del producto.

SELECT nombre as producto, uni as unidad_medida
FROM supermarket.producto  
WHERE (ref,pro) NOT IN 
(SELECT ref,id_pro FROM supermarket.detalle_pedido)
ORDER BY 1;

--Ejercicio 5. Productos más pedidos.
--Listar el nombre y el total de los productos más pedidos, dónde el total de los productos pedidos sea mayor a 5. Ordenar por el total de los productos pedidos de forma descendente.

SELECT p.nombre as producto, 
(SELECT SUM(d.cant) 
FROM supermarket.detalle_pedido d 
WHERE d.ref = p.ref 
AND d.id_pro = p.pro) as cantidad
FROM supermarket.producto p
GROUP BY p.ref, p.pro 
HAVING (SELECT SUM(d.cant) 
FROM supermarket.detalle_pedido d 
WHERE d.ref = p.ref 
AND d.id_pro = p.pro) > 5
ORDER BY 2 desc

--Ejercicio 6. Productos con precio superior al precio promedio.
--Listar el nombre y precio de los productos actuales con precio superior al precio promedio de los productos pedidos en el año 2022.

SELECT nombre as producto, precio 
FROM supermarket.producto 
WHERE precio > 
(SELECT AVG(d.Vlr_unit) 
FROM supermarket.pedido p INNER JOIN supermarket.detalle_pedido d 
ON p.id_ped = d.id_ped 
WHERE p.fecha BETWEEN '01/01/2022' AND '31/12/2022')

--Ejercicio 7. Clientes y cantidad de pedidos por cliente.
--Listar el nombre de los clientes y la cantidad de pedidos, dónde la cantidad de pedidos por cliente sea mayor a la cantidad de clientes sin pedidos. Ordenar por la cantidad de pedidos de forma descendente. 

SELECT c.nombre as cliente, COUNT(p.id_ped) as cantidad 
FROM supermarket.pedido p INNER JOIN supermarket.cliente c 
ON p.id_c = c.id_c 
GROUP BY c.nombre 
HAVING COUNT(p.id_ped) > 
(SELECT COUNT(*) 
FROM supermarket.cliente c LEFT JOIN supermarket.pedido p 
ON c.id_c = p.id_c 
WHERE p.id_c IS NULL)
order by 2 desc;

--Ejercicio 8. Pedidos por mes de un año.
--Listar el mes y la cantidad de pedidos por mes del segundo semestre del año 2022, dónde la cantidad de pedidos sea menor o igual a la cantidad de pedidos del año 2023.

SELECT EXTRACT(MONTH FROM fecha) as Mes,COUNT(id_ped) as Cantidad 
FROM supermarket.pedido p 
WHERE fecha BETWEEN '01/07/2022' AND '31/12/2022' 
GROUP BY EXTRACT(MONTH FROM fecha) 
HAVING COUNT(id_ped) <= 
(SELECT COUNT(id_ped) 
FROM supermarket.pedido 
WHERE fecha BETWEEN '01/01/2023' AND '31/12/2023')

--Ejercicio 9. Subconsulta dónde se utiliza la cláusula ANY.
--Listar el nombre y el sexo de los clientes que hayan realizado pedidos de papaya.

SELECT DISTINCT nombre, sexo 
FROM supermarket.cliente 
WHERE id_c = ANY 
(SELECT p.id_c 
FROM supermarket.pedido p INNER JOIN supermarket.detalle_pedido d 
ON p.id_ped = d.id_ped 
INNER JOIN supermarket.producto pr 
ON d.ref = pr.ref 
AND d.id_pro = pr.pro 
WHERE pr.nombre = 'PAPAYA')

--Solución equivalente con la cláusula IN: 

SELECT DISTINCT nombre, sexo 
FROM supermarket.cliente 
WHERE id_c IN 
(SELECT p.id_c 
FROM supermarket.pedido p INNER JOIN supermarket.detalle_pedido d 
ON p.id_ped = d.id_ped 
INNER JOIN supermarket.producto pr 
ON d.ref = pr.ref 
AND d.id_pro = pr.Pro 
WHERE pr.nombre = 'PAPAYA')

--Ejercicio 10.Subconsulta dónde se utiliza la cláusula NOT EXISTS.
--Listar el nombre y la unidad de medida de los productos que no se han pedido a la fecha.

SELECT p.nombre as producto, p.uni as unidad_medida
FROM supermarket.producto p 
WHERE NOT EXISTS 
(SELECT ref,id_pro 
FROM supermarket.detalle_pedido d 
WHERE d.ref = p.ref 
AND d.id_pro = p.pro);

--Ejercicio 11. Subconsulta dónde se utiliza la cláusula ALL.
--Listar el nombre y el sexo de los clientes que no hayan realizado pedidos de papaya.

SELECT DISTINCT nombre, sexo 
FROM supermarket.cliente 
WHERE id_c <> ALL 
(SELECT p.id_c 
FROM supermarket.pedido p INNER JOIN supermarket.detalle_pedido d 
ON p.id_ped = d.id_ped 
INNER JOIN supermarket.producto pr 
ON d.ref = pr.ref 
AND d.id_pro = pr.pro 
WHERE pr.nombre = 'PAPAYA' 
AND p.id_c IS NOT NULL) 

--Solución equivalente con la cláusula NOT IN: 

SELECT DISTINCT nombre, sexo 
FROM supermarket.cliente 
WHERE id_c NOT IN 
(SELECT p.id_c 
FROM supermarket.pedido p INNER JOIN supermarket.detalle_pedido d 
ON p.id_ped = d.id_ped 
INNER JOIN supermarket.producto pr 
ON d.ref = pr.ref 
AND d.id_pro = pr.Pro 
WHERE pr.nombre = 'PAPAYA' 
AND p.id_c IS NOT NULL)
