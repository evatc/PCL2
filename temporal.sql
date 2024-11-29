SET datestyle TO 'MDY';

CREATE database PECL2;

CREATE SCHEMA IF NOT EXISTS temporal;

CREATE SCHEMA IF NOT EXISTS final;

CREATE TABLE IF NOT EXISTS accidente(
    crash_date TEXT,
    crash_time TEXT,
    borough TEXT,
    zipcode TEXT,
    latitude TEXT,
    longitud TEXT,
    location TEXT,
    on_street_name TEXT,
    cross_street_name TEXT,
    off_street_name TEXT,
    number_of_persons_injured TEXT,
    number_of_persons_killed TEXT,
    number_of_pedestrians_injured TEXT,
    number_of_pedestrians_killed TEXT,
    number_of_cyclist_injured TEXT,
    number_of_cyclist_killed TEXT,
    number_of_motorist_injured TEXT,
    number_of_motorist_killed TEXT,
    contributing_factor_vehicle_1 TEXT,
    contributing_factor_vehicle_2 TEXT,
    contributing_factor_vehicle_3 TEXT,
    contributing_factor_vehicle_4 TEXT,
    contributing_factor_vehicle_5 TEXT,
    collision_id TEXT,
    vehicle_type_code_1 TEXT,
    vehicle_type_code_2 TEXT,
    vehicle_type_code_3 TEXT,
    vehicle_type_code_4 TEXT,
    vehicle_type_code_5 TEXT
);

CREATE TABLE IF NOT EXISTS accidente_person(
    unique_id TEXT,
    collision_id TEXT,
    crash_date TEXT,
    crash_time TEXT,
    person_id TEXT,
    person_type TEXT,
    person_injury TEXT,
    vehicle_id TEXT,
    person_age TEXT,
    ejection TEXT,
    emotional_status TEXT,
    bodily_injury TEXT,
    position_in_vehicle TEXT,
    safety_equipment TEXT,
    ped_location TEXT,
    ped_action TEXT,
    complaint TEXT,
    ped_role TEXT,
    contributing_factor TEXT,
    contributing_factor_2 TEXT,
    person_sex TEXT,
);

CREATE TABLE IF NOT EXITS accidentes_vehicles(
    unique_id TEXT,
    collision_id TEXT,
    crash_date TEXT,
    crash_time TEXT,
    vehicle_id TEXT,
    state_registration TEXT,

)

COPY temporal.accidentes
FROM 'C:\Collisions_Crashes_20241020.csv'
WITH CSV HEADER NULL '' DELIMITER ',';