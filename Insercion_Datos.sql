USE sistema_turnos_medicos;
GO

/* =====================================================
   INSERT ESPECIALIDADES
===================================================== */

INSERT INTO especialidades (nombre)
VALUES 
('Clinica Medica'),
('Pediatria'),
('Cardiologia');
GO


/* =====================================================
   INSERT PACIENTES
===================================================== */

INSERT INTO pacientes (nombre, apellido, dni, telefono, email)
VALUES
('Juan', 'Perez', '12345678', '11223344', 'juan@email.com'),
('Ana', 'Gomez', '87654321', '11998877', 'ana@email.com'),
('Luis', 'Martinez', '45678912', '11334455', 'luis@email.com');
GO


/* =====================================================
   INSERT MEDICOS
===================================================== */

INSERT INTO medicos (nombre, apellido, id_especialidad)
VALUES
('Carlos', 'Lopez', 1),
('Maria', 'Fernandez', 2),
('Roberto', 'Diaz', 3);
GO


/* =====================================================
   INSERT CONSULTORIOS
===================================================== */

INSERT INTO consultorios (descripcion)
VALUES
('Consultorio 1'),
('Consultorio 2'),
('Consultorio 3');
GO


/* =====================================================
   INSERT ESTADOS DE TURNO
===================================================== */

INSERT INTO estado_turno (descripcion)
VALUES
('Pendiente'),   -- 1
('Confirmado'),  -- 2
('Cancelado'),   -- 3
('Atendido');    -- 4
GO


/* =====================================================
   INSERT TURNOS DE PRUEBA
===================================================== */

INSERT INTO turnos (fecha, hora, id_paciente, id_medico, id_consultorio, id_estado)
VALUES
('2026-06-10', '10:00', 1, 1, 1, 1),
('2026-06-10', '11:00', 2, 2, 2, 2),
('2026-06-11', '09:30', 3, 3, 3, 1);
GO