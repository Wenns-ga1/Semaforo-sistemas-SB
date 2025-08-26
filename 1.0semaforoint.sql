-- Eliminar tablas si existen (en orden para evitar conflictos por FK)
DROP TABLE IF EXISTS Registro_Estacionamiento CASCADE;
DROP TABLE IF EXISTS Estacionamiento CASCADE;
DROP TABLE IF EXISTS Movimiento_Vehicular CASCADE;
DROP TABLE IF EXISTS Vehiculo_Servicio CASCADE;
DROP TABLE IF EXISTS Prioridad_Trafico CASCADE;
DROP TABLE IF EXISTS Evento_Trafico CASCADE;
DROP TABLE IF EXISTS Lectura_Sensor CASCADE;
DROP TABLE IF EXISTS Sensor CASCADE;
DROP TABLE IF EXISTS Sonido CASCADE;
DROP TABLE IF EXISTS Semaforo CASCADE;
DROP TABLE IF EXISTS Interseccion CASCADE;

-- Tabla de intersecciones
CREATE TABLE Interseccion (
    interseccion_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    ubicacion TEXT,
    descripcion TEXT
);

-- Semáforos con soporte de sonido y cruce LED
CREATE TABLE Semaforo (
    semaforo_id SERIAL PRIMARY KEY,
    interseccion_id INT REFERENCES Interseccion(interseccion_id),
    tipo VARCHAR(20), -- 'vehicular', 'peatonal', 'ciclista'
    estado_actual VARCHAR(10), -- 'rojo', 'amarillo', 'verde'
    hora_actualizacion TIMESTAMP,
    tiene_sonido BOOLEAN DEFAULT FALSE,
    tiene_led_cruce BOOLEAN DEFAULT FALSE
);

-- Tabla para representar los tipos de sonidos
CREATE TABLE Sonido (
    sonido_id SERIAL PRIMARY KEY,
    semaforo_id INT REFERENCES Semaforo(semaforo_id),
    tipo_sonido INT CHECK (tipo_sonido IN (1, 2, 3)), -- 1: rojo, 2: verde, 3: cruce peatonal
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    ultima_activacion TIMESTAMP
);

-- Sensores de semáforo
CREATE TABLE Sensor (
    sensor_id SERIAL PRIMARY KEY,
    tipo_sensor VARCHAR(30), -- 'cámara', 'presión', 'magnético', 'cruce_led'
    semaforo_id INT REFERENCES Semaforo(semaforo_id),
    descripcion TEXT
);

-- Lecturas que generan los sensores
CREATE TABLE Lectura_Sensor (
    lectura_id SERIAL PRIMARY KEY,
    sensor_id INT REFERENCES Sensor(sensor_id),
    fecha_hora TIMESTAMP,
    valor_detectado TEXT
);

-- Eventos de tráfico detectados
CREATE TABLE Evento_Trafico (
    evento_id SERIAL PRIMARY KEY,
    interseccion_id INT REFERENCES Interseccion(interseccion_id),
    tipo_evento VARCHAR(50),
    fecha_hora TIMESTAMP,
    descripcion TEXT
);

-- Prioridad de usuarios
CREATE TABLE Prioridad_Trafico (
    prioridad_id SERIAL PRIMARY KEY,
    tipo_usuario VARCHAR(30),
    semaforo_id INT REFERENCES Semaforo(semaforo_id),
    prioridad_nivel INT CHECK (prioridad_nivel BETWEEN 1 AND 5),
    activa BOOLEAN DEFAULT TRUE
);

-- Vehículos de emergencia o servicio
CREATE TABLE Vehiculo_Servicio (
    vehiculo_id SERIAL PRIMARY KEY,
    tipo_servicio VARCHAR(30),
    placa VARCHAR(15),
    descripcion TEXT
);

-- Movimientos vehiculares detectados
CREATE TABLE Movimiento_Vehicular (
    movimiento_id SERIAL PRIMARY KEY,
    interseccion_id INT REFERENCES Interseccion(interseccion_id),
    vehiculo_id INT REFERENCES Vehiculo_Servicio(vehiculo_id),
    fecha_hora TIMESTAMP,
    direccion VARCHAR(10),
    velocidad NUMERIC,
    infraccion BOOLEAN DEFAULT FALSE
);

-- Espacios de estacionamiento
CREATE TABLE Estacionamiento (
    estacionamiento_id SERIAL PRIMARY KEY,
    ubicacion TEXT,
    capacidad_total INT,
    capacidad_actual INT,
    tipo VARCHAR(20)
);

-- Registro de entradas/salidas al estacionamiento
CREATE TABLE Registro_Estacionamiento (
    registro_id SERIAL PRIMARY KEY,
    estacionamiento_id INT REFERENCES Estacionamiento(estacionamiento_id),
    fecha_hora TIMESTAMP,
    evento VARCHAR(10),
    tipo_vehiculo VARCHAR(20)
);
