/*
* @file subquery.sql
* @brief script crear esquema y tablas de la BD empresa
* @author Cuesta Quintero Byron
* Grupo de Investigación en Pensamiento Computacional (GIPCO)
* @date 07/03/2024
*/

CREATE SCHEMA empresa;
--En caso de requerir borrar el esquema utilizar:
DROP SCHEMA empresa CASCADE;
--En caso de requerir borrar la tabla utilizar:
DROP TABLE IF EXISTS empresa.empleado;

CREATE TABLE empresa.empleado(
   id_emp VARCHAR(5),
   nombre VARCHAR(50),
   salario INTEGER,
   id_jefe VARCHAR(5),
   CONSTRAINT ck_nom_empleado CHECK (nombre IS NOT NULL),
   CONSTRAINT ck_salario_invalido CHECK (salario > 0),
   CONSTRAINT fk_empleado_jefe FOREIGN KEY(id_jefe) 
   REFERENCES empresa.empleado (id_emp), 
   CONSTRAINT pk_empleado PRIMARY KEY(id_emp)
 );



insert into empresa.empleado (id_emp, nombre, salario, id_jefe)
values ('E0001', 'JUAN PEREZ', 2000, 'E0002'),
('E0002', 'MARY LOPEZ', 3000, 'E0003'),
('E0003', 'ANA SAENZ', 4000, NULL),
('E0004', 'LUIS ORTEGA', NULL, NULL),
('E0005', 'ANA GOMEZ', 3000, 'E0003');

SELECT * FROM empresa.empleado

--Consulta 1.

SELECT nombre as empleado
FROM empresa.empleado
WHERE salario < 
(SELECT ROUND(AVG(salario),0) FROM empresa.empleado)

--Consulta 2.

SELECT e1.nombre as empleado
FROM empresa.empleado e1 INNER JOIN
(SELECT nombre, id_emp FROM empresa.empleado WHERE salario = 3000) e2
ON (e1.id_jefe = e2.id_emp)
ORDER BY e1.nombre DESC;

--Consulta 3.

SELECT (SELECT nombre FROM empresa.empleado WHERE id_emp = e.id_jefe) as jefe
FROM empresa.empleado e
WHERE e.salario = 
(SELECT MIN(salario) FROM empresa.empleado)

