/*
* @file aggregate.sql
* @brief script crear esquema y tablas de la BD tienda
* @author Cuesta Quintero Byron
* Grupo de Investigación en Pensamiento Computacional (GIPCO)
* @date 07/03/2024
*/

CREATE SCHEMA tienda;
-- En caso de requerir borrar el esquema utilizar:
DROP SCHEMA tienda CASCADE;
-- En caso de requerir borrar la tabla utilizar:
DROP TABLE IF EXISTS tienda.producto;

CREATE TABLE tienda.producto(
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
 
insert into tienda.producto (ref, pro, nombre, uni, precio)
values ('P0', '001', 'MANGO', 'KILO', '2000'),
('P0', '002', 'PAPAYA', 'KILO', '5000'),
('P1', '003', 'HIGO', 'KILO', '5000'),
('P1', '004', 'LULO', 'KILO', '4800'),
('P0', '005', 'MANZANA', 'UNI', NULL);

select * from tienda.producto;

/*
solutions
*/

/*
Count()
*/


--Consulta 1.
SELECT count(*)
FROM tienda.producto 

--Consulta 2.

SELECT count(precio)
FROM tienda.producto 

--Consulta 3.

SELECT count(DISTINCT precio)
FROM tienda.producto 

/*
Min()
*/

--Consulta 1.

SELECT min(precio)
FROM tienda.producto

--Consulta 2.

SELECT min(DISTINCT precio)
FROM tienda.producto 

--Consulta 3.

SELECT min(precio)
FROM tienda.producto 
WHERE nombre LIKE 'P%'

/*
Max()
*/

--Consulta 1.

SELECT max(precio)
FROM tienda.producto

--Consulta 2.

SELECT max(DISTINCT precio)
FROM tienda.producto 

--Consulta 3.

SELECT max(precio)
FROM tienda.producto 
WHERE nombre LIKE 'P%'

/*
Sum()
*/

--Consulta 1.

SELECT sum(precio)
FROM tienda.producto

--Consulta 2.

SELECT sum(DISTINCT precio)
FROM tienda.producto 

--Consulta 3.

SELECT sum(precio)
FROM tienda.producto 
WHERE nombre LIKE 'P%'

/*
Avg()
*/

--Consulta 1.

SELECT ROUND(AVG(precio),0) as promedio
FROM tienda.producto

--Consulta 2.

SELECT ROUND(avg(DISTINCT precio),1) as promedio
FROM tienda.producto 

--Consulta 3.

SELECT ROUND(avg(precio),0) as promedio
FROM tienda.producto 
WHERE nombre LIKE 'P%'

/*
Group by
*/

--Consulta 1.

SELECT ref as referencia, SUM(precio) as total
FROM tienda.producto 
GROUP BY ref
ORDER BY SUM(precio) DESC

/*
Having
*/

--Consulta 1.

SELECT ref as referencia, SUM(precio) as total
FROM tienda.producto 
GROUP BY ref
HAVING SUM(precio) >= 7000
ORDER BY SUM(precio) DESC

