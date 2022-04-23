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
$$ LANGUAGE plpgsql



-- BEGIN;

-- UPDATE student SET name = 'G' WHERE roll_no = 1;

-- ROLLBACK;
-- WHERE '3ac' = 

COMMIT;