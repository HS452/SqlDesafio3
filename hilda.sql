-- CREANDO LA BASE DE DATOS 
--entramos PgAdmin4, 
--seleccionamos en las pestañas del menu donde dice 
--"Objects" luego en "Create" y en "Database" 
-- desplega un cuadro donde especificamos el nombre de la data;
-- lo escribimos y presionamos guardar. 
--En nuestro caso usamos este 
desafio3_Hilda_Hernandez_452;


--Dentro de la base de datos creada, procedemos a Crear la Tabla Usuarios
CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    rol VARCHAR(50) NOT NULL
);

-- Insertar datos en la tabla Usuarios
INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES
('admin@example.com', 'Admin', 'User', 'administrador'),
('user1@example.com', 'User1', 'LastName1', 'usuario'),
('user2@example.com', 'User2', 'LastName2', 'usuario'),
('user3@example.com', 'User3', 'LastName3', 'usuario'),
('user4@example.com', 'User4', 'LastName4', 'usuario');

-- Crear la tabla Posts
CREATE TABLE Posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN NOT NULL,
    usuario_id BIGINT REFERENCES Usuarios(id)
);

-- Insertar datos en la tabla Posts
INSERT INTO Posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Post 1', 'Contenido del Post 1', '2024-01-01 10:00:00', '2024-01-01 11:00:00', true, 1),
('Post 2', 'Contenido del Post 2', '2024-01-02 10:00:00', '2024-01-02 11:00:00', false, 1),
('Post 3', 'Contenido del Post 3', '2024-01-03 10:00:00', '2024-01-03 11:00:00', true, 2),
('Post 4', 'Contenido del Post 4', '2024-01-04 10:00:00', '2024-01-04 11:00:00', false, 3),
('Post 5', 'Contenido del Post 5', '2024-01-05 10:00:00', '2024-01-05 11:00:00', true, NULL);

-- Crear la tabla Comentarios
CREATE TABLE Comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    usuario_id BIGINT REFERENCES Usuarios(id),
    post_id BIGINT REFERENCES Posts(id)
);

-- Insertar datos en la tabla Comentarios
INSERT INTO Comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Comentario 1', '2024-01-06 10:00:00', 1, 1),
('Comentario 2', '2024-01-06 10:05:00', 2, 1),
('Comentario 3', '2024-01-06 10:10:00', 3, 1),
('Comentario 4', '2024-01-07 10:00:00', 1, 2),
('Comentario 5', '2024-01-07 10:05:00', 2, 2);

-- Consultas del desafio

-- 1. Cruzar los datos de la tabla Usuarios y Posts
SELECT u.nombre, u.email, p.titulo, p.contenido
FROM Usuarios u
JOIN Posts p ON u.id = p.usuario_id;

-- 2. Mostrar posts de los administradores
SELECT p.id, p.titulo, p.contenido
FROM Posts p
JOIN Usuarios u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';

-- 3. Contar la cantidad de posts de cada usuario
SELECT u.id, u.email, COUNT(p.id) AS cantidad_posts
FROM Usuarios u
LEFT JOIN Posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

-- 4. Mostrar el email del usuario que ha creado más posts
SELECT u.email
FROM Usuarios u
JOIN Posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

-- 5. Mostrar la fecha del último post de cada usuario
SELECT u.nombre, u.email, MAX(p.fecha_creacion) AS ultima_fecha_post
FROM Usuarios u
JOIN Posts p ON u.id = p.usuario_id
GROUP BY u.nombre, u.email;

-- 6. Mostrar el post con más comentarios
SELECT p.titulo, p.contenido
FROM Posts p
JOIN Comentarios c ON p.id = c.post_id
GROUP BY p.id
ORDER BY COUNT(c.id) DESC
LIMIT 1;

-- 7. Mostrar el título, contenido del post y contenido del comentario con email del usuario
SELECT p.titulo, p.contenido AS post_contenido, c.contenido AS comentario_contenido, u.email
FROM Posts p
JOIN Comentarios c ON p.id = c.post_id
JOIN Usuarios u ON c.usuario_id = u.id;

-- 8. Mostrar el contenido del último comentario de cada usuario
SELECT u.nombre, u.email, c.contenido AS ultimo_comentario
FROM Usuarios u
JOIN Comentarios c ON u.id = c.usuario_id
WHERE c.fecha_creacion = (
    SELECT MAX(fecha_creacion) 
    FROM Comentarios 
    WHERE usuario_id = u.id
);

-- 9. Mostrar los emails de los usuarios que no han escrito ningún comentario
SELECT u.email
FROM Usuarios u
LEFT JOIN Comentarios c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;
