--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: avail_seats_1(text, text, date); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.avail_seats_1(src text, dest text, ddate date) RETURNS TABLE(av_id integer, train_name text, train_no integer, source text, destination text, departure time without time zone, arrival time without time zone, date date)
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.avail_seats_1(src text, dest text, ddate date) OWNER TO zenamish;

--
-- Name: avail_seats_2(text, text, date); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.avail_seats_2(src text, dest text, ddate date) RETURNS TABLE(av_id integer, first_ac integer, second_ac integer, third_ac integer, sleeper integer, general integer, date date)
    LANGUAGE plpgsql
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
$$;


ALTER FUNCTION public.avail_seats_2(src text, dest text, ddate date) OWNER TO zenamish;

--
-- Name: avail_trains(text, text); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.avail_trains(src text, dest text) RETURNS TABLE(train_name text, train_no integer, source_out text, destination_out text, departure time without time zone, arrival time without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 select *
 from
avail_trains_view
 where
source = src and destination = dest;
end;
$$;


ALTER FUNCTION public.avail_trains(src text, dest text) OWNER TO zenamish;

--
-- Name: check_src_dest(); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.check_src_dest() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (EXISTS  (SELECT * FROM stations where stations.station_code =  NEW.source ) 
    AND  EXISTS (SELECT * FROM stations where stations.station_code = NEW.destination))
     THEN
    RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Entered stations are not valid %', OLD.source;
    END IF;
END;
$$;


ALTER FUNCTION public.check_src_dest() OWNER TO zenamish;

--
-- Name: checkpassword(text, text); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.checkpassword(uname text, pwd text, OUT _check integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF exists (SELECT * FROM user_info WHERE email = uname AND pwd = password) THEN
		_check = 1;
	ELSE
		_check = 0;
	END IF;
END;
$$;


ALTER FUNCTION public.checkpassword(uname text, pwd text, OUT _check integer) OWNER TO zenamish;

--
-- Name: chk_book_date(); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.chk_book_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (NEW.date > (CURRENT_DATE + interval '3 month') ) THEN
    RAISE EXCEPTION 'Date outside booking period. Try Later. %', NEW.date;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.chk_book_date() OWNER TO zenamish;

--
-- Name: get_im_av_id(text, text, integer, date); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.get_im_av_id(in_src text, in_dest text, in_train_no integer, in_date date, OUT out_avid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	SELECT av_id FROM 
	(SELECT uti FROM route WHERE route.source = in_src AND route.destination = in_dest AND route.train_no = in_train_no) AS r JOIN 
	(SELECT av_id, uti FROM availability WHERE availability.date = in_date) AS a
	ON r.uti = a.uti
	INTO out_avid;
END;
$$;


ALTER FUNCTION public.get_im_av_id(in_src text, in_dest text, in_train_no integer, in_date date, OUT out_avid integer) OWNER TO zenamish;

--
-- Name: refresh_chk_pwd_view(); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.refresh_chk_pwd_view() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    REFRESH MATERIALIZED VIEW checkpassword_view;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.refresh_chk_pwd_view() OWNER TO zenamish;

--
-- Name: seatbook1ac(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: zenamish
--

CREATE PROCEDURE public.seatbook1ac(in_av_id integer, no_of_seats integer, INOUT success integer DEFAULT 0)
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	IF not exists (SELECT * FROM availability WHERE availability.av_id = in_av_id AND availability.first_ac >= no_of_seats) THEN
		RAISE EXCEPTION 'Number of seats requested is unavailable';
	ELSE
		UPDATE availability SET first_ac = first_ac - no_of_seats WHERE availability.av_id = in_av_id
		RETURNING first_ac INTO success;

	END IF;
END;
$$;


ALTER PROCEDURE public.seatbook1ac(in_av_id integer, no_of_seats integer, INOUT success integer) OWNER TO zenamish;

--
-- Name: seatbook2ac(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: zenamish
--

CREATE PROCEDURE public.seatbook2ac(in_av_id integer, no_of_seats integer, INOUT success integer DEFAULT 0)
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	IF not exists (SELECT * FROM availability WHERE availability.av_id = in_av_id AND availability.second_ac >= no_of_seats) THEN
		RAISE EXCEPTION 'Number of seats requested is unavailable';
	ELSE
		UPDATE availability SET second_ac = second_ac - no_of_seats WHERE availability.av_id = in_av_id
		RETURNING second_ac INTO success;

	END IF;
END;
$$;


ALTER PROCEDURE public.seatbook2ac(in_av_id integer, no_of_seats integer, INOUT success integer) OWNER TO zenamish;

--
-- Name: seatbook3ac(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: zenamish
--

CREATE PROCEDURE public.seatbook3ac(in_av_id integer, no_of_seats integer, INOUT success integer DEFAULT 0)
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	IF not exists (SELECT * FROM availability WHERE availability.av_id = in_av_id AND availability.third_ac >= no_of_seats) THEN
		RAISE EXCEPTION 'Number of seats requested is unavailable';
	ELSE
		UPDATE availability SET third_ac = third_ac - no_of_seats WHERE availability.av_id = in_av_id
		RETURNING third_ac INTO success;

	END IF;
END;
$$;


ALTER PROCEDURE public.seatbook3ac(in_av_id integer, no_of_seats integer, INOUT success integer) OWNER TO zenamish;

--
-- Name: seatbookgen(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: zenamish
--

CREATE PROCEDURE public.seatbookgen(in_av_id integer, no_of_seats integer, INOUT success integer DEFAULT 0)
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	IF not exists (SELECT * FROM availability WHERE availability.av_id = in_av_id AND availability.general >= no_of_seats) THEN
		RAISE EXCEPTION 'Number of seats requested is unavailable';
	ELSE
		UPDATE availability SET general = general - no_of_seats WHERE availability.av_id = in_av_id
		RETURNING general INTO success;

	END IF;
END;
$$;


ALTER PROCEDURE public.seatbookgen(in_av_id integer, no_of_seats integer, INOUT success integer) OWNER TO zenamish;

--
-- Name: seatbooksl(integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: zenamish
--

CREATE PROCEDURE public.seatbooksl(in_av_id integer, no_of_seats integer, INOUT success integer DEFAULT 0)
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	IF not exists (SELECT * FROM availability WHERE availability.av_id = in_av_id AND availability.sleeper >= no_of_seats) THEN
		RAISE EXCEPTION 'Number of seats requested is unavailable';
	ELSE
		UPDATE availability SET sleeper = sleeper - no_of_seats WHERE availability.av_id = in_av_id
		RETURNING sleeper INTO success;

	END IF;
END;
$$;


ALTER PROCEDURE public.seatbooksl(in_av_id integer, no_of_seats integer, INOUT success integer) OWNER TO zenamish;

--
-- Name: seats_in_first_ac(integer); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.seats_in_first_ac(id integer, OUT cnt integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
   select  first_ac
   into cnt
   from route join train on route.train_no = train.train_no
   where route.uti = id;
   cnt = cnt * 24;
end;
$$;


ALTER FUNCTION public.seats_in_first_ac(id integer, OUT cnt integer) OWNER TO zenamish;

--
-- Name: seats_in_general(integer); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.seats_in_general(id integer, OUT cnt integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
   select  general
   into cnt
   from route join train on route.train_no = train.train_no
   where route.uti = id;
   cnt = cnt * 72;
end;
$$;


ALTER FUNCTION public.seats_in_general(id integer, OUT cnt integer) OWNER TO zenamish;

--
-- Name: seats_in_second_ac(integer); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.seats_in_second_ac(id integer, OUT cnt integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
   select  second_ac
   into cnt
   from route join train on route.train_no = train.train_no
   where route.uti = id;
   cnt = cnt * 48;
end;
$$;


ALTER FUNCTION public.seats_in_second_ac(id integer, OUT cnt integer) OWNER TO zenamish;

--
-- Name: seats_in_sleeper(integer); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.seats_in_sleeper(id integer, OUT cnt integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
   select  sleeper
   into cnt
   from route join train on route.train_no = train.train_no
   where route.uti = id;
   cnt = cnt * 72;
end;
$$;


ALTER FUNCTION public.seats_in_sleeper(id integer, OUT cnt integer) OWNER TO zenamish;

--
-- Name: seats_in_third_ac(integer); Type: FUNCTION; Schema: public; Owner: zenamish
--

CREATE FUNCTION public.seats_in_third_ac(id integer, OUT cnt integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
   select  third_ac
   into cnt
   from route join train on route.train_no = train.train_no
   where route.uti = id;
   cnt = cnt * 64;
end;
$$;


ALTER FUNCTION public.seats_in_third_ac(id integer, OUT cnt integer) OWNER TO zenamish;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: availability; Type: TABLE; Schema: public; Owner: zenamish
--

CREATE TABLE public.availability (
    av_id integer NOT NULL,
    uti integer,
    first_ac integer,
    second_ac integer,
    third_ac integer,
    sleeper integer,
    general integer,
    date date,
    CONSTRAINT availability_first_ac_check CHECK ((first_ac >= 0)),
    CONSTRAINT availability_general_check CHECK ((general >= 0)),
    CONSTRAINT availability_second_ac_check CHECK ((second_ac >= 0)),
    CONSTRAINT availability_sleeper_check CHECK ((sleeper >= 0)),
    CONSTRAINT availability_third_ac_check CHECK ((third_ac >= 0))
);


ALTER TABLE public.availability OWNER TO zenamish;

--
-- Name: route; Type: TABLE; Schema: public; Owner: zenamish
--

CREATE TABLE public.route (
    uti integer NOT NULL,
    train_no integer,
    source text NOT NULL,
    destination text NOT NULL,
    departure time without time zone NOT NULL,
    arrival time without time zone NOT NULL
);


ALTER TABLE public.route OWNER TO zenamish;

--
-- Name: train; Type: TABLE; Schema: public; Owner: zenamish
--

CREATE TABLE public.train (
    train_no integer NOT NULL,
    train_name text NOT NULL,
    first_ac integer,
    second_ac integer,
    third_ac integer,
    sleeper integer,
    general integer,
    CONSTRAINT train_first_ac_check CHECK ((first_ac >= 0)),
    CONSTRAINT train_general_check CHECK ((general >= 0)),
    CONSTRAINT train_second_ac_check CHECK ((second_ac >= 0)),
    CONSTRAINT train_sleeper_check CHECK ((sleeper >= 0)),
    CONSTRAINT train_third_ac_check CHECK ((third_ac >= 0)),
    CONSTRAINT train_train_no_check CHECK ((train_no > 9999))
);


ALTER TABLE public.train OWNER TO zenamish;

--
-- Name: avail_seats_1_view; Type: VIEW; Schema: public; Owner: zenamish
--

CREATE VIEW public.avail_seats_1_view AS
 SELECT availability.av_id,
    train.train_name,
    route.train_no,
    route.source,
    route.destination,
    route.departure,
    route.arrival,
    availability.date
   FROM ((public.route
     JOIN public.availability ON ((route.uti = availability.uti)))
     JOIN public.train ON ((route.train_no = train.train_no)));


ALTER TABLE public.avail_seats_1_view OWNER TO zenamish;

--
-- Name: avail_seats_2_view; Type: VIEW; Schema: public; Owner: zenamish
--

CREATE VIEW public.avail_seats_2_view AS
 SELECT availability.av_id,
    availability.first_ac,
    availability.second_ac,
    availability.third_ac,
    availability.sleeper,
    availability.general,
    availability.date,
    route.source,
    route.destination
   FROM (public.route
     JOIN public.availability ON ((route.uti = availability.uti)));


ALTER TABLE public.avail_seats_2_view OWNER TO zenamish;

--
-- Name: avail_trains_view; Type: VIEW; Schema: public; Owner: zenamish
--

CREATE VIEW public.avail_trains_view AS
 SELECT train.train_name,
    route.train_no,
    route.source,
    route.destination,
    route.departure,
    route.arrival
   FROM (public.route
     JOIN public.train ON ((route.train_no = train.train_no)));


ALTER TABLE public.avail_trains_view OWNER TO zenamish;

--
-- Name: availability_av_id_seq; Type: SEQUENCE; Schema: public; Owner: zenamish
--

CREATE SEQUENCE public.availability_av_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.availability_av_id_seq OWNER TO zenamish;

--
-- Name: availability_av_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zenamish
--

ALTER SEQUENCE public.availability_av_id_seq OWNED BY public.availability.av_id;


--
-- Name: user_info; Type: TABLE; Schema: public; Owner: zenamish
--

CREATE TABLE public.user_info (
    uid integer NOT NULL,
    name text NOT NULL,
    password text NOT NULL,
    mobile_no text,
    email text NOT NULL,
    address text NOT NULL
);


ALTER TABLE public.user_info OWNER TO zenamish;

--
-- Name: checkpassword_view; Type: MATERIALIZED VIEW; Schema: public; Owner: zenamish
--

CREATE MATERIALIZED VIEW public.checkpassword_view AS
 SELECT user_info.uid,
    user_info.password,
    user_info.email
   FROM public.user_info
  WITH NO DATA;


ALTER TABLE public.checkpassword_view OWNER TO zenamish;

--
-- Name: route_uti_seq; Type: SEQUENCE; Schema: public; Owner: zenamish
--

CREATE SEQUENCE public.route_uti_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.route_uti_seq OWNER TO zenamish;

--
-- Name: route_uti_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zenamish
--

ALTER SEQUENCE public.route_uti_seq OWNED BY public.route.uti;


--
-- Name: seats_in_class_view; Type: VIEW; Schema: public; Owner: zenamish
--

CREATE VIEW public.seats_in_class_view AS
 SELECT train.first_ac,
    train.second_ac,
    train.third_ac,
    train.sleeper,
    train.general
   FROM (public.route
     JOIN public.train ON ((route.train_no = train.train_no)));


ALTER TABLE public.seats_in_class_view OWNER TO zenamish;

--
-- Name: stations; Type: TABLE; Schema: public; Owner: zenamish
--

CREATE TABLE public.stations (
    station_id integer NOT NULL,
    station_code text,
    station_name text
);


ALTER TABLE public.stations OWNER TO zenamish;

--
-- Name: stations_station_id_seq; Type: SEQUENCE; Schema: public; Owner: zenamish
--

CREATE SEQUENCE public.stations_station_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stations_station_id_seq OWNER TO zenamish;

--
-- Name: stations_station_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zenamish
--

ALTER SEQUENCE public.stations_station_id_seq OWNED BY public.stations.station_id;


--
-- Name: ticket; Type: TABLE; Schema: public; Owner: zenamish
--

CREATE TABLE public.ticket (
    pnr text NOT NULL,
    av_id integer NOT NULL,
    train_no integer,
    uid integer,
    train_name text NOT NULL,
    source text NOT NULL,
    destination text NOT NULL,
    date date NOT NULL,
    seats json NOT NULL,
    amount numeric(8,2) NOT NULL,
    booking_status character varying(10)
);


ALTER TABLE public.ticket OWNER TO zenamish;

--
-- Name: train_journey; Type: TABLE; Schema: public; Owner: zenamish
--

CREATE TABLE public.train_journey (
    train_no integer NOT NULL,
    journey text NOT NULL
);


ALTER TABLE public.train_journey OWNER TO zenamish;

--
-- Name: user_info_uid_seq; Type: SEQUENCE; Schema: public; Owner: zenamish
--

CREATE SEQUENCE public.user_info_uid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_info_uid_seq OWNER TO zenamish;

--
-- Name: user_info_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zenamish
--

ALTER SEQUENCE public.user_info_uid_seq OWNED BY public.user_info.uid;


--
-- Name: availability av_id; Type: DEFAULT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.availability ALTER COLUMN av_id SET DEFAULT nextval('public.availability_av_id_seq'::regclass);


--
-- Name: route uti; Type: DEFAULT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.route ALTER COLUMN uti SET DEFAULT nextval('public.route_uti_seq'::regclass);


--
-- Name: stations station_id; Type: DEFAULT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.stations ALTER COLUMN station_id SET DEFAULT nextval('public.stations_station_id_seq'::regclass);


--
-- Name: user_info uid; Type: DEFAULT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.user_info ALTER COLUMN uid SET DEFAULT nextval('public.user_info_uid_seq'::regclass);


--
-- Data for Name: availability; Type: TABLE DATA; Schema: public; Owner: zenamish
--

COPY public.availability (av_id, uti, first_ac, second_ac, third_ac, sleeper, general, date) FROM stdin;
57	7	24	144	320	720	144	2022-04-02
58	7	24	144	320	720	144	2022-04-09
60	8	24	144	320	720	144	2022-04-02
61	8	24	144	320	720	144	2022-04-09
63	9	24	144	320	720	144	2022-04-02
64	9	24	144	320	720	144	2022-04-09
44	1	72	240	640	0	144	2022-03-26
45	1	72	240	640	0	144	2022-04-02
46	1	72	240	640	0	144	2022-04-09
47	2	72	240	640	0	144	2022-03-26
48	2	72	240	640	0	144	2022-04-02
49	2	72	240	640	0	144	2022-04-09
50	3	72	240	640	0	144	2022-03-26
51	3	72	240	640	0	144	2022-04-02
52	3	72	240	640	0	144	2022-04-09
53	6	24	96	320	432	144	2022-04-25
54	6	24	96	320	432	144	2022-04-26
55	6	24	96	320	432	144	2022-04-27
56	7	24	144	329	718	144	2022-03-26
59	8	24	144	329	712	144	2022-03-26
62	9	24	144	329	709	144	2022-03-26
\.


--
-- Data for Name: route; Type: TABLE DATA; Schema: public; Owner: zenamish
--

COPY public.route (uti, train_no, source, destination, departure, arrival) FROM stdin;
1	11114	NDLS	LDH	07:20:00	11:30:00
2	11114	LDH	ASR	11:30:00	13:45:00
3	11114	NDLS	ASR	07:20:00	13:45:00
4	11119	DBG	MYS	15:45:00	23:40:00
5	11118	DLI	ADI	15:20:00	07:40:00
6	11116	UDZ	SDAH	00:25:00	15:10:00
7	19999	NDLS	LDH	07:20:00	11:30:00
8	19999	LDH	ASR	11:30:00	13:45:00
9	19999	NDLS	ASR	07:20:00	13:45:00
\.


--
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: zenamish
--

COPY public.stations (station_id, station_code, station_name) FROM stdin;
1	NDLS	New Delhi
2	LDH	Ludhiana
3	ASR	Amritsar
4	DBG	Darbhanga
5	MYS	Mysore
6	DLI	Delhi
7	ADI	Ahmedabad
8	UDZ	Udaipur
9	SDAH	Sealdah
\.


--
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: zenamish
--

COPY public.ticket (pnr, av_id, train_no, uid, train_name, source, destination, date, seats, amount, booking_status) FROM stdin;
4712450083	62	19999	3	"Test Train"	NDLS	ASR	2022-04-26	{"ticket" : [{"name": "AM", "age": "21", "gender": "M", "seat": "B6/9", "date": "2022-03-26"}]}	1000.00	CANCELLED
1111100005	122	17777	2	Toy Train	LDH	ASR	2022-03-26	{"seat" : 1}	0.00	BOOKED
\.


--
-- Data for Name: train; Type: TABLE DATA; Schema: public; Owner: zenamish
--

COPY public.train (train_no, train_name, first_ac, second_ac, third_ac, sleeper, general) FROM stdin;
11111	Andhra Pradesh Express	1	3	5	10	2
11112	Andhra Pradesh Sampark Kranti	1	3	5	10	2
11113	Ahimsa Express	0	2	5	8	4
11114	Amritsar Shatabdi	3	5	10	0	2
11115	Anandwan Express	1	3	5	10	2
11116	Annanya Express	1	2	5	6	2
11117	Archana Express	1	1	2	5	4
11118	Ashram Express	1	3	5	10	2
11119	Bagmati Express	3	5	10	0	2
19999	Test Train	1	3	5	10	2
17777	Toy Train	0	0	0	0	4
\.


--
-- Data for Name: train_journey; Type: TABLE DATA; Schema: public; Owner: zenamish
--

COPY public.train_journey (train_no, journey) FROM stdin;
11114	NDLS,LDH,ASR
11119	DBG,MYS
11118	DLI,ADI
11116	UDZ,SDAH
19999	NDLS,LDH,ASR
\.


--
-- Data for Name: user_info; Type: TABLE DATA; Schema: public; Owner: zenamish
--

COPY public.user_info (uid, name, password, mobile_no, email, address) FROM stdin;
2	Biju	jibu	1234	biju@iitpkd.ac.in	ahalia cs lab
3	asas	sas	sas	sas	sas
\.


--
-- Name: availability_av_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zenamish
--

SELECT pg_catalog.setval('public.availability_av_id_seq', 64, true);


--
-- Name: route_uti_seq; Type: SEQUENCE SET; Schema: public; Owner: zenamish
--

SELECT pg_catalog.setval('public.route_uti_seq', 29, true);


--
-- Name: stations_station_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zenamish
--

SELECT pg_catalog.setval('public.stations_station_id_seq', 9, true);


--
-- Name: user_info_uid_seq; Type: SEQUENCE SET; Schema: public; Owner: zenamish
--

SELECT pg_catalog.setval('public.user_info_uid_seq', 4, true);


--
-- Name: availability availability_pkey; Type: CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_pkey PRIMARY KEY (av_id);


--
-- Name: route route_pkey; Type: CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.route
    ADD CONSTRAINT route_pkey PRIMARY KEY (uti);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (station_id);


--
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (pnr);


--
-- Name: train_journey train_journey_pkey; Type: CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.train_journey
    ADD CONSTRAINT train_journey_pkey PRIMARY KEY (train_no);


--
-- Name: train train_pkey; Type: CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.train
    ADD CONSTRAINT train_pkey PRIMARY KEY (train_no);


--
-- Name: user_info user_info_email_key; Type: CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.user_info
    ADD CONSTRAINT user_info_email_key UNIQUE (email);


--
-- Name: user_info user_info_pkey; Type: CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.user_info
    ADD CONSTRAINT user_info_pkey PRIMARY KEY (uid);


--
-- Name: idx_av_first_ac; Type: INDEX; Schema: public; Owner: zenamish
--

CREATE INDEX idx_av_first_ac ON public.availability USING btree (first_ac);


--
-- Name: idx_av_general; Type: INDEX; Schema: public; Owner: zenamish
--

CREATE INDEX idx_av_general ON public.availability USING btree (general);


--
-- Name: idx_av_second_ac; Type: INDEX; Schema: public; Owner: zenamish
--

CREATE INDEX idx_av_second_ac ON public.availability USING btree (second_ac);


--
-- Name: idx_av_sleeper; Type: INDEX; Schema: public; Owner: zenamish
--

CREATE INDEX idx_av_sleeper ON public.availability USING btree (sleeper);


--
-- Name: idx_av_third_ac; Type: INDEX; Schema: public; Owner: zenamish
--

CREATE INDEX idx_av_third_ac ON public.availability USING btree (third_ac);


--
-- Name: idx_email; Type: INDEX; Schema: public; Owner: zenamish
--

CREATE INDEX idx_email ON public.user_info USING btree (email);


--
-- Name: idx_email_pwd; Type: INDEX; Schema: public; Owner: zenamish
--

CREATE INDEX idx_email_pwd ON public.user_info USING btree (email, password);


--
-- Name: idx_pnr_hash; Type: INDEX; Schema: public; Owner: zenamish
--

CREATE INDEX idx_pnr_hash ON public.ticket USING hash (pnr);


--
-- Name: idx_src_dest_h; Type: INDEX; Schema: public; Owner: zenamish
--

CREATE INDEX idx_src_dest_h ON public.route USING btree (source, destination);


--
-- Name: idx_train_no_h; Type: INDEX; Schema: public; Owner: zenamish
--

CREATE INDEX idx_train_no_h ON public.train_journey USING hash (train_no);


--
-- Name: ticket trg_chk_book_date; Type: TRIGGER; Schema: public; Owner: zenamish
--

CREATE TRIGGER trg_chk_book_date BEFORE INSERT ON public.ticket FOR EACH ROW EXECUTE FUNCTION public.chk_book_date();


--
-- Name: ticket trg_refresh_chk_pwd_view; Type: TRIGGER; Schema: public; Owner: zenamish
--

CREATE TRIGGER trg_refresh_chk_pwd_view BEFORE INSERT ON public.ticket FOR EACH STATEMENT EXECUTE FUNCTION public.chk_book_date();


--
-- Name: user_info trg_refresh_chk_pwd_view; Type: TRIGGER; Schema: public; Owner: zenamish
--

CREATE TRIGGER trg_refresh_chk_pwd_view AFTER INSERT OR DELETE OR UPDATE ON public.user_info FOR EACH STATEMENT EXECUTE FUNCTION public.refresh_chk_pwd_view();


--
-- Name: availability availability_uti_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_uti_fkey FOREIGN KEY (uti) REFERENCES public.route(uti);


--
-- Name: route route_train_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.route
    ADD CONSTRAINT route_train_no_fkey FOREIGN KEY (train_no) REFERENCES public.train(train_no);


--
-- Name: ticket ticket_train_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_train_no_fkey FOREIGN KEY (train_no) REFERENCES public.train(train_no);


--
-- Name: ticket ticket_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_uid_fkey FOREIGN KEY (uid) REFERENCES public.user_info(uid);


--
-- Name: train_journey train_journey_train_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zenamish
--

ALTER TABLE ONLY public.train_journey
    ADD CONSTRAINT train_journey_train_no_fkey FOREIGN KEY (train_no) REFERENCES public.train(train_no);


--
-- Name: TABLE availability; Type: ACL; Schema: public; Owner: zenamish
--

GRANT UPDATE ON TABLE public.availability TO login_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.availability TO manager;


--
-- Name: TABLE route; Type: ACL; Schema: public; Owner: zenamish
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.route TO manager;


--
-- Name: TABLE train; Type: ACL; Schema: public; Owner: zenamish
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.train TO manager;


--
-- Name: TABLE avail_seats_1_view; Type: ACL; Schema: public; Owner: zenamish
--

GRANT SELECT ON TABLE public.avail_seats_1_view TO guest;


--
-- Name: TABLE avail_seats_2_view; Type: ACL; Schema: public; Owner: zenamish
--

GRANT SELECT ON TABLE public.avail_seats_2_view TO guest;


--
-- Name: TABLE user_info; Type: ACL; Schema: public; Owner: zenamish
--

GRANT UPDATE ON TABLE public.user_info TO login_user;


--
-- Name: TABLE stations; Type: ACL; Schema: public; Owner: zenamish
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.stations TO manager;


--
-- Name: TABLE ticket; Type: ACL; Schema: public; Owner: zenamish
--

GRANT INSERT,UPDATE ON TABLE public.ticket TO login_user;


--
-- Name: TABLE train_journey; Type: ACL; Schema: public; Owner: zenamish
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.train_journey TO manager;


--
-- Name: checkpassword_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: zenamish
--

REFRESH MATERIALIZED VIEW public.checkpassword_view;


--
-- PostgreSQL database dump complete
--

