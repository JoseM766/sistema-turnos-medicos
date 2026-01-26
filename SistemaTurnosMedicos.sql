-- =========================================
-- LaA creaion de la base de datos
-- =========================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'sistema_turnos_medicos')
BEGIN
    CREATE DATABASE sistema_turnos_medicos;
END
GO

USE sistema_turnos_medicos;
GO

-- =========================================
-- Tbla pacientes
-- =========================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'pacientes')
BEGIN
    CREATE TABLE pacientes (
        id_paciente INT IDENTITY(1,1) PRIMARY KEY,
        nombre VARCHAR(50),
        apellido VARCHAR(50),
        dni VARCHAR(15) UNIQUE,
        telefono VARCHAR(20),
        email VARCHAR(100)
    );
END
GO

-- =========================================
-- Tabla especialidades
-- =========================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'especialidades')
BEGIN
    CREATE TABLE especialidades (
        id_especialidad INT IDENTITY(1,1) PRIMARY KEY,
        nombre VARCHAR(50)
    );
END
GO

-- =========================================
-- Tabla Medicso
-- =========================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'medicos')
BEGIN
    CREATE TABLE medicos (
        id_medico INT IDENTITY(1,1) PRIMARY KEY,
        nombre VARCHAR(50),
        apellido VARCHAR(50),
        id_especialidad INT,
        CONSTRAINT fk_medico_especialidad
            FOREIGN KEY (id_especialidad)
            REFERENCES especialidades(id_especialidad)
    );
END
GO

-- =========================================
-- Tabla consultorios
-- =========================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'consultorios')
BEGIN
    CREATE TABLE consultorios (
        id_consultorio INT IDENTITY(1,1) PRIMARY KEY,
        descripcion VARCHAR(50)
    );
END
GO

-- =========================================
-- Tabla de estado turno
-- =========================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'estado_turno')
BEGIN
    CREATE TABLE estado_turno (
        id_estado INT IDENTITY(1,1) PRIMARY KEY,
        descripcion VARCHAR(30)
    );
END
GO

-- =========================================
-- Tabla  de turnos
-- =========================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'turnos')
BEGIN
    CREATE TABLE turnos (
        id_turno INT IDENTITY(1,1) PRIMARY KEY,
        fecha DATE,
        hora TIME,
        id_paciente INT,
        id_medico INT,
        id_consultorio INT,
        id_estado INT,
        CONSTRAINT fk_turno_paciente
            FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
        CONSTRAINT fk_turno_medico
            FOREIGN KEY (id_medico) REFERENCES medicos(id_medico),
        CONSTRAINT fk_turno_consultorio
            FOREIGN KEY (id_consultorio) REFERENCES consultorios(id_consultorio),
        CONSTRAINT fk_turno_estado
            FOREIGN KEY (id_estado) REFERENCES estado_turno(id_estado)
    );
END
GO
