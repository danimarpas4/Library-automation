/* ---------------------------------------------------------------
   DATABASE PROJECT: Library Management System
   Implementation of Normalization, Automation, and Triggers
   ---------------------------------------------------------------
*/

-- 1. INITIAL DATA SEEDING (Prior to author column removal)
-- Populating the books table while the 'autor' column is still active
INSERT INTO libros (titulo, autor, año) VALUES  
('Cien años de soledad', 'Gabriel Garcia Marquéz', 1967),
('1984', 'George Orwell', 1949),
('El principito','Antonie de Saint Exupéry',1943 ),
('Harry Potter y la piedra filosofal','J.K. Rowling',1997 ),
('La sombra del viento','Carlos Ruiz Zafón',2001); 

-- 2. SCHEMA NORMALIZATION PROCESS
-- Decoupling authors into a dedicated table to reduce data redundancy
CREATE TABLE autores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50),
    genero VARCHAR(50)
);

-- Migrating unique author names to the new reference table
INSERT INTO autores (nombre) SELECT DISTINCT autor FROM libros;

-- Integrating a foreign key column to establish a relational link
ALTER TABLE libros ADD COLUMN autor_id INT;

-- Temporary bypass of Safe Update Mode to perform data mapping
SET SQL_SAFE_UPDATES = 0;
UPDATE libros l JOIN autores a ON l.autor = a.nombre SET l.autor_id = a.id;
SET SQL_SAFE_UPDATES = 1;

-- Enforcing referential integrity and removing deprecated columns
ALTER TABLE libros ADD FOREIGN KEY (autor_id) REFERENCES autores(id);
ALTER TABLE libros DROP COLUMN autor; -- Safe deletion after successful migration

-- 3. EXPANDING THE CATALOG: NEW ENTRIES
-- Registering a new author and retrieving the generated ID for relational consistency
INSERT INTO autores (nombre, nacionalidad, genero) VALUES 
('Isabel Allende', 'Chilena', 'Femenino');

-- Assigning the newly created ID to a session variable to avoid hardcoding errors
SET @isabel_id = (SELECT id FROM autores WHERE nombre = 'Isabel Allende');

INSERT INTO libros (titulo, año, disponible, autor_id) VALUES 
('La casa de los espíritus', 1982, TRUE, @isabel_id),
('Largo pétalo de mar', 2019, TRUE, @isabel_id);

-- 4. ANALYTICAL REPORTING
-- Retrieving book titles and author origins using an INNER JOIN
SELECT 
    l.titulo AS Libro, 
    a.nombre AS Autor, 
    a.nacionalidad AS Origen
FROM libros l
JOIN autores a ON l.autor_id = a.id
WHERE a.nombre LIKE '%Allende%';

-- 5. BUSINESS LOGIC AUTOMATION (TRIGGERS)
-- Automating book availability updates upon loan issuance

DELIMITER //

CREATE TRIGGER tr_update_availability_on_loan
AFTER INSERT ON prestamos
FOR EACH ROW
BEGIN
    UPDATE libros 
    SET disponible = FALSE 
    WHERE id = NEW.libro_id;
END //

DELIMITER ;

-- Restoring book availability upon successful return entry

DELIMITER //

CREATE TRIGGER tr_update_availability_on_return
AFTER UPDATE ON prestamos
FOR EACH ROW
BEGIN
    -- Condition: Triggered only when the return date transitions from NULL to a value
    IF NEW.fecha_devolucion IS NOT NULL AND OLD.fecha_devolucion IS NULL THEN
        UPDATE libros 
        SET disponible = TRUE 
        WHERE id = NEW.libro_id;
    END IF;
END //

DELIMITER ;

-- 6. SYSTEM VALIDATION
-- Testing automated loan logic and reviewing updated inventory status
INSERT INTO prestamos (libro_id, usuario_id) VALUES (2, 3);
INSERT INTO prestamos (libro_id, usuario_id) VALUES (4, 3);

SELECT * FROM libros;