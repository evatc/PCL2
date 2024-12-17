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
WHERE person_sex IS NULL OR person_sex=''

--Ejercicio 6
ALTER TABLE personafinal
ADD COLUMN person_age integer;

CREATE OR REPLACE TRIGGER datos_person_age
BEFORE INSERT ON personafinal
BEGIN
    new.person_age = 2024 -
END


insert into personafinal
