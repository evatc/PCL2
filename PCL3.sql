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
--Agrega la columna si no ha sido agregada antes
ALTER TABLE vehiculofinal
ADD COLUMN vehicle_accidents integer;
--limpiar vehiculos
CREATE OR REPLACE FUNCTION clean_duplicates_vehicles()
RETURNS TRIGGER AS $$
BEGIN
    -- Eliminar registros existentes con el mismo ID que el nuevo
    IF NEW.vehicle_id IS NOT NULL THEN
        DELETE FROM vehiculofinal
        WHERE vehicle_id = NEW.vehicle_id;
    END IF;

    -- Continuar con la operación de inserción o actualización
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para limpiar duplicados
CREATE TRIGGER clean_duplicates_v_trigger
BEFORE INSERT OR UPDATE ON vehiculofinal
FOR EACH ROW
EXECUTE FUNCTION clean_duplicates_vehicles();

--limpiar collision_vehiculos
CREATE OR REPLACE FUNCTION clean_duplicates_cvehicles()
RETURNS TRIGGER AS $$
DECLARE
    is_executing BOOLEAN := FALSE; -- Variable para evitar bucles
BEGIN
    RAISE NOTICE 'Trigger ejecutado para vehicle_id: %', NEW.vehicle_id;
    -- Verificar si el trigger ya está ejecutándose
    IF NOT is_executing THEN
        is_executing := TRUE;
        RAISE NOTICE 'se ejecuta';
        -- Eliminar registros existentes con el mismo ID que el nuevo
        IF NEW.vehicle_id IS NOT NULL THEN
            DELETE FROM final.collision_vehicles_final
            WHERE collision_vehicles_final.vehicle_id = NEW.vehicle_id
            AND ctid <> NEW.ctid; -- Excluir el registro actual
        END IF;

        is_executing := FALSE;
    RAISE NOTICE 'Registros duplicados eliminados para vehicle_id: %', NEW.vehicle_id;
    END IF;

    -- Continuar con la operación de inserción o actualización
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Crear el trigger para limpiar duplicados
CREATE TRIGGER clean_duplicates_cv_trigger
BEFORE INSERT OR UPDATE ON collision_vehicles_final
FOR EACH ROW
EXECUTE FUNCTION clean_duplicates_cvehicles();

-- Crear la función del trigger
CREATE OR REPLACE FUNCTION set_vehicle_accidents()
RETURNS TRIGGER AS $$
DECLARE
    n_accidentes INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO n_accidentes
    FROM collision_vehicles_final
    WHERE vehicle_id = NEW.vehicle_id;

    NEW.vehicle_accidents := n_accidentes;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--Crear trigger
CREATE TRIGGER datos_vehicle_accidents
BEFORE INSERT OR UPDATE ON vehiculofinal
FOR EACH ROW
EXECUTE FUNCTION set_vehicle_accidents();

