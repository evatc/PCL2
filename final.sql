SET datestyle TO 'MDY';

CREATE TABLE IF NOT EXISTS personafinal(
    person_id varchar(50)  NOT NULL,
    person_sex CHAR(1) CHECK (person_sex IN ('M','F','U',null)),
    person_lastname varchar(30) NOT NULL,
    person_firstname varchar(30) NOT NULL,
    person_phone varchar(50) NOT NULL,
    person_adress varchar(50) NOT NULL,
    person_city varchar(30) NOT NULL,
    person_state varchar(30) NOT NULL,
    person_zip char(5) NOT NULL,
    person_ssn char(11) NOT NULL,
    person_dob date NOT NULL
    --PRIMARY KEY (person_id)
);
CREATE TABLE IF NOT EXISTS vehiculofinal(
    vehicle_id varchar(50)  NOT NULL,
    state_registration varchar(15),
    vehicle_type varchar(30),
    vehicle_make varchar(20),
    vehicle_model varchar(20),
    vehicle_year char(4)
    --PRIMARY KEY (vehicle_id)
);

CREATE TABLE IF NOT EXISTS collision_vehicles_final(
    collision_id int NOT NULL,
    vehicle_id varchar(50) NOT NULL,
    state_registration varchar(5),
    travel_direction varchar(15),
    vehicle_occupants int,
    driver_sex CHAR(1) CHECK (driver_sex IN ('M','F','U',null)),
    driver_license_status varchar(30),
    driver_license_jurisdiction varchar(20),
    pre_crash text,
    point_of_impact text,
    vehicle_damage text,
    vehicle_damage_2 text,
    vehicle_damage_3 text,
    vehicle_damage_4 text,
    public_property_damage varchar(30),
    public_property_damage_type varchar(30),
    contributing_factor varchar(30),
    contributing_factor_2 varchar(30)
    --PRIMARY KEY (vehicle_id, collision_id),
    --FOREIGN KEY (vehicle_id) REFERENCES vehiculofinal(vehicle_id),
    --FOREIGN KEY (collision_id) REFERENCES collision_crashes_final(collision_id)
);

CREATE TABLE IF NOT EXISTS collision_crashes_final(
    crash_date date NOT NULL,
    crash_time  time without time zone NOT NULL ,
    borough  varchar(40),
    zipcode varchar(5),
    latitude decimal(9,6),
    longitude decimal(9,6),
    location varchar(30),
    on_street_name varchar(40),
    cross_street_name varchar(40),
    off_street_name varchar(40),
    number_of_persons_injured smallint,
    number_of_persons_killed smallint,
    number_of_pedestrians_injured smallint,
    number_of_pedestrians_killed smallint,
    number_of_cyclist_injured smallint,
    number_of_cyclist_killed smallint,
    number_of_motorist_injured smallint,
    number_of_motorist_killed smallint,
    contributing_factor_vehicle_1 text,
    contributing_factor_vehicle_2 text,
    contributing_factor_vehicle_3 text,
    contributing_factor_vehicle_4 text,
    contributing_factor_vehicle_5 text,
    collision_id int NOT NULL
    --PRIMARY KEY (collision_id)
);

CREATE TABLE IF NOT EXISTS collision_persons_final(
    collision_id int,
    person_id varchar(50),
    person_type varchar(30) NOT NULL,
    person_injury varchar(30) NOT NULL,
    vehicle_id char(8),
    person_age smallint,
    ejection varchar(30),
    emotional_status varchar(30),
    bodily_injury varchar(30),
    position_in_vehicle varchar(40),
    safety_equipment varchar(30),
    ped_location varchar(30),
    ped_action varchar(30),
    complaint varchar(30),
    ped_role varchar(20),
    contributing_factor text,
    contributing_factor_2 text,
    person_sex CHAR(1) CHECK (person_sex IN ('M','F','U',null))
    --PRIMARY KEY (person_id, collision_id),
    --FOREIGN KEY (person_id) REFERENCES personafinal(person_id),
    --FOREIGN KEY (collision_id) REFERENCES collision_crashes_final(collision_id)
);

CREATE INDEX idx_vehiculofinal_vehicle_id ON vehiculofinal(vehicle_id);
INSERT INTO final.vehiculofinal(vehicle_id, vehicle_type, vehicle_make, vehicle_model, vehicle_year)
SELECT
    CAST(vehicle_id AS varchar(50)),
    CAST(vehicle_type AS varchar(30)),
    CAST(vehicle_make AS varchar(20)),
    CAST(vehicle_model AS varchar(20)),
    CAST(vehicle_year AS char(4))
FROM temporal.vehiculo;
INSERT INTO final.personafinal(person_id, person_sex, person_lastname, person_firstname, person_phone, person_adress, person_city, person_state, person_zip, person_ssn, person_dob)
SELECT
    CAST(person_id AS varchar(50)),
    CAST(person_sex AS CHAR(1)),
    CAST(person_lastname AS varchar(30)),
    CAST(person_firstname AS varchar(30)),
    CAST(person_phone AS varchar(50)),
    CAST(person_address AS varchar(50)),
    CAST(person_city AS varchar(30)),
    CAST(person_state AS varchar(30)),
    CAST(person_zip AS char(5)),
    CAST(person_ssn AS char(11)),
    CAST(person_dob AS date)
FROM temporal.personas;

INSERT INTO final.collision_crashes_final(crash_date, crash_time, borough, zipcode, latitude, longitude, location, on_street_name, cross_street_name, off_street_name, number_of_persons_injured, number_of_persons_killed, number_of_pedestrians_injured, number_of_pedestrians_killed, number_of_cyclist_injured, number_of_cyclist_killed, number_of_motorist_injured, number_of_motorist_killed, contributing_factor_vehicle_1, contributing_factor_vehicle_2, contributing_factor_vehicle_3, contributing_factor_vehicle_4, contributing_factor_vehicle_5, collision_id)
SELECT
    CAST(crash_date AS date),
    CAST(crash_time AS time without time zone),
    CAST(borough AS varchar(40)),
    CAST(zipcode AS varchar(5)),
    CAST(latitude AS decimal(9,6)),
    CAST(longitud AS decimal(9,6)),
    CAST(location AS varchar(30)),
    CAST(on_street_name AS varchar(40)),
    CAST(cross_street_name AS varchar(40)),
    CAST(off_street_name AS varchar(40)),
    CAST(number_of_persons_injured AS smallint),
    CAST(number_of_persons_killed AS smallint),
    CAST(number_of_pedestrians_injured AS smallint),
    CAST(number_of_pedestrians_killed AS smallint),
    CAST(number_of_cyclist_injured AS smallint),
    CAST(number_of_cyclist_killed AS smallint),
    CAST(number_of_motorist_injured AS smallint),
    CAST(number_of_motorist_killed AS smallint),
    CAST(contributing_factor_vehicle AS text),
    CAST(contributing_factor_vehicle_2 AS text),
    CAST(contributing_factor_vehicle_3 AS text),
    CAST(contributing_factor_vehicle_4 AS text),
    CAST(contributing_factor_vehicle_5 AS text),
    CAST(collision_id AS int)
FROM temporal.accidente;

INSERT INTO final.collision_persons_final(collision_id,person_id, person_type, person_injury, vehicle_id, person_age, ejection, emotional_status, bodily_injury, position_in_vehicle, safety_equipment, ped_location, ped_action, complaint, ped_role, contributing_factor, contributing_factor_2, person_sex)
SELECT
    CAST(collision_id AS int),
    CAST(person_id AS varchar(50)),
    CAST(person_type AS varchar(30)),
    CAST(person_injury AS varchar(30)),
    CAST(vehicle_id AS char(8)),
    CAST(person_age AS smallint),
    CAST(ejection AS varchar(30)),
    CAST(emotional_status AS varchar(30)),
    CAST(bodily_injury AS varchar(30)),
    CAST(position_in_vehicle AS varchar(40)),
    CAST(safety_equipment AS varchar(30)),
    CAST(ped_location AS varchar(30)),
    CAST(ped_action AS varchar(30)),
    CAST(complaint AS varchar(30)),
    CAST(ped_role AS varchar(20)),
    CAST(contributing_factor AS text),
    CAST(contributing_factor_2 AS text),
    CAST(person_sex AS CHAR(1))
FROM temporal.accidente_person;

CREATE INDEX idx_collision_vehicle_id ON collision_vehicles_final(collision_id);
INSERT INTO final.collision_vehicles_final(collision_id,vehicle_id,state_registration, travel_direction, vehicle_occupants, driver_sex, driver_license_status, driver_license_jurisdiction, pre_crash, point_of_impact, vehicle_damage, vehicle_damage_2, vehicle_damage_3, vehicle_damage_4, public_property_damage, public_property_damage_type, contributing_factor, contributing_factor_2)
SELECT
    CAST(collision_id AS int),
    CAST(vehicle_id AS varchar(50)),
    CAST(state_registration AS varchar(5)),
    CAST(travel_direction AS varchar(15)),
    CAST(vehicle_occupants AS int),
    CAST(driver_sex AS CHAR(1)),
    CAST(driver_license_status AS varchar(30)),
    CAST(driver_license_jurisdiction AS varchar(20)),
    CAST(pre_crash AS text),
    CAST(point_of_impact AS text),
    CAST(vehicle_damage AS text),
    CAST(vehicle_damage_2 AS text),
    CAST(vehicle_damage_3 AS text),
    CAST(vehicle_damage_4 AS text),
    CAST(public_property_damage AS varchar(30)),
    CAST(public_property_damage_type AS varchar(30)),
    CAST(contributing_factor AS varchar(30)),
    CAST(contributing_factor_2 AS varchar(30))
FROM temporal.accidentes_vehicles