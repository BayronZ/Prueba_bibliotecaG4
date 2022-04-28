\c mrcoco
DROP DATABASE biblioteca;
CREATE DATABASE biblioteca;
\c biblioteca

CREATE TABLE autor (
    autor_id INT NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento INT NOT NULL,
    fecha_muerte INT,
    tipo_autor VARCHAR NOT NULL,
    PRIMARY KEY (autor_id)
);

CREATE TABLE libro(
    isbn VARCHAR NOT NULL UNIQUE,
    titulo VARCHAR(50) NOT NULL,
    numero_paginas INT NOT NULL,
    codigo_autor INT NOT NULL,
    codigo_coautor INT,
    PRIMARY KEY (isbn),
    FOREIGN KEY (codigo_autor) REFERENCES autor(autor_id),
    FOREIGN KEY (codigo_coautor) REFERENCES autor(autor_id)
);

CREATE TABLE socio(
    rut VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono INT NOT NULL,
    PRIMARY KEY (rut)
);

CREATE TABLE prestamo(
    id INT NOT NULL,
    isbn_libro VARCHAR NOT NULL,
    rut_socio VARCHAR(10) NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (isbn_libro) REFERENCES libro(isbn),
    FOREIGN KEY (rut_socio) REFERENCES socio (rut)
);

-- Ingresar autores
INSERT INTO autor(autor_id,nombre,apellido,fecha_nacimiento,fecha_muerte,tipo_autor)
VALUES (3,'JOSE','SALGADO',1968,2020,'PRINCIPAL');
INSERT INTO autor(autor_id,nombre,apellido,fecha_nacimiento,tipo_autor)
VALUES (4,'ANA','SALGADO',1972,'COAUTOR');
INSERT INTO autor(autor_id,nombre,apellido,fecha_nacimiento,tipo_autor)
VALUES (1,'ANDRÉS','ULLOA',1982,'PRINCIPAL');
INSERT INTO autor(autor_id,nombre,apellido,fecha_nacimiento,fecha_muerte,tipo_autor)
VALUES (2,'SERGIO','MARDONES',1950,2012,'PRINCIPAL');
INSERT INTO autor(autor_id,nombre,apellido,fecha_nacimiento,tipo_autor)
VALUES (5,'MARTIN','PORTA',1976,'PRINCIPAL');

-- ingresar libros
INSERT INTO libro(ISBN,titulo,numero_paginas,codigo_autor,codigo_coautor)
VALUES ('111-1111111-111','CUENTOS DE TERROR',344,3,4);
INSERT INTO libro(ISBN,titulo,numero_paginas,codigo_autor)
VALUES ('222-2222222-222','POSEÍAS CONTEMPORANEAS',167,1);
INSERT INTO libro(ISBN,titulo,numero_paginas,codigo_autor)
VALUES ('333-3333333-333','HISTORIA DE ASIA',511,2);
INSERT INTO libro(ISBN,titulo,numero_paginas,codigo_autor)
VALUES ('444-4444444-444','MANUAL DE MECÁNICA',298,5);

-- ingresar socios
INSERT INTO socio(rut,nombre,apellido,direccion,telefono)
VALUES ('1111111-1','JUAN','SOTO','AVENIDA 1, SANTIAGO',911111111);
INSERT INTO socio(rut,nombre,apellido,direccion,telefono)
VALUES ('2222222-2','ANA','PÉREZ','PASAJE 2, SANTIAGO',922222222);
INSERT INTO socio(rut,nombre,apellido,direccion,telefono)
VALUES ('3333333-3','SANDRA','AGUILAR','AVENIDA 2, SANTIAGO',933333333);
INSERT INTO socio(rut,nombre,apellido,direccion,telefono)
VALUES ('4444444-4','ESTEBAN','JEREZ','AVENIDA 3, SANTIAGO',944444444);
INSERT INTO socio(rut,nombre,apellido,direccion,telefono)
VALUES ('5555555-5','SILVADA','MUÑOZ','PASAJE 3, SANTIAGO',955555555);

-- ingresar prestamos
INSERT INTO prestamo(id,isbn_libro,rut_socio,fecha_prestamo,fecha_devolucion)
VALUES (1,(SELECT isbn FROM libro WHERE isbn = '111-1111111-111'),(SELECT rut FROM socio WHERE rut = '1111111-1'),'2020-01-20','2020-01-27');
INSERT INTO prestamo(id,isbn_libro,rut_socio,fecha_prestamo,fecha_devolucion)
VALUES (2,(SELECT isbn FROM libro WHERE isbn = '222-2222222-222'),(SELECT rut FROM socio WHERE rut = '5555555-5'),'2020-01-20','2020-01-30');
INSERT INTO prestamo(id,isbn_libro,rut_socio,fecha_prestamo,fecha_devolucion)
VALUES (3,(SELECT isbn FROM libro WHERE isbn = '333-3333333-333'),(SELECT rut FROM socio WHERE rut = '3333333-3'),'2020-01-22','2020-01-30');
INSERT INTO prestamo(id,isbn_libro,rut_socio,fecha_prestamo,fecha_devolucion)
VALUES (4,(SELECT isbn FROM libro WHERE isbn = '444-4444444-444'),(SELECT rut FROM socio WHERE rut = '4444444-4'),'2020-01-23','2020-01-30');
INSERT INTO prestamo(id,isbn_libro,rut_socio,fecha_prestamo,fecha_devolucion)
VALUES (5,(SELECT isbn FROM libro WHERE isbn = '111-1111111-111'),(SELECT rut FROM socio WHERE rut = '2222222-2'),'2020-01-27','2020-02-04');
INSERT INTO prestamo(id,isbn_libro,rut_socio,fecha_prestamo,fecha_devolucion)
VALUES (6,(SELECT isbn FROM libro WHERE isbn = '444-4444444-444'),(SELECT rut FROM socio WHERE rut = '1111111-1'),'2020-01-31','2020-02-12');
INSERT INTO prestamo(id,isbn_libro,rut_socio,fecha_prestamo,fecha_devolucion)
VALUES (7,(SELECT isbn FROM libro WHERE isbn = '222-2222222-222'),(SELECT rut FROM socio WHERE rut = '3333333-3'),'2020-01-31','2020-02-12');

-- a. Mostrar todos los libros que posean menos de 300 páginas
SELECT * FROM libro WHERE numero_paginas < 300;

--b. Mostrar todos los autores que hayan nacido después del 01-01-1970
SELECT * FROM autor WHERE fecha_nacimiento >= 1970;

SELECT * FROM prestamo;
--c. ¿Cuál es el libro más solicitado?
SELECT libro.isbn, libro.titulo, 
COUNT(*) AS cantidad
FROM prestamo INNER JOIN libro on libro.isbn = isbn_libro
GROUP BY libro.isbn, libro.titulo
ORDER BY COUNT(libro.isbn)
DESC LIMIT 3;

-- d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto
-- debería pagar cada usuario que entregue el préstamo después de 7 días.
-- SELECT fecha_prestamo, fecha_devolucion FROM prestamos