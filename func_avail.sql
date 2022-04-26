-- Avail seats
-- input = (src, dest, date), output = (train_name, train_no, src, dest, departure, arrival)
-- input = (src, dest, date), output = (first_ac, second_ac, third_ac, sleeper, general)

-- Avail trains
-- input = (src, dest), output = (train_name, train_no, src, dest, departure, arrival)

CREATE OR REPLACE FUNCTION avail_trains(
      src text, dest text)
      RETURNS TABLE (train_name text,
      				 train_no int,
      				 source_out text,
      				 destination_out text,
      				 departure time,
      				 arrival time
	  	)
AS $$
BEGIN
	RETURN QUERY
	select *
	from
		avail_trains_view
	where
		source = src and destination = dest;
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
		avail_seats_2_view.av_id,
		avail_seats_2_view.first_ac,
		avail_seats_2_view.second_ac,
		avail_seats_2_view.third_ac,
		avail_seats_2_view.sleeper,
		avail_seats_2_view.general,
		avail_seats_2_view.date
	from
		avail_seats_2_view
	where
		avail_seats_2_view.source = src and avail_seats_2_view.destination = dest and avail_seats_2_view.date = ddate;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION avail_seats_1(
      src text, dest text, ddate date)
      RETURNS TABLE (		 
		  			 av_id int,      				
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
		avail_seats_1_view.av_id,
		avail_seats_1_view.train_name,
		avail_seats_1_view.train_no,
		avail_seats_1_view.source,
		avail_seats_1_view.destination,
		avail_seats_1_view.departure,
		avail_seats_1_view.arrival,
		avail_seats_1_view.date
	from
		avail_seats_1_view
	where
		avail_seats_1_view.source = src and avail_seats_1_view.destination = dest and avail_seats_1_view.date = ddate;
end;
$$ LANGUAGE plpgsql;
