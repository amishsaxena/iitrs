CREATE OR REPLACE VIEW avail_trains_view AS SELECT
		train.train_name,
		route.train_no,
		route.source,
		route.destination,
		route.departure,
		route.arrival
FROM route JOIN train ON route.train_no = train.train_no;

CREATE OR REPLACE VIEW avail_seats_2_view AS SELECT
		availability.av_id,
		availability.first_ac,
		availability.second_ac,
		availability.third_ac,
		availability.sleeper,
		availability.general,
		availability.date,
        route.source,
        route.destination
FROM route JOIN availability ON route.uti = availability.uti;

CREATE OR REPLACE VIEW avail_seats_1_view AS SELECT
		availability.av_id,
		train.train_name,
		route.train_no,
		route.source,
		route.destination,
		route.departure,
		route.arrival,
		availability.date
FROM route JOIN availability ON route.uti = availability.uti
JOIN train ON route.train_no = train.train_no;

CREATE OR REPLACE VIEW seats_in_class_view AS SELECT
        route.uti
        train.first_ac,
        train.second_ac,
        train.third_ac,
        train.sleeper,
        train.general
FROM route JOIN train ON route.train_no = train.train_no;

CREATE MATERIALIZED VIEW checkpassword_view AS SELECT
            uid, 
            password, 
            email 
FROM user_info;