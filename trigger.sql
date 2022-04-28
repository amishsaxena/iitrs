CREATE OR REPLACE FUNCTION refresh_chk_pwd_view()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY checkpassword_view;
    RETURN NULL;
END;
$$;

CREATE TRIGGER trg_refresh_chk_pwd_view 
AFTER INSERT OR UPDATE OR DELETE
ON user_info
FOR EACH STATEMENT 
EXECUTE PROCEDURE refresh_chk_pwd_view();


-- Trigger for ADMIN inserting train  on (src, dest)

-- CREATE OR REPLACE FUNCTION check_src_dest()
-- RETURNS trigger LANGUAGE plpgsql AS $$
-- BEGIN
--     IF (EXISTS  (SELECT * FROM stations where stations.station_code =  NEW.source ) 
--     AND  EXISTS (SELECT * FROM stations where stations.station_code = NEW.destination))
--      THEN
--     RETURN NEW;
--     ELSE
--         RAISE EXCEPTION 'Entered stations are not valid %', NEW.source;
--     END IF;
-- END;
-- $$;

-- CREATE TRIGGER trg_check_src_dest
-- BEFORE INSERT
-- ON route
-- FOR EACH ROW
-- EXECUTE PROCEDURE check_src_dest();

-- -- Testing for trigger --
-- INSERT INTO train(train_no, train_name, first_ac, second_ac, third_ac, sleeper, general) VALUES (17777, 'Toy Train', 0, 0, 0, 0, 4);
-- INSERT INTO route(train_no, source, destination, departure, arrival) VALUES  (17777, 'UDZ', 'SDAH', '07:20', '11:30');

-- DELETE FROM train WHERE train_no = 17777;

-- =========================================================

-- While booking, check if entered date is more than a month ahead of current date.

CREATE OR REPLACE FUNCTION chk_book_date()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF (NEW.date > (CURRENT_DATE + interval '3 month') ) THEN
    RAISE EXCEPTION 'Date outside booking period. Try Later. %', NEW.date;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_chk_book_date
BEFORE INSERT
ON ticket
FOR EACH ROW 
EXECUTE PROCEDURE chk_book_date();

-- Testing --
INSERT INTO ticket (pnr, av_id, train_no, uid, train_name, source, destination, date, seats, amount, booking_status) values ('1111100002', 122, 17777, 2, 'Toy Train', 'LDH', 'ASR', '11/26/2022', '{"seat" : 1}', 0, 'BOOKED');
