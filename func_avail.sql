-- Avail seats
-- input = (src, dest, date), output = (train_name, train_no, src, dest, departure, arrival)
-- input = (src, dest, date), output = (first_ac, second_ac, third_ac, sleeper, general)

-- Avail trains
-- input = (src, dest), output = (train_name, train_no, src, dest, departure, arrival)

CREATE OR REPLACE FUNCTION avail_trains(
      src text, dest text)
      RETURNS TABLE (train_name text,
      				 train_no int,
      				 source text,
      				 destination text,
      				 departure time,
      				 arrival time
	  	)
AS $$
BEGIN
	RETURN QUERY
	select
		train.train_name,
		route.train_no,
		route.source,
		route.destination,
		route.departure,
		route.arrival
	from
		route join train on route.train_no = train.train_no
	where
		route.source = src and route.destination = dest;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION avail_seats_2(
      src text, dest text, ddate date)
      RETURNS TABLE (
      				 av_id int,
      				 first_ac int,
      				 second_ac int,
      				 third_ac int,
      				 sleeper int,
      				 general int,
      				 date date
	  	)
AS $$
BEGIN
	RETURN QUERY
	select
		availability.av_id,
		availability.first_ac,
		availability.second_ac,
		availability.third_ac,
		availability.sleeper,
		availability.general,
		availability.date
	from
		route join availability on route.uti = availability.uti
	where
		route.source = src and route.destination = dest and availability.date = ddate;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION avail_seats_1(
      src text, dest text, ddate date)
      RETURNS TABLE (		 av_id int,      				
      				 train_name text,
      				 train_no int,
      				 source text,
      				 destination text,
      				 departure time,
      				 arrival time,
      				 date date
		  	)
AS $$
BEGIN
	RETURN QUERY
	select
		availability.av_id,
		train.train_name,
		route.train_no,
		route.source,
		route.destination,
		route.departure,
		route.arrival,
		availability.date
	from
		route join availability on route.uti = availability.uti
		join train on route.train_no = train.train_no
	where
		route.source = src and route.destination = dest and availability.date = ddate;
end;
$$ LANGUAGE plpgsql;
