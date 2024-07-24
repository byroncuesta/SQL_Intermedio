/*
* @file joins.sql
* @brief script crear esquema y tablas de la BD escuela
* @author Cuesta Quintero Byron
* Grupo de Investigación en Pensamiento Computacional (GIPCO)
* @date 07/03/2024
*/

CREATE SCHEMA escuela;
-- En caso de requerir borrar el esquema utilizar:
DROP SCHEMA escuela CASCADE;
-- En caso de requerir borrar las tablas utilizar:
DROP TABLE IF EXISTS escuela.estudiante;
DROP TABLE IF EXISTS escuela.curso;

CREATE TABLE escuela.curso
(curso varchar(2),
nombre varchar(40),
constraint nn_nombre_curso check (nombre is not null),
constraint pk_curso primary key (curso)
);

CREATE TABLE escuela.estudiante
(codigo varchar(4),
nombre varchar(80),
genero char (1),
curso varchar(2),
constraint nn_nombre_estudiante check (nombre is not null),
constraint ck_genero_estudiante check (genero in ('M','F')),
constraint pk_estudiante  primary key (codigo)
);

insert into escuela.curso (curso, nombre)
values ('01', 'PRIMERO' ),
('02', 'SEGUNDO'),
('03', 'TERCERO'),
('04', 'CUARTO'),
('05', 'QUINTO');

insert into escuela.estudiante (codigo, nombre, genero, curso)
values ('1010', 'CLARA JAIME','F', '01'),
('1011', 'ADA ALVAREZ','F', '02'),
('1012', 'DANIEL REYES','M', '03'),
('1013', 'ELISA QUINTERO','F', '01'),
('1014', 'PATRICIA PINTO','F', NULL);

select * from escuela.estudiante;
select * from escuela.curso;

/*
Solutions
*/

--Inner join
--Listar el nombre de todos los estudiantes y el nombre del curso en el que está matriculado cada uno de ellos, utilizando un INNER JOIN.

SELECT e.nombre as estudiante, c.nombre as curso
FROM escuela.estudiante e
INNER JOIN escuela.curso c
ON (e.curso = c.curso);

--Left join
--listar el nombre de todos los estudiantes y el nombre del curso en el que está matriculado cada uno de ellos, utilizando un LEFT JOIN.


SELECT e.nombre as estudiante, c.nombre as curso
FROM escuela.estudiante e
LEFT JOIN escuela.curso c
ON (e.curso = c.curso);

--Left join con exclusion
--Listar el nombre de todos los estudiantes y el nombre del curso en el que está matriculado cada uno de ellos, utilizando un LEFT JOIN con exclusión.

SELECT e.nombre as estudiante, c.nombre as curso
FROM escuela.estudiante e
LEFT JOIN escuela.curso c
ON (e.curso = c.curso)
WHERE c.curso IS NULL;

--Right join
--Listar el nombre de todos los estudiantes y el nombre del curso en el que está matriculado cada uno de ellos, utilizando un RIGHT JOIN. 

SELECT e.nombre as estudiante, c.nombre as curso
FROM escuela.estudiante e
RIGHT JOIN escuela.curso c
ON (e.curso = c.curso);

--Right join con exclusion
--Listar el nombre de todos los estudiantes y el nombre del curso en el que está matriculado cada uno de ellos, utilizando un RIGHT JOIN con exclusión. 


SELECT e.nombre as estudiante, c.nombre as curso
FROM escuela.estudiante e
RIGHT JOIN escuela.curso c
ON (e.curso = c.curso)
WHERE e.curso IS NULL;

--Full Join
--Listar el nombre de todos los estudiantes y el nombre del curso en el que está matriculado cada uno de ellos, utilizando un FULL JOIN. 

SELECT e.nombre as estudiante, c.nombre as curso
FROM escuela.estudiante e
FULL JOIN escuela.curso c
ON (e.curso = c.curso);

--Full Join con exclusion
--Listar el nombre de todos los estudiantes y el nombre del curso en el que está matriculado cada uno de ellos, utilizando un FULL JOIN con exclusión. 


SELECT e.nombre as estudiante, c.nombre as curso
FROM escuela.estudiante e
FULL JOIN escuela.curso c
ON (e.curso = c.curso)
WHERE e.curso IS NULL
OR c.curso IS NULL;

