/* =======================================================
   CREACION BASE DE DATOS
======================================================= */

CREATE DATABASE sistema_turnos_medicos;
GO

USE sistema_turnos_medicos;
GO


/* =======================================================
   TABLA ESPECIALIDADES
======================================================= */

CREATE TABLE especialidades (
    id_especialidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);
GO


/* =======================================================
   TABLA PACIENTES
======================================================= */

CREATE TABLE pacientes (
    id_paciente INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    dni VARCHAR(15) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(100)
);
GO


/* =======================================================
   TABLA MEDICOS
======================================================= */

CREATE TABLE medicos (
    id_medico INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    id_especialidad INT NOT NULL,
    CONSTRAINT fk_medico_especialidad
        FOREIGN KEY (id_especialidad)
        REFERENCES especialidades(id_especialidad)
);
GO


/* =======================================================
   TABLA CONSULTORIOS
======================================================= */

CREATE TABLE consultorios (
    id_consultorio INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO


/* =======================================================
   TABLA ESTADO_TURNO
======================================================= */

CREATE TABLE estado_turno (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(30) NOT NULL
);
GO


/* =======================================================
   TABLA TURNOS
======================================================= */

CREATE TABLE turnos (
    id_turno INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    id_consultorio INT NOT NULL,
    id_estado INT NOT NULL,

    CONSTRAINT fk_turno_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES pacientes(id_paciente),

    CONSTRAINT fk_turno_medico
        FOREIGN KEY (id_medico)
        REFERENCES medicos(id_medico),

    CONSTRAINT fk_turno_consultorio
        FOREIGN KEY (id_consultorio)
        REFERENCES consultorios(id_consultorio),

    CONSTRAINT fk_turno_estado
        FOREIGN KEY (id_estado)
        REFERENCES estado_turno(id_estado)
);
GO


/* =======================================================
   TABLA HISTORIAL_ESTADO_TURNO
   (Para registrar cambios de estado - mejora profesional)
======================================================= */

CREATE TABLE historial_estado_turno (
    id_historial INT IDENTITY(1,1) PRIMARY KEY,
    id_turno INT NOT NULL,
    id_estado_anterior INT,
    id_estado_nuevo INT NOT NULL,
    fecha_cambio DATETIME DEFAULT GETDATE(),

    CONSTRAINT fk_historial_turno
        FOREIGN KEY (id_turno)
        REFERENCES turnos(id_turno)
);
GO





USE sistema_turnos_medicos;
GO

/* =====================================================
   TABLA OBRA SOCIAL
===================================================== */

CREATE TABLE obra_social (
    id_obra_social INT IDENTITY PRIMARY KEY,
    nombre VARCHAR(100)
);
GO


/* =====================================================
   TABLA PACIENTE_OBRA_SOCIAL
===================================================== */

CREATE TABLE paciente_obra_social (
    id INT IDENTITY PRIMARY KEY,
    id_paciente INT,
    id_obra_social INT,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_obra_social) REFERENCES obra_social(id_obra_social)
);
GO


/* =====================================================
   TABLA HORARIOS MEDICO
===================================================== */

CREATE TABLE horarios_medico (
    id_horario INT IDENTITY PRIMARY KEY,
    id_medico INT,
    dia_semana VARCHAR(20),
    hora_inicio TIME,
    hora_fin TIME,
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);
GO


/* =====================================================
   TABLA PAGOS
===================================================== */

CREATE TABLE pagos (
    id_pago INT IDENTITY PRIMARY KEY,
    id_turno INT,
    monto DECIMAL(10,2),
    fecha_pago DATE,
    FOREIGN KEY (id_turno) REFERENCES turnos(id_turno)
);
GO


/* =====================================================
   TABLA ROLES
===================================================== */

CREATE TABLE roles (
    id_rol INT IDENTITY PRIMARY KEY,
    nombre VARCHAR(50)
);
GO


/* =====================================================
   TABLA USUARIOS
===================================================== */

CREATE TABLE usuarios (
    id_usuario INT IDENTITY PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(100)
);
GO


/* =====================================================
   TABLA USUARIO_ROL
===================================================== */

CREATE TABLE usuario_rol (
    id INT IDENTITY PRIMARY KEY,
    id_usuario INT,
    id_rol INT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);
GO