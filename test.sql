CREATE OR REPLACE PROCEDURE seatbook3AC(
	in_av_id INT,
	no_of_seats INT,
	INOUT success int DEFAULT 0
)
AS $$
BEGIN
	
	IF not exists (SELECT * FROM availability WHERE availability.av_id = in_av_id AND availability.third_ac >= no_of_seats) THEN
		RAISE EXCEPTION 'Number of seats requested is unavailable';
	ELSE
		UPDATE availability SET third_ac = third_ac - no_of_seats WHERE availability.av_id = in_av_id
		RETURNING third_ac INTO success;

	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE seatbook2AC(
	in_av_id INT,
	no_of_seats INT,
	INOUT success int DEFAULT 0
)
AS $$
BEGIN
	
	IF not exists (SELECT * FROM availability WHERE availability.av_id = in_av_id AND availability.second_ac >= no_of_seats) THEN
		RAISE EXCEPTION 'Number of seats requested is unavailable';
	ELSE
		UPDATE availability SET second_ac = second_ac - no_of_seats WHERE availability.av_id = in_av_id
		RETURNING second_ac INTO success;

	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE seatbook1AC(
	in_av_id INT,
	no_of_seats INT,
	INOUT success int DEFAULT 0
)
AS $$
BEGIN
	
	IF not exists (SELECT * FROM availability WHERE availability.av_id = in_av_id AND availability.first_ac >= no_of_seats) THEN
		RAISE EXCEPTION 'Number of seats requested is unavailable';
	ELSE
		UPDATE availability SET first_ac = first_ac - no_of_seats WHERE availability.av_id = in_av_id
		RETURNING first_ac INTO success;

	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE seatbookSL(
	in_av_id INT,
	no_of_seats INT,
	INOUT success int DEFAULT 0
)
AS $$
BEGIN
	
	IF not exists (SELECT * FROM availability WHERE availability.av_id = in_av_id AND availability.sleeper >= no_of_seats) THEN
		RAISE EXCEPTION 'Number of seats requested is unavailable';
	ELSE
		UPDATE availability SET sleeper = sleeper - no_of_seats WHERE availability.av_id = in_av_id
		RETURNING sleeper INTO success;

	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE seatbookGEN(
	in_av_id INT,
	no_of_seats INT,
	INOUT success int DEFAULT 0
)
AS $$
BEGIN
	
	IF not exists (SELECT * FROM availability WHERE availability.av_id = in_av_id AND availability.general >= no_of_seats) THEN
		RAISE EXCEPTION 'Number of seats requested is unavailable';
	ELSE
		UPDATE availability SET general = general - no_of_seats WHERE availability.av_id = in_av_id
		RETURNING general INTO success;

	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION checkpassword(
	IN uname text,
	IN pwd text,
	OUT _check int
)
AS $$
BEGIN
	IF exists (SELECT * FROM user_info WHERE email = uname AND pwd = password) THEN
		_check = 1;
	ELSE
		_check = 0;
	END IF;
END;
$$ LANGUAGE plpgsql;

-- query optimized 

CREATE OR REPLACE FUNCTION get_im_av_id(
	IN in_src text,
	IN in_dest text,
	IN in_train_no int,
	IN in_date date,
	OUT out_avid int
)
AS $$
BEGIN
	SELECT av_id FROM 
	(SELECT uti FROM route WHERE route.source = in_src AND route.destination = in_dest AND route.train_no = in_train_no) AS r JOIN 
	(SELECT av_id, uti FROM availability WHERE availability.date = in_date) AS a
	ON r.uti = a.uti
	INTO out_avid;
END;
$$ LANGUAGE plpgsql;

