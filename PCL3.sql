--Ejercicio 1
DELETE FROM vehiculofinal
WHERE vehicle_id IS NULL OR length(vehicle_id) < 10;

DELETE FROM collision_vehicles_final
WHERE vehicle_id IS NULL OR length(vehicle_id) < 10;

DELETE FROM collision_persons_final
WHERE vehicle_id IS NULL OR length(vehicle_id) < 10;

--Ejercicio 2
DELETE FROM personafinal
WHERE person_id IS NULL OR length(person_id) < 10;

DELETE FROM collision_persons_final
WHERE person_id IS NULL OR length(person_id) < 10;

--Ejercicio 3
UPDATE vehiculofinal
SET state_registration = collision_vehicles_final.state_registration
FROM collision_vehicles_final
WHERE vehiculofinal.vehicle_id = collision_vehicles_final.vehicle_id;


SELECT V.vehicle_id, C.vehicle_id
FROM vehiculofinal V, collision_vehicles_final C
WHERE V.vehicle_id=C.vehicle_id;

--Ejercicio 4
UPDATE vehiculofinal
SET vehicle_type = 'unknown'
WHERE vehicle_type IS NULL;

UPDATE vehiculofinal
SET vehicle_make = 'unknown'
WHERE vehicle_make IS NULL;

UPDATE vehiculofinal
SET vehicle_model = 'unknown'
WHERE vehicle_model IS NULL;

UPDATE vehiculofinal
SET vehicle_year = '9999'
WHERE vehicle_year IS NULL;

--Falta state_registration

--Ejercicio 5
UPDATE personafinal
SET person_sex = collision_persons_final.person_sex
FROM collision_persons_final
WHERE personafinal.person_id= collision_persons_final.person_id;
