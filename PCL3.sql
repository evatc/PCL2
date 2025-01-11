--Ejercicio 1
DELETE FROM vehiculofinal
WHERE vehicle_id IS NULL OR length(vehicle_id) < 10 OR vehicle_id='';

DELETE FROM collision_vehicles_final
WHERE vehicle_id IS NULL OR length(vehicle_id) < 10 OR vehicle_id='';

DELETE FROM collision_persons_final
WHERE vehicle_id IS NULL OR length(vehicle_id) < 10 OR vehicle_id='';

--Ejercicio 2
DELETE FROM personafinal
WHERE person_id IS NULL OR length(person_id) < 10 OR person_id='';

DELETE FROM collision_persons_final
WHERE person_id IS NULL OR length(person_id) < 10 OR person_id='';

--Ejercicio 3
UPDATE vehiculofinal
SET state_registration = collision_vehicles_final.state_registration
FROM collision_vehicles_final
WHERE vehiculofinal.vehicle_id = collision_vehicles_final.vehicle_id;

ALTER TABLE collision_vehicles_final
DROP COLUMN state_registration;

--Ejercicio 4
UPDATE vehiculofinal
SET vehicle_type = 'unknown'
WHERE vehicle_type IS NULL OR vehicle_type='';

UPDATE vehiculofinal
SET vehicle_make = 'unknown'
WHERE vehicle_make IS NULL OR vehicle_make='';

UPDATE vehiculofinal
SET vehicle_model = 'unknown'
WHERE vehicle_model IS NULL OR vehicle_model='';

UPDATE vehiculofinal
SET vehicle_year = '9999'
WHERE vehicle_year IS NULL OR vehicle_year='';

UPDATE vehiculofinal
SET state_registration = 'unknown'
WHERE state_registration IS NULL OR state_registration='';

--Ejercicio 5
UPDATE personafinal
SET person_sex = collision_persons_final.person_sex
FROM collision_persons_final
WHERE personafinal.person_id= collision_persons_final.person_id;

ALTER TABLE final.collision_persons_final
DROP COLUMN person_sex;

UPDATE personafinal
SET person_sex = 'U'
WHERE person_sex IS NULL OR person_sex='';

--Ejercicio 6
-- Agregar la columna person_age (si aún no se ha agregado)
ALTER TABLE personafinal
ADD COLUMN person_age INTEGER;

-- Crear la función del trigger
CREATE OR REPLACE FUNCTION set_person_age()
RETURNS TRIGGER AS $$
BEGIN
    NEW.person_age := EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM NEW.person_dob);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--Crear trigger
CREATE TRIGGER datos_person_age
BEFORE INSERT OR UPDATE ON personafinal
FOR EACH ROW
EXECUTE FUNCTION set_person_age();

--Ejercicio 7
--limpiar collision_vehiculos
CREATE OR REPLACE FUNCTION clean_duplicates_cvehicles()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM collision_vehicles_final
    WHERE ctid NOT IN (
        SELECT min(ctid)
        FROM collision_vehicles_final
        GROUP BY collision_id
    );
    -- Continuar con la operación de inserción o actualización
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para limpiar duplicados
CREATE TRIGGER clean_collision_vehicle_trigger
AFTER INSERT OR UPDATE ON collision_vehicles_final
FOR EACH STATEMENT
EXECUTE FUNCTION clean_duplicates_cvehicles();

--Agrega la columna si no ha sido agregada antes
ALTER TABLE vehiculofinal
ADD COLUMN vehicle_accidents integer default 0;

CREATE OR REPLACE FUNCTION clean_duplicates_vehicles()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si el trigger ya se ejecutó en esta sesión
    IF CURRENT_SETTING('myapp.trigger_executing', TRUE) = 'true' THEN
        RETURN NULL;
    END IF;

    -- Activar la bandera
    PERFORM SET_CONFIG('myapp.trigger_executing', 'true', TRUE);

    -- Eliminar duplicados
    DELETE FROM vehiculofinal
    WHERE vehicle_id = NEW.vehicle_id
        AND ctid NOT IN (
        SELECT MIN(ctid)
        FROM vehiculofinal
        WHERE vehicle_id = NEW.vehicle_id
        GROUP BY vehicle_id
    );

    -- Actualizar vehicle_accidents
    UPDATE vehiculofinal
    SET vehicle_accidents = (
        SELECT COUNT(*)
        FROM collision_vehicles_final
        WHERE vehicle_id = NEW.vehicle_id
    )
    WHERE vehicle_id = NEW.vehicle_id;

    -- Desactivar la bandera
    PERFORM SET_CONFIG('myapp.trigger_executing', 'false', TRUE);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Eliminar el trigger si ya existe
DROP TRIGGER IF EXISTS clean_duplicates_v_trigger ON vehiculofinal;

-- Crear el nuevo trigger
CREATE TRIGGER clean_duplicates_v_trigger
AFTER INSERT OR UPDATE ON vehiculofinal
FOR EACH STATEMENT
EXECUTE FUNCTION clean_duplicates_vehicles();

--Ejercicio 8
ALTER TABLE personafinal
    ADD CONSTRAINT Persona_pk PRIMARY KEY (person_id);

ALTER TABLE vehiculofinal
    ADD CONSTRAINT Vehiculo_pk PRIMARY KEY (vehicle_id);

ALTER TABLE collision_vehicles_final
    ADD CONSTRAINT Collision_vehicles_pk PRIMARY KEY (collision_id, vehicle_id);
ALTER TABLE collision_vehicles_final
    ADD CONSTRAINT Collision_vehicles_collision_fk FOREIGN KEY (collision_id) REFERENCES collision_crashes_final(collision_id)
    ON DELETE CASCADE;
ALTER TABLE collision_vehicles_final
    ADD CONSTRAINT Collision_vehicles_collision_fk FOREIGN KEY (collision_id) REFERENCES collision_crashes_final(collision_id)
    ON DELETE CASCADE;

ALTER TABLE collision_crashes_final
    ADD CONSTRAINT Collision_crashes_pk PRIMARY KEY (collision_id);

ALTER TABLE collision_persons_final
    ADD CONSTRAINT Collision_persons_pk PRIMARY KEY (collision_id, person_id);
ALTER TABLE collision_persons_final
    ADD CONSTRAINT Collision_persons_person_fk FOREIGN KEY (person_id) REFERENCES personafinal(person_id)
    ON DELETE CASCADE;
ALTER TABLE collision_persons_final
    ADD CONSTRAINT Collision_persons_collision_fk FOREIGN KEY (collision_id) REFERENCES collision_crashes_final(collision_id)
    ON DELETE CASCADE;

--saber si hay datos repetidos
SELECT vehicle_id, COUNT(*)
FROM collision_vehicles_final
GROUP BY vehicle_id
HAVING COUNT(*) > 1;