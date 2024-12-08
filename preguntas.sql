--primera pregunta
SELECT vehicle_id, count(*) AS n_accidentes
from collision_vehicles_final
GROUP BY vehicle_id
HAVING COUNT(*) > 1
order by n_accidentes;

--segunda pregunta
SELECT vehicle_id,vehicle_year
from vehiculofinal
where (2024-CAST(vehicle_year AS int)) >= 35
order by vehicle_year;

--tercera pregunta
SELECT vehicle_make, count(*) AS n_vehiculo
from vehiculofinal
group by vehicle_make
order by n_vehiculo desc
LIMIT 5;

--cuarta pregunta
SELECT person_id,position_in_vehicle,count(*) AS n_accidentes
from collision_persons_final
where position_in_vehicle = 'Driver'
group by person_id,position_in_vehicle
having count(*) > 1
order by n_accidentes asc;

--quinta pregunta
SELECT position_in_vehicle,person_id, person_age
from collision_persons_final
where position_in_vehicle = 'Driver' AND (person_age > 65 OR person_age<26)
order by person_age;

--sexta pregunta
SELECT V.*, C.*
from vehiculofinal V, collision_vehicles_final C
where V.vehicle_id = C.vehicle_id AND V.vehicle_type = 'Pick up';

--septima pregunta
SELECT V.vehicle_make, COUNT(CV.collision_id) AS num_accidentes
FROM vehiculofinal V, collision_vehicles_final CV
where V.vehicle_id = CV.vehicle_id
GROUP BY V.vehicle_make
ORDER BY num_accidentes
LIMIT 3;

SELECT V.vehicle_type, COUNT(distinct CV.collision_id) AS num_accidentes
FROM vehiculofinal V, collision_vehicles_final CV
where V.vehicle_id = CV.vehicle_id
GROUP BY V.vehicle_type
ORDER BY num_accidentes
LIMIT 3;

--octava pregunta
SELECT COUNT(CV.collision_id) AS n_accidentes, V.vehicle_make
FROM collision_vehicles_final CV, vehiculofinal V
where V.vehicle_id = CV.vehicle_id
GROUP BY V.vehicle_make
ORDER BY n_accidentes desc;

--novena pregunta
SELECT CP.person_id, P.person_state
FROM collision_persons_final CP, personafinal P
where CP.person_id = P.person_id
order by P.person_state;

--decima pregunta
SELECT state_registration,count(*) AS n_accidentes
FROM collision_vehicles_final
group by state_registration
order by n_accidentes;

