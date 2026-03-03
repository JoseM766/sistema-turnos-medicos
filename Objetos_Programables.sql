USE sistema_turnos_medicos;
GO

/* =====================================================
   VISTA 1 - DETALLE COMPLETO DE TURNOS
===================================================== */

CREATE VIEW vw_turnos_detalle AS
SELECT 
    t.id_turno,
    p.nombre + ' ' + p.apellido AS paciente,
    m.nombre + ' ' + m.apellido AS medico,
    e.nombre AS especialidad,
    c.descripcion AS consultorio,
    t.fecha,
    t.hora,
    et.descripcion AS estado
FROM turnos t
INNER JOIN pacientes p ON t.id_paciente = p.id_paciente
INNER JOIN medicos m ON t.id_medico = m.id_medico
INNER JOIN especialidades e ON m.id_especialidad = e.id_especialidad
INNER JOIN consultorios c ON t.id_consultorio = c.id_consultorio
INNER JOIN estado_turno et ON t.id_estado = et.id_estado;
GO


/* =====================================================
   VISTA 2 - TURNOS PENDIENTES
===================================================== */

CREATE VIEW vw_turnos_pendientes AS
SELECT *
FROM vw_turnos_detalle
WHERE estado = 'Pendiente';
GO


/* =====================================================
   FUNCION 1 - CANTIDAD DE TURNOS POR PACIENTE
===================================================== */

CREATE FUNCTION fn_cantidad_turnos_paciente (@id_paciente INT)
RETURNS INT
AS
BEGIN
    DECLARE @cantidad INT

    SELECT @cantidad = COUNT(*)
    FROM turnos
    WHERE id_paciente = @id_paciente

    RETURN @cantidad
END;
GO


/* =====================================================
   FUNCION 2 - DISPONIBILIDAD DEL MEDICO
===================================================== */

CREATE FUNCTION fn_disponibilidad_medico
(
    @id_medico INT,
    @fecha DATE,
    @hora TIME
)
RETURNS INT
AS
BEGIN
    DECLARE @existe INT

    SELECT @existe = COUNT(*)
    FROM turnos
    WHERE id_medico = @id_medico
      AND fecha = @fecha
      AND hora = @hora

    IF @existe > 0
        RETURN 1

    RETURN 0
END;
GO


/* =====================================================
   STORED PROCEDURE 1 - CREAR TURNO
===================================================== */

CREATE PROCEDURE sp_crear_turno
    @fecha DATE,
    @hora TIME,
    @id_paciente INT,
    @id_medico INT,
    @id_consultorio INT
AS
BEGIN
    INSERT INTO turnos
    (fecha, hora, id_paciente, id_medico, id_consultorio, id_estado)
    VALUES
    (@fecha, @hora, @id_paciente, @id_medico, @id_consultorio, 1) -- 1 = Pendiente
END;
GO


/* =====================================================
   STORED PROCEDURE 2 - CANCELAR TURNO
===================================================== */

CREATE PROCEDURE sp_cancelar_turno
    @id_turno INT
AS
BEGIN
    UPDATE turnos
    SET id_estado = 3 -- 3 = Cancelado
    WHERE id_turno = @id_turno
END;
GO


/* =====================================================
   TRIGGER 1 - VALIDAR SUPERPOSICION
===================================================== */

CREATE TRIGGER trg_validar_superposicion
ON turnos
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM turnos t
        INNER JOIN inserted i
            ON t.id_medico = i.id_medico
            AND t.fecha = i.fecha
            AND t.hora = i.hora
            AND t.id_turno <> i.id_turno
    )
    BEGIN
        RAISERROR ('El medico ya tiene un turno en ese horario.',16,1)
        ROLLBACK TRANSACTION
    END
END;
GO


/* =====================================================
   TRIGGER 2 - REGISTRO CAMBIO DE ESTADO
===================================================== */

CREATE TRIGGER trg_registro_cambio_estado
ON turnos
AFTER UPDATE
AS
BEGIN
    IF UPDATE(id_estado)
    BEGIN
        INSERT INTO historial_estado_turno
        (id_turno, id_estado_anterior, id_estado_nuevo)
        SELECT 
            d.id_turno,
            d.id_estado,
            i.id_estado
        FROM deleted d
        INNER JOIN inserted i
            ON d.id_turno = i.id_turno
        WHERE d.id_estado <> i.id_estado
    END
END;
GO