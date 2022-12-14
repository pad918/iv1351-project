--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.1

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
-- Name: genre_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.genre_type AS ENUM (
    'rock',
    'pop',
    'funk',
    'jazz',
    'disco',
    'classical',
    'folk',
    'soul',
    'reggae'
);


ALTER TYPE public.genre_type OWNER TO postgres;

--
-- Name: instrument_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.instrument_type AS ENUM (
    'piano',
    'guitar',
    'violin',
    'drums'
);


ALTER TYPE public.instrument_type OWNER TO postgres;

--
-- Name: skill_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.skill_level AS ENUM (
    'beginner',
    'intermediate',
    'advanced'
);


ALTER TYPE public.skill_level OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adress (
    id integer NOT NULL,
    zip character(5) NOT NULL,
    street character varying(100) NOT NULL,
    street_number character varying(10) NOT NULL,
    apartment_number character varying(10)
);


ALTER TABLE public.adress OWNER TO postgres;

--
-- Name: adress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adress_id_seq OWNER TO postgres;

--
-- Name: adress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adress_id_seq OWNED BY public.adress.id;


--
-- Name: classroom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classroom (
    id integer NOT NULL,
    adress_id integer NOT NULL,
    building character varying(100) NOT NULL,
    classroom_name character varying(100) NOT NULL
);


ALTER TABLE public.classroom OWNER TO postgres;

--
-- Name: classroom_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classroom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classroom_id_seq OWNER TO postgres;

--
-- Name: classroom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classroom_id_seq OWNED BY public.classroom.id;


--
-- Name: classroom_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classroom_lesson (
    lesson_id integer NOT NULL,
    classroom_id integer NOT NULL
);


ALTER TABLE public.classroom_lesson OWNER TO postgres;

--
-- Name: contact_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_details (
    id integer NOT NULL,
    email character varying(100) NOT NULL,
    primary_phone_number character varying(100) NOT NULL,
    secondary_phone_number character varying(100)
);


ALTER TABLE public.contact_details OWNER TO postgres;

--
-- Name: contact_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contact_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_details_id_seq OWNER TO postgres;

--
-- Name: contact_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contact_details_id_seq OWNED BY public.contact_details.id;


--
-- Name: contact_person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_person (
    student_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    contact_details_id integer NOT NULL
);


ALTER TABLE public.contact_person OWNER TO postgres;

--
-- Name: ensemble_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensemble_lesson (
    scheduled_lesson_id integer NOT NULL,
    genre character varying(100) NOT NULL
);


ALTER TABLE public.ensemble_lesson OWNER TO postgres;

--
-- Name: lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson (
    id integer NOT NULL,
    skill_level public.skill_level NOT NULL,
    lesson_date date NOT NULL,
    start_time time(4) without time zone NOT NULL,
    end_time time(4) without time zone NOT NULL,
    student_price_id integer NOT NULL,
    instructor_price_id integer NOT NULL,
    time_slot_id integer NOT NULL
);


ALTER TABLE public.lesson OWNER TO postgres;

--
-- Name: scheduled_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scheduled_lesson (
    lesson_id integer NOT NULL,
    weekly_schedule_id integer NOT NULL,
    number_of_places integer NOT NULL,
    minimum_enrollments integer NOT NULL
);


ALTER TABLE public.scheduled_lesson OWNER TO postgres;

--
-- Name: ensemble_lesson_joiner; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ensemble_lesson_joiner AS
 SELECT s.id,
    (s.skill_level)::text AS skill_level,
    s.lesson_date,
    s.start_time,
    s.end_time,
    s.student_price_id,
    s.number_of_places,
    s.minimum_enrollments,
    NULL::text AS instrument,
    'ensemble'::text AS lesson_type
   FROM ((public.lesson
     JOIN public.scheduled_lesson ON ((lesson.id = scheduled_lesson.lesson_id))) s
     JOIN public.ensemble_lesson ON ((s.id = ensemble_lesson.scheduled_lesson_id)));


ALTER TABLE public.ensemble_lesson_joiner OWNER TO postgres;

--
-- Name: free_slot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.free_slot (
    time_slot_id integer NOT NULL,
    slot_date date NOT NULL,
    start_time time(4) without time zone NOT NULL,
    end_time time(4) without time zone NOT NULL
);


ALTER TABLE public.free_slot OWNER TO postgres;

--
-- Name: group_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_lesson (
    scheduled_lesson_id integer NOT NULL,
    instrument public.instrument_type NOT NULL
);


ALTER TABLE public.group_lesson OWNER TO postgres;

--
-- Name: group_lesson_joiner; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.group_lesson_joiner AS
 SELECT s.id,
    (s.skill_level)::text AS skill_level,
    s.lesson_date,
    s.start_time,
    s.end_time,
    s.student_price_id,
    s.number_of_places,
    s.minimum_enrollments,
    (group_lesson.instrument)::text AS instrument,
    'group'::text AS lesson_type
   FROM ((public.lesson
     JOIN public.scheduled_lesson ON ((lesson.id = scheduled_lesson.lesson_id))) s
     JOIN public.group_lesson ON ((s.id = group_lesson.scheduled_lesson_id)));


ALTER TABLE public.group_lesson_joiner OWNER TO postgres;

--
-- Name: imported_lessons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imported_lessons (
    id integer NOT NULL,
    date character varying(255),
    type integer,
    instrument character varying(255) DEFAULT NULL::character varying,
    level character varying(255) DEFAULT NULL::character varying,
    start_time character varying(255),
    end_time character varying(255)
);


ALTER TABLE public.imported_lessons OWNER TO postgres;

--
-- Name: imported_lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.imported_lessons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.imported_lessons_id_seq OWNER TO postgres;

--
-- Name: imported_lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.imported_lessons_id_seq OWNED BY public.imported_lessons.id;


--
-- Name: individual_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.individual_lesson (
    lesson_id integer NOT NULL,
    instrument public.instrument_type NOT NULL
);


ALTER TABLE public.individual_lesson OWNER TO postgres;

--
-- Name: individual_lesson_joiner; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.individual_lesson_joiner AS
 SELECT lesson.id,
    (lesson.skill_level)::text AS skill_level,
    lesson.lesson_date,
    lesson.start_time,
    lesson.end_time,
    lesson.student_price_id,
    NULL::integer AS number_of_places,
    NULL::integer AS minimum_enrollments,
    (individual_lesson.instrument)::text AS instrument,
    'individual'::text AS lesson_type
   FROM (public.lesson
     JOIN public.individual_lesson ON ((lesson.id = individual_lesson.lesson_id)));


ALTER TABLE public.individual_lesson_joiner OWNER TO postgres;

--
-- Name: instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor (
    person_id integer NOT NULL
);


ALTER TABLE public.instructor OWNER TO postgres;

--
-- Name: instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument (
    id integer NOT NULL,
    instrument_model_id integer NOT NULL
);


ALTER TABLE public.instrument OWNER TO postgres;

--
-- Name: instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instrument_id_seq OWNER TO postgres;

--
-- Name: instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_id_seq OWNED BY public.instrument.id;


--
-- Name: instrument_lease; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_lease (
    id integer NOT NULL,
    student_id integer,
    instrument_id integer NOT NULL,
    lease_start_date date NOT NULL,
    lease_end_date date NOT NULL
);


ALTER TABLE public.instrument_lease OWNER TO postgres;

--
-- Name: instrument_lease_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrument_lease_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instrument_lease_id_seq OWNER TO postgres;

--
-- Name: instrument_lease_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_lease_id_seq OWNED BY public.instrument_lease.id;


--
-- Name: instrument_model; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_model (
    id integer NOT NULL,
    instrument public.instrument_type NOT NULL,
    brand character varying(100) NOT NULL,
    model character varying(100) NOT NULL,
    monthly_price real NOT NULL
);


ALTER TABLE public.instrument_model OWNER TO postgres;

--
-- Name: instrument_model_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrument_model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instrument_model_id_seq OWNER TO postgres;

--
-- Name: instrument_model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_model_id_seq OWNED BY public.instrument_model.id;


--
-- Name: learns_instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.learns_instrument (
    instrument public.instrument_type NOT NULL,
    student_id integer NOT NULL
);


ALTER TABLE public.learns_instrument OWNER TO postgres;

--
-- Name: lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_id_seq OWNER TO postgres;

--
-- Name: lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_id_seq OWNED BY public.lesson.id;


--
-- Name: scheduled_lesson_joiner; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.scheduled_lesson_joiner AS
 SELECT sqlforcedmetonamethis1.id,
    sqlforcedmetonamethis1.skill_level,
    sqlforcedmetonamethis1.lesson_date,
    sqlforcedmetonamethis1.start_time,
    sqlforcedmetonamethis1.end_time,
    sqlforcedmetonamethis1.student_price_id,
    sqlforcedmetonamethis1.number_of_places,
    sqlforcedmetonamethis1.minimum_enrollments,
    sqlforcedmetonamethis1.instrument,
    sqlforcedmetonamethis1.lesson_type
   FROM ( SELECT group_lesson_joiner.id,
            group_lesson_joiner.skill_level,
            group_lesson_joiner.lesson_date,
            group_lesson_joiner.start_time,
            group_lesson_joiner.end_time,
            group_lesson_joiner.student_price_id,
            group_lesson_joiner.number_of_places,
            group_lesson_joiner.minimum_enrollments,
            group_lesson_joiner.instrument,
            group_lesson_joiner.lesson_type
           FROM public.group_lesson_joiner
        UNION ALL
         SELECT ensemble_lesson_joiner.id,
            ensemble_lesson_joiner.skill_level,
            ensemble_lesson_joiner.lesson_date,
            ensemble_lesson_joiner.start_time,
            ensemble_lesson_joiner.end_time,
            ensemble_lesson_joiner.student_price_id,
            ensemble_lesson_joiner.number_of_places,
            ensemble_lesson_joiner.minimum_enrollments,
            ensemble_lesson_joiner.instrument,
            ensemble_lesson_joiner.lesson_type
           FROM public.ensemble_lesson_joiner) sqlforcedmetonamethis1;


ALTER TABLE public.scheduled_lesson_joiner OWNER TO postgres;

--
-- Name: lesson_joiner_without_price; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lesson_joiner_without_price AS
 SELECT sqlforcedmetonamethis2.id,
    sqlforcedmetonamethis2.skill_level,
    sqlforcedmetonamethis2.lesson_date,
    sqlforcedmetonamethis2.start_time,
    sqlforcedmetonamethis2.end_time,
    sqlforcedmetonamethis2.student_price_id,
    sqlforcedmetonamethis2.number_of_places,
    sqlforcedmetonamethis2.minimum_enrollments,
    sqlforcedmetonamethis2.instrument,
    sqlforcedmetonamethis2.lesson_type
   FROM ( SELECT scheduled_lesson_joiner.id,
            scheduled_lesson_joiner.skill_level,
            scheduled_lesson_joiner.lesson_date,
            scheduled_lesson_joiner.start_time,
            scheduled_lesson_joiner.end_time,
            scheduled_lesson_joiner.student_price_id,
            scheduled_lesson_joiner.number_of_places,
            scheduled_lesson_joiner.minimum_enrollments,
            scheduled_lesson_joiner.instrument,
            scheduled_lesson_joiner.lesson_type
           FROM public.scheduled_lesson_joiner
        UNION ALL
         SELECT individual_lesson_joiner.id,
            individual_lesson_joiner.skill_level,
            individual_lesson_joiner.lesson_date,
            individual_lesson_joiner.start_time,
            individual_lesson_joiner.end_time,
            individual_lesson_joiner.student_price_id,
            individual_lesson_joiner.number_of_places,
            individual_lesson_joiner.minimum_enrollments,
            individual_lesson_joiner.instrument,
            individual_lesson_joiner.lesson_type
           FROM public.individual_lesson_joiner) sqlforcedmetonamethis2;


ALTER TABLE public.lesson_joiner_without_price OWNER TO postgres;

--
-- Name: price_information; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_information (
    id integer NOT NULL,
    pricing_name character varying(100) NOT NULL,
    advanced_individual_price real NOT NULL,
    intermediate_individual_price real NOT NULL,
    beginner_individual_price real NOT NULL,
    advanced_group_price real NOT NULL,
    intermediate_group_price real NOT NULL,
    beginner_group_price real NOT NULL,
    sibling_discount real
);


ALTER TABLE public.price_information OWNER TO postgres;

--
-- Name: student_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_lesson (
    student_id integer NOT NULL,
    lesson_id integer NOT NULL
);


ALTER TABLE public.student_lesson OWNER TO postgres;

--
-- Name: lesson_joiner; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lesson_joiner AS
 SELECT l.id,
    l.skill_level,
    l.lesson_date,
    l.start_time,
    l.end_time,
        CASE
            WHEN ((l.lesson_type = 'individual'::text) AND (l.skill_level = 'advanced'::text)) THEN p.advanced_individual_price
            WHEN ((l.lesson_type = 'individual'::text) AND (l.skill_level = 'intermediate'::text)) THEN p.intermediate_individual_price
            WHEN ((l.lesson_type = 'individual'::text) AND (l.skill_level = 'beginner'::text)) THEN p.beginner_individual_price
            WHEN (l.skill_level = 'advanced'::text) THEN p.advanced_group_price
            WHEN (l.skill_level = 'intermediate'::text) THEN p.intermediate_group_price
            WHEN (l.skill_level = 'beginner'::text) THEN p.beginner_group_price
            ELSE NULL::real
        END AS price,
    p.sibling_discount,
    l.number_of_places,
    l.minimum_enrollments,
    ( SELECT count(*) AS count
           FROM public.student_lesson sl
          WHERE (sl.lesson_id = l.id)) AS participants,
    l.instrument,
    l.lesson_type
   FROM public.lesson_joiner_without_price l,
    public.price_information p
  WHERE (l.student_price_id = p.id);


ALTER TABLE public.lesson_joiner OWNER TO postgres;

--
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    id integer NOT NULL,
    person_number character(12) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    adress_id integer NOT NULL,
    contact_details_id integer NOT NULL
);


ALTER TABLE public.person OWNER TO postgres;

--
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_id_seq OWNER TO postgres;

--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_id_seq OWNED BY public.person.id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    person_id integer NOT NULL,
    skill_level public.skill_level NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: person_joiner; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.person_joiner AS
 SELECT w.id,
    w.person_number,
    w.first_name,
    w.last_name,
    (w.skill_level)::text AS skill_level,
    a.zip,
    a.street,
    a.street_number,
    a.apartment_number,
    w.email,
    w.primary_phone_number,
    w.secondary_phone_number
   FROM (((public.person p
     JOIN public.student s ON ((p.id = s.person_id))) k
     JOIN public.contact_details c(c_id, email, primary_phone_number, secondary_phone_number) ON ((k.contact_details_id = c.c_id))) w
     JOIN public.adress a ON ((a.id = w.adress_id)));


ALTER TABLE public.person_joiner OWNER TO postgres;

--
-- Name: price_information_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_information_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.price_information_id_seq OWNER TO postgres;

--
-- Name: price_information_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_information_id_seq OWNED BY public.price_information.id;


--
-- Name: sibling_relation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sibling_relation (
    student_id1 integer NOT NULL,
    student_id2 integer NOT NULL
);


ALTER TABLE public.sibling_relation OWNER TO postgres;

--
-- Name: teaches_instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teaches_instrument (
    instrument public.instrument_type NOT NULL,
    instructor_id integer NOT NULL
);


ALTER TABLE public.teaches_instrument OWNER TO postgres;

--
-- Name: time_slot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.time_slot (
    id integer NOT NULL,
    instructor_id integer NOT NULL
);


ALTER TABLE public.time_slot OWNER TO postgres;

--
-- Name: time_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.time_slot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_slot_id_seq OWNER TO postgres;

--
-- Name: time_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.time_slot_id_seq OWNED BY public.time_slot.id;


--
-- Name: weekly_schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weekly_schedule (
    id integer NOT NULL,
    year integer NOT NULL,
    week integer NOT NULL
);


ALTER TABLE public.weekly_schedule OWNER TO postgres;

--
-- Name: weekly_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.weekly_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.weekly_schedule_id_seq OWNER TO postgres;

--
-- Name: weekly_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.weekly_schedule_id_seq OWNED BY public.weekly_schedule.id;


--
-- Name: adress id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adress ALTER COLUMN id SET DEFAULT nextval('public.adress_id_seq'::regclass);


--
-- Name: classroom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom ALTER COLUMN id SET DEFAULT nextval('public.classroom_id_seq'::regclass);


--
-- Name: contact_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_details ALTER COLUMN id SET DEFAULT nextval('public.contact_details_id_seq'::regclass);


--
-- Name: imported_lessons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imported_lessons ALTER COLUMN id SET DEFAULT nextval('public.imported_lessons_id_seq'::regclass);


--
-- Name: instrument id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument ALTER COLUMN id SET DEFAULT nextval('public.instrument_id_seq'::regclass);


--
-- Name: instrument_lease id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_lease ALTER COLUMN id SET DEFAULT nextval('public.instrument_lease_id_seq'::regclass);


--
-- Name: instrument_model id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_model ALTER COLUMN id SET DEFAULT nextval('public.instrument_model_id_seq'::regclass);


--
-- Name: lesson id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN id SET DEFAULT nextval('public.lesson_id_seq'::regclass);


--
-- Name: person id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person ALTER COLUMN id SET DEFAULT nextval('public.person_id_seq'::regclass);


--
-- Name: price_information id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_information ALTER COLUMN id SET DEFAULT nextval('public.price_information_id_seq'::regclass);


--
-- Name: time_slot id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_slot ALTER COLUMN id SET DEFAULT nextval('public.time_slot_id_seq'::regclass);


--
-- Name: weekly_schedule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weekly_schedule ALTER COLUMN id SET DEFAULT nextval('public.weekly_schedule_id_seq'::regclass);


--
-- Data for Name: adress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adress (id, zip, street, street_number, apartment_number) FROM stdin;
2867	68782	Ap #602-8347 Risus. St.	27	\N
2868	07499	3051 Ut, Street	16	\N
2869	46668	Ap #346-8610 Donec Rd.	75	\N
2870	75318	Ap #263-5393 Adipiscing Av.	71	\N
2871	86182	2281 Vel, Avenue	44	\N
2872	05116	Ap #696-8151 Dictum St.	33	\N
2873	09418	Ap #739-2821 Suspendisse Ave	84	\N
2874	13446	4353 Et Rd.	21	\N
2875	31068	142-2528 Purus Avenue	55	\N
2876	53684	P.O. Box 598, 1455 Ipsum Street	36	\N
2877	14264	Kvartettvagen	2-6	\N
\.


--
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classroom (id, adress_id, building, classroom_name) FROM stdin;
236	2877	EE36	Teknik
\.


--
-- Data for Name: classroom_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classroom_lesson (lesson_id, classroom_id) FROM stdin;
\.


--
-- Data for Name: contact_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_details (id, email, primary_phone_number, secondary_phone_number) FROM stdin;
2804	sapien@protonmail.ca	077-136-3657	\N
2805	congue@aol.ca	045-045-7764	\N
2806	lobortis.class.aptent@yahoo.com	061-434-2838	\N
2807	malesuada.vel.venenatis@aol.edu	052-261-4731	\N
2808	eget.varius.ultrices@hotmail.net	053-858-7542	\N
2809	risus.a@icloud.com	022-786-3691	\N
2810	sollicitudin.a.malesuada@google.ca	066-103-2764	\N
2811	et.netus@icloud.ca	063-338-6212	\N
2812	nisi.aenean@outlook.couk	003-111-9873	\N
2813	auctor.non.feugiat@protonmail.net	081-250-4153	\N
2814	sven.svensson@telia.se	0768685460	\N
\.


--
-- Data for Name: contact_person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_person (student_id, first_name, last_name, contact_details_id) FROM stdin;
2399	Sven	Svensson	2814
\.


--
-- Data for Name: ensemble_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ensemble_lesson (scheduled_lesson_id, genre) FROM stdin;
15101	rock
15108	rock
15117	rock
15130	rock
15111	rock
15123	rock
15103	rock
\.


--
-- Data for Name: free_slot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.free_slot (time_slot_id, slot_date, start_time, end_time) FROM stdin;
\.


--
-- Data for Name: group_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_lesson (scheduled_lesson_id, instrument) FROM stdin;
15129	piano
15105	piano
15116	piano
15107	guitar
15102	guitar
15119	violin
15127	violin
15106	guitar
15109	piano
15131	guitar
15136	piano
15128	guitar
15134	piano
15125	guitar
15114	violin
\.


--
-- Data for Name: imported_lessons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.imported_lessons (id, date, type, instrument, level, start_time, end_time) FROM stdin;
1	2020-07-31	1	piano	intermediate	11:51	14:39
2	2022-02-04	1	guitar	intermediate	11:28	14:56
3	2020-07-15	0	violin	intermediate	8:46	16:33
4	2022-09-23	1	piano	intermediate	9:05	14:51
5	2021-10-02	0	violin	intermediate	11:05	18:36
6	2021-01-07	2	violin	advanced	9:35	16:18
7	2022-02-01	1	violin	intermediate	9:50	18:20
8	2021-08-04	1	piano	beginner	11:04	13:08
9	2021-07-23	0	piano	intermediate	8:14	12:10
10	2022-07-06	0	guitar	intermediate	10:27	12:03
11	2020-12-21	1	piano	intermediate	10:04	18:19
12	2021-08-18	0	violin	beginner	8:10	17:49
13	2022-02-20	1	piano	intermediate	8:45	17:08
14	2021-04-28	0	violin	advanced	9:07	12:02
15	2020-11-29	2	piano	beginner	10:36	18:31
16	2022-01-14	1	piano	advanced	11:24	16:24
17	2020-11-03	0	guitar	intermediate	8:32	16:52
18	2022-12-05	0	violin	beginner	8:15	14:55
19	2022-10-22	2	guitar	intermediate	10:16	18:16
20	2022-12-15	1	guitar	advanced	9:35	15:42
21	2021-09-26	0	piano	beginner	9:30	16:17
22	2022-09-06	1	guitar	intermediate	9:49	15:18
23	2020-09-26	1	piano	beginner	11:47	14:32
24	2022-11-16	2	violin	advanced	11:03	14:55
25	2020-10-07	0	violin	intermediate	10:58	14:19
26	2022-12-09	1	guitar	beginner	9:02	13:53
27	2020-09-04	1	violin	beginner	9:22	16:43
28	2021-01-17	1	piano	advanced	11:27	18:41
29	2020-09-15	1	guitar	beginner	8:59	13:05
30	2021-12-23	2	violin	intermediate	9:05	18:21
31	2020-12-20	2	piano	advanced	9:31	15:33
32	2021-02-24	2	guitar	advanced	11:58	15:08
33	2021-12-16	1	violin	advanced	9:14	13:53
34	2022-07-15	2	violin	beginner	9:46	16:50
35	2022-07-02	1	guitar	intermediate	8:46	14:38
36	2021-04-28	0	piano	intermediate	8:24	13:07
37	2020-07-13	1	guitar	beginner	8:43	12:00
38	2022-09-05	0	piano	intermediate	10:44	13:43
39	2020-07-13	2	violin	intermediate	10:23	12:23
40	2022-03-20	1	guitar	intermediate	11:25	13:50
41	2020-08-03	2	violin	intermediate	10:16	17:56
42	2020-12-09	2	piano	intermediate	8:54	18:58
43	2021-05-31	1	piano	advanced	8:41	12:34
44	2022-10-16	1	guitar	intermediate	11:12	13:12
45	2021-02-07	1	guitar	beginner	10:43	17:00
46	2021-01-08	1	guitar	intermediate	8:54	16:36
47	2020-07-30	1	violin	intermediate	10:28	18:52
48	2021-06-17	1	violin	beginner	9:29	18:15
49	2021-06-24	0	guitar	intermediate	8:48	18:44
50	2021-06-02	2	guitar	beginner	8:58	18:43
51	2021-01-12	0	piano	intermediate	9:46	12:54
52	2022-05-26	2	violin	beginner	10:38	16:19
53	2021-07-28	1	violin	beginner	11:38	12:58
54	2021-11-18	1	piano	beginner	10:19	17:15
55	2022-02-12	1	piano	advanced	9:21	16:26
56	2021-07-26	0	violin	beginner	9:06	13:44
57	2020-09-04	0	violin	advanced	11:40	13:47
58	2022-04-24	1	guitar	beginner	10:39	15:15
59	2020-08-13	1	guitar	beginner	11:07	15:48
60	2021-08-04	2	violin	intermediate	9:51	15:41
61	2021-06-14	0	piano	advanced	11:10	12:38
62	2022-12-21	1	piano	advanced	10:27	13:59
63	2021-11-30	1	piano	intermediate	9:03	17:34
64	2020-10-26	1	guitar	intermediate	10:22	12:12
65	2022-04-16	0	violin	intermediate	10:29	12:14
66	2022-10-01	0	piano	intermediate	11:38	16:08
67	2022-03-29	2	guitar	beginner	10:27	14:03
68	2021-01-22	1	guitar	beginner	9:01	13:05
69	2021-09-08	0	violin	advanced	10:15	12:11
70	2022-08-13	1	piano	advanced	11:06	14:30
71	2021-07-08	0	piano	intermediate	10:26	18:59
72	2021-03-07	1	piano	advanced	8:32	16:22
73	2021-08-28	0	guitar	beginner	10:00	14:56
74	2021-08-07	1	guitar	beginner	9:06	18:15
75	2021-09-12	1	piano	beginner	10:46	13:43
76	2022-09-07	2	piano	beginner	8:34	13:12
77	2021-04-17	2	piano	beginner	8:56	18:12
78	2022-01-21	1	piano	advanced	9:03	16:25
79	2021-07-30	1	guitar	advanced	8:17	16:03
80	2022-07-08	0	guitar	intermediate	9:36	15:23
81	2021-07-14	2	guitar	beginner	11:55	17:03
82	2022-09-29	1	guitar	intermediate	11:02	12:37
83	2020-09-26	1	piano	advanced	9:28	15:26
84	2022-01-01	1	violin	advanced	11:54	15:24
85	2022-01-19	2	guitar	intermediate	11:17	13:46
86	2021-09-01	1	piano	advanced	10:59	15:55
87	2021-05-16	0	guitar	intermediate	10:21	14:32
88	2021-11-24	2	violin	advanced	8:30	12:18
89	2021-04-02	0	piano	advanced	8:55	15:48
90	2021-11-06	0	guitar	intermediate	9:53	18:24
91	2022-04-19	1	guitar	intermediate	9:49	13:20
92	2022-08-11	2	violin	beginner	8:10	14:10
93	2021-07-23	1	guitar	intermediate	10:56	18:51
94	2021-05-13	1	violin	intermediate	10:08	17:24
95	2020-12-14	1	piano	advanced	11:19	16:31
96	2021-07-13	0	violin	intermediate	9:44	16:01
97	2022-05-13	0	piano	intermediate	8:50	17:26
98	2022-01-17	1	piano	intermediate	8:53	15:46
99	2021-01-09	2	piano	advanced	11:58	14:12
100	2020-10-23	2	guitar	advanced	8:36	14:34
101	2022-12-16	2	violin	intermediate	9:04	12:12
102	2022-12-14	2	piano	advanced	9:43	17:30
103	2022-12-12	1	guitar	advanced	8:01	17:45
104	2022-12-16	0	violin	intermediate	10:43	17:42
105	2022-12-13	1	violin	advanced	9:40	17:32
106	2022-12-14	1	violin	advanced	9:00	15:43
107	2022-12-16	2	guitar	beginner	8:25	18:52
108	2022-12-13	1	violin	beginner	9:04	18:22
109	2022-12-14	1	guitar	advanced	11:30	16:24
110	2022-12-15	1	violin	intermediate	11:50	16:50
111	2022-12-16	1	piano	intermediate	10:18	14:13
112	2022-12-16	2	guitar	intermediate	8:33	17:11
113	2022-12-14	1	violin	advanced	10:38	16:49
114	2022-12-16	1	violin	beginner	9:25	18:43
115	2022-12-16	0	violin	beginner	8:13	14:12
116	2022-12-15	2	guitar	beginner	9:29	15:43
117	2022-12-15	0	guitar	beginner	9:52	18:32
118	2022-12-15	0	piano	beginner	10:15	16:45
119	2022-12-12	1	piano	advanced	9:07	17:53
120	2022-12-16	0	piano	intermediate	10:12	16:41
\.


--
-- Data for Name: individual_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.individual_lesson (lesson_id, instrument) FROM stdin;
15082	violin
15138	violin
15124	piano
15132	violin
15113	violin
15095	guitar
15137	piano
15092	violin
15112	piano
15120	guitar
15104	piano
15126	violin
15087	violin
15118	piano
15135	violin
15121	piano
15133	guitar
15115	guitar
15110	piano
15139	guitar
15122	violin
\.


--
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructor (person_id) FROM stdin;
2403
2404
2405
2406
\.


--
-- Data for Name: instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument (id, instrument_model_id) FROM stdin;
425	213
426	213
\.


--
-- Data for Name: instrument_lease; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument_lease (id, student_id, instrument_id, lease_start_date, lease_end_date) FROM stdin;
213	2397	425	2022-11-01	2022-12-01
\.


--
-- Data for Name: instrument_model; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument_model (id, instrument, brand, model, monthly_price) FROM stdin;
213	violin	yamaha	hd650	666
\.


--
-- Data for Name: learns_instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.learns_instrument (instrument, student_id) FROM stdin;
violin	2397
violin	2398
violin	2399
violin	2400
violin	2401
violin	2402
\.


--
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson (id, skill_level, lesson_date, start_time, end_time, student_price_id, instructor_price_id, time_slot_id) FROM stdin;
15082	intermediate	2020-07-15	08:46:00	16:33:00	331	332	29803
15087	advanced	2020-09-04	11:40:00	13:47:00	331	332	29808
15092	intermediate	2020-10-07	10:58:00	14:19:00	331	332	29813
15095	intermediate	2020-11-03	08:32:00	16:52:00	331	332	29816
15101	advanced	2021-01-07	09:35:00	16:18:00	331	332	29822
15102	intermediate	2021-01-08	08:54:00	16:36:00	331	332	29823
15103	advanced	2021-01-09	11:58:00	14:12:00	331	332	29824
15104	intermediate	2021-01-12	09:46:00	12:54:00	331	332	29825
15105	advanced	2021-01-17	11:27:00	18:41:00	331	332	29826
15106	beginner	2021-01-22	09:01:00	13:05:00	331	332	29827
15107	beginner	2021-02-07	10:43:00	17:00:00	331	332	29828
15108	advanced	2021-02-24	11:58:00	15:08:00	331	332	29829
15109	advanced	2021-03-07	08:32:00	16:22:00	331	332	29830
15110	advanced	2021-04-02	08:55:00	15:48:00	331	332	29831
15111	beginner	2021-04-17	08:56:00	18:12:00	331	332	29832
15112	intermediate	2021-04-28	08:24:00	13:07:00	331	332	29833
15113	advanced	2021-04-28	09:07:00	12:02:00	331	332	29834
15114	intermediate	2021-05-13	10:08:00	17:24:00	331	332	29835
15115	intermediate	2021-05-16	10:21:00	14:32:00	331	332	29836
15116	advanced	2021-05-31	08:41:00	12:34:00	331	332	29837
15117	beginner	2021-06-02	08:58:00	18:43:00	331	332	29838
15118	advanced	2021-06-14	11:10:00	12:38:00	331	332	29839
15119	beginner	2021-06-17	09:29:00	18:15:00	331	332	29840
15120	intermediate	2021-06-24	08:48:00	18:44:00	331	332	29841
15121	intermediate	2021-07-08	10:26:00	18:59:00	331	332	29842
15122	intermediate	2021-07-13	09:44:00	16:01:00	331	332	29843
15123	beginner	2021-07-14	11:55:00	17:03:00	331	332	29844
15124	intermediate	2021-07-23	08:14:00	12:10:00	331	332	29845
15125	intermediate	2021-07-23	10:56:00	18:51:00	331	332	29846
15126	beginner	2021-07-26	09:06:00	13:44:00	331	332	29847
15127	beginner	2021-07-28	11:38:00	12:58:00	331	332	29848
15128	advanced	2021-07-30	08:17:00	16:03:00	331	332	29849
15129	beginner	2021-08-04	11:04:00	13:08:00	331	332	29850
15130	intermediate	2021-08-04	09:51:00	15:41:00	331	332	29851
15131	beginner	2021-08-07	09:06:00	18:15:00	331	332	29852
15132	beginner	2021-08-18	08:10:00	17:49:00	331	332	29853
15133	beginner	2021-08-28	10:00:00	14:56:00	331	332	29854
15134	advanced	2021-09-01	10:59:00	15:55:00	331	332	29855
15135	advanced	2021-09-08	10:15:00	12:11:00	331	332	29856
15136	beginner	2021-09-12	10:46:00	13:43:00	331	332	29857
15137	beginner	2021-09-26	09:30:00	16:17:00	331	332	29858
15138	intermediate	2021-10-02	11:05:00	18:36:00	331	332	29859
15139	intermediate	2021-11-06	09:53:00	18:24:00	331	332	29860
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person (id, person_number, first_name, last_name, adress_id, contact_details_id) FROM stdin;
2397	162135287485	Serina	Larson	2867	2804
2398	026238112238	Paula	Sims	2868	2805
2399	539242524046	Sacha	Edwards	2869	2806
2400	184410375244	Baxter	Hensley	2870	2807
2401	867484858738	Tiger	Maldonado	2871	2808
2402	187838245442	Len	Patton	2872	2809
2403	579775470614	Buckminster	Owens	2873	2810
2404	107371896159	Kuame	Harrington	2874	2811
2405	444734773476	Judith	Bowen	2875	2812
2406	460240030468	Berk	Welch	2876	2813
\.


--
-- Data for Name: price_information; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_information (id, pricing_name, advanced_individual_price, intermediate_individual_price, beginner_individual_price, advanced_group_price, intermediate_group_price, beginner_group_price, sibling_discount) FROM stdin;
331	student pricing	1000	800	800	500	300	300	0.1
332	instructor pricing	600	400	400	1000	800	800	0
\.


--
-- Data for Name: scheduled_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scheduled_lesson (lesson_id, weekly_schedule_id, number_of_places, minimum_enrollments) FROM stdin;
15101	18667	5	3
15102	18667	5	3
15103	18667	5	3
15105	18668	5	3
15106	18669	5	3
15107	18671	5	3
15108	18674	5	3
15109	18675	5	3
15111	18681	5	3
15114	18685	5	3
15116	18688	5	3
15117	18688	5	3
15119	18690	5	3
15123	18694	5	3
15125	18695	5	3
15127	18696	5	3
15128	18696	5	3
15129	18697	5	3
15130	18697	5	3
15131	18697	5	3
15134	18701	5	3
15136	18702	5	3
\.


--
-- Data for Name: sibling_relation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sibling_relation (student_id1, student_id2) FROM stdin;
2397	2400
2397	2399
2399	2400
2398	2401
2400	2397
2399	2397
2400	2399
2401	2398
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (person_id, skill_level) FROM stdin;
2397	beginner
2398	beginner
2399	beginner
2400	beginner
2401	beginner
2402	beginner
\.


--
-- Data for Name: student_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_lesson (student_id, lesson_id) FROM stdin;
2398	15136
2401	15134
2402	15109
2400	15111
2398	15105
2397	15105
2400	15119
2402	15127
2397	15103
2399	15105
2402	15106
2397	15117
2398	15129
2402	15129
2399	15108
2399	15134
2398	15101
2397	15106
2400	15116
2401	15109
2401	15127
2402	15130
2401	15129
2397	15134
2399	15102
2402	15128
2400	15130
2399	15130
2397	15127
2399	15119
2400	15134
2398	15103
2400	15108
2400	15129
2400	15101
2399	15117
2399	15109
2399	15123
2398	15106
2401	15108
2397	15102
2400	15103
2399	15107
2400	15123
2400	15106
2402	15105
2399	15129
2400	15136
2402	15134
2401	15106
2401	15131
2402	15103
2400	15125
2401	15103
2401	15136
2399	15103
2398	15111
2397	15111
2398	15123
2398	15125
2401	15119
2401	15116
2398	15102
2402	15111
2397	15114
2400	15109
2399	15128
2398	15117
2399	15127
2402	15119
2402	15117
2400	15102
2402	15108
2397	15136
2400	15128
2399	15106
2402	15107
2401	15123
2399	15111
2401	15105
2401	15101
2400	15107
2401	15125
2397	15123
2400	15114
2401	15107
2399	15131
2397	15101
2397	15128
2399	15114
2402	15116
2397	15109
2398	15134
2402	15136
2402	15114
2397	15131
2397	15125
2397	15116
2397	15130
2397	15108
2397	15119
2397	15107
2398	15114
2402	15101
2398	15127
2398	15109
2402	15125
2400	15117
2399	15116
2402	15102
2401	15128
2398	15131
2398	15119
2401	15114
2398	15130
2402	15123
2398	15116
2402	15131
2401	15102
2401	15117
2398	15107
2400	15127
2401	15130
2399	15101
2401	15111
2400	15105
2398	15128
2397	15129
2398	15108
2399	15136
2400	15131
2399	15125
2402	15082
2400	15087
2401	15092
2400	15095
2398	15104
2397	15110
2400	15112
2402	15113
2401	15115
2400	15118
2399	15120
2398	15121
2398	15122
2402	15124
2398	15126
2399	15132
2401	15133
2402	15135
2397	15137
2397	15138
2400	15139
\.


--
-- Data for Name: teaches_instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teaches_instrument (instrument, instructor_id) FROM stdin;
violin	2403
violin	2404
violin	2405
violin	2406
\.


--
-- Data for Name: time_slot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.time_slot (id, instructor_id) FROM stdin;
29801	2403
29802	2403
29803	2403
29804	2403
29805	2403
29806	2403
29807	2403
29808	2403
29809	2403
29810	2403
29811	2403
29812	2403
29813	2403
29814	2403
29815	2403
29816	2403
29817	2403
29818	2403
29819	2403
29820	2403
29821	2403
29822	2403
29823	2403
29824	2403
29825	2403
29826	2403
29827	2403
29828	2403
29829	2403
29830	2403
29831	2403
29832	2403
29833	2403
29834	2403
29835	2403
29836	2403
29837	2403
29838	2403
29839	2403
29840	2403
29841	2403
29842	2403
29843	2403
29844	2403
29845	2403
29846	2403
29847	2403
29848	2403
29849	2403
29850	2403
29851	2403
29852	2403
29853	2403
29854	2403
29855	2403
29856	2403
29857	2403
29858	2403
29859	2403
29860	2403
\.


--
-- Data for Name: weekly_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weekly_schedule (id, year, week) FROM stdin;
18667	2021	1
18668	2021	2
18669	2021	3
18670	2021	4
18671	2021	5
18672	2021	6
18673	2021	7
18674	2021	8
18675	2021	9
18676	2021	10
18677	2021	11
18678	2021	12
18679	2021	13
18680	2021	14
18681	2021	15
18682	2021	16
18683	2021	17
18684	2021	18
18685	2021	19
18686	2021	20
18687	2021	21
18688	2021	22
18689	2021	23
18690	2021	24
18691	2021	25
18692	2021	26
18693	2021	27
18694	2021	28
18695	2021	29
18696	2021	30
18697	2021	31
18698	2021	32
18699	2021	33
18700	2021	34
18701	2021	35
18702	2021	36
18703	2021	37
18704	2021	38
18705	2021	39
18706	2021	40
18707	2021	41
18708	2021	42
18709	2021	43
18710	2021	44
18711	2021	45
18712	2021	46
18713	2021	47
18714	2021	48
18715	2021	49
18716	2021	50
18717	2021	51
18718	2021	52
18719	2022	1
18720	2022	2
18721	2022	3
18722	2022	4
18723	2022	5
18724	2022	6
18725	2022	7
18726	2022	8
18727	2022	9
18728	2022	10
18729	2022	11
18730	2022	12
18731	2022	13
18732	2022	14
18733	2022	15
18734	2022	16
18735	2022	17
18736	2022	18
18737	2022	19
18738	2022	20
18739	2022	21
18740	2022	22
18741	2022	23
18742	2022	24
18743	2022	25
18744	2022	26
18745	2022	27
18746	2022	28
18747	2022	29
18748	2022	30
18749	2022	31
18750	2022	32
18751	2022	33
18752	2022	34
18753	2022	35
18754	2022	36
18755	2022	37
18756	2022	38
18757	2022	39
18758	2022	40
18759	2022	41
18760	2022	42
18761	2022	43
18762	2022	44
18763	2022	45
18764	2022	46
18765	2022	47
18766	2022	48
18767	2022	49
18768	2022	50
18769	2022	51
18770	2022	52
\.


--
-- Name: adress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adress_id_seq', 2877, true);


--
-- Name: classroom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classroom_id_seq', 236, true);


--
-- Name: contact_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contact_details_id_seq', 2814, true);


--
-- Name: imported_lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.imported_lessons_id_seq', 120, true);


--
-- Name: instrument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_id_seq', 426, true);


--
-- Name: instrument_lease_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_lease_id_seq', 213, true);


--
-- Name: instrument_model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_model_id_seq', 213, true);


--
-- Name: lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_id_seq', 15139, true);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_id_seq', 2406, true);


--
-- Name: price_information_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.price_information_id_seq', 332, true);


--
-- Name: time_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.time_slot_id_seq', 29860, true);


--
-- Name: weekly_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weekly_schedule_id_seq', 18770, true);


--
-- Name: adress adress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adress
    ADD CONSTRAINT adress_pkey PRIMARY KEY (id);


--
-- Name: classroom_lesson classroom_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom_lesson
    ADD CONSTRAINT classroom_lesson_pkey PRIMARY KEY (lesson_id, classroom_id);


--
-- Name: classroom classroom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_pkey PRIMARY KEY (id);


--
-- Name: contact_details contact_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_details
    ADD CONSTRAINT contact_details_pkey PRIMARY KEY (id);


--
-- Name: contact_person contact_person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT contact_person_pkey PRIMARY KEY (student_id);


--
-- Name: ensemble_lesson ensemble_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble_lesson
    ADD CONSTRAINT ensemble_lesson_pkey PRIMARY KEY (scheduled_lesson_id);


--
-- Name: free_slot free_slot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.free_slot
    ADD CONSTRAINT free_slot_pkey PRIMARY KEY (time_slot_id);


--
-- Name: group_lesson group_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_pkey PRIMARY KEY (scheduled_lesson_id);


--
-- Name: imported_lessons imported_lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imported_lessons
    ADD CONSTRAINT imported_lessons_pkey PRIMARY KEY (id);


--
-- Name: individual_lesson individual_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_pkey PRIMARY KEY (lesson_id);


--
-- Name: instructor instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (person_id);


--
-- Name: instrument_lease instrument_lease_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_lease
    ADD CONSTRAINT instrument_lease_pkey PRIMARY KEY (id);


--
-- Name: instrument_model instrument_model_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_model
    ADD CONSTRAINT instrument_model_pkey PRIMARY KEY (id);


--
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (id);


--
-- Name: learns_instrument learns_instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learns_instrument
    ADD CONSTRAINT learns_instrument_pkey PRIMARY KEY (instrument, student_id);


--
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (id);


--
-- Name: lesson lesson_time_slot_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_time_slot_id_key UNIQUE (time_slot_id);


--
-- Name: person person_person_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_person_number_key UNIQUE (person_number);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: price_information price_information_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_information
    ADD CONSTRAINT price_information_pkey PRIMARY KEY (id);


--
-- Name: scheduled_lesson scheduled_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_lesson
    ADD CONSTRAINT scheduled_lesson_pkey PRIMARY KEY (lesson_id);


--
-- Name: sibling_relation sibling_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sibling_relation
    ADD CONSTRAINT sibling_relation_pkey PRIMARY KEY (student_id1, student_id2);


--
-- Name: student_lesson student_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_pkey PRIMARY KEY (student_id, lesson_id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (person_id);


--
-- Name: teaches_instrument teaches_instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teaches_instrument
    ADD CONSTRAINT teaches_instrument_pkey PRIMARY KEY (instrument, instructor_id);


--
-- Name: time_slot time_slot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_slot
    ADD CONSTRAINT time_slot_pkey PRIMARY KEY (id);


--
-- Name: weekly_schedule weekly_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weekly_schedule
    ADD CONSTRAINT weekly_schedule_pkey PRIMARY KEY (id);


--
-- Name: classroom classroom_adress_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_adress_id_fkey FOREIGN KEY (adress_id) REFERENCES public.adress(id);


--
-- Name: classroom_lesson classroom_lesson_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom_lesson
    ADD CONSTRAINT classroom_lesson_classroom_id_fkey FOREIGN KEY (classroom_id) REFERENCES public.classroom(id) ON DELETE CASCADE;


--
-- Name: classroom_lesson classroom_lesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom_lesson
    ADD CONSTRAINT classroom_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) ON DELETE CASCADE;


--
-- Name: contact_person contact_person_contact_details_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT contact_person_contact_details_id_fkey FOREIGN KEY (contact_details_id) REFERENCES public.contact_details(id);


--
-- Name: contact_person contact_person_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT contact_person_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(person_id) ON DELETE CASCADE;


--
-- Name: ensemble_lesson ensemble_lesson_scheduled_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble_lesson
    ADD CONSTRAINT ensemble_lesson_scheduled_lesson_id_fkey FOREIGN KEY (scheduled_lesson_id) REFERENCES public.scheduled_lesson(lesson_id) ON DELETE CASCADE;


--
-- Name: group_lesson group_lesson_scheduled_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_scheduled_lesson_id_fkey FOREIGN KEY (scheduled_lesson_id) REFERENCES public.scheduled_lesson(lesson_id) ON DELETE CASCADE;


--
-- Name: individual_lesson individual_lesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) ON DELETE CASCADE;


--
-- Name: instructor instructor_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: instrument instrument_instrument_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_instrument_model_id_fkey FOREIGN KEY (instrument_model_id) REFERENCES public.instrument_model(id) ON DELETE CASCADE;


--
-- Name: instrument_lease instrument_lease_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_lease
    ADD CONSTRAINT instrument_lease_instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(id);


--
-- Name: instrument_lease instrument_lease_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_lease
    ADD CONSTRAINT instrument_lease_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(person_id) ON DELETE SET NULL;


--
-- Name: learns_instrument learns_instrument_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learns_instrument
    ADD CONSTRAINT learns_instrument_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(person_id) ON DELETE CASCADE;


--
-- Name: lesson lesson_instructor_price_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_instructor_price_id_fkey FOREIGN KEY (instructor_price_id) REFERENCES public.price_information(id);


--
-- Name: lesson lesson_student_price_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_student_price_id_fkey FOREIGN KEY (student_price_id) REFERENCES public.price_information(id);


--
-- Name: lesson lesson_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.time_slot(id);


--
-- Name: person person_adress_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_adress_id_fkey FOREIGN KEY (adress_id) REFERENCES public.adress(id);


--
-- Name: person person_contact_details_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_contact_details_id_fkey FOREIGN KEY (contact_details_id) REFERENCES public.contact_details(id);


--
-- Name: scheduled_lesson scheduled_lesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_lesson
    ADD CONSTRAINT scheduled_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) ON DELETE CASCADE;


--
-- Name: scheduled_lesson scheduled_lesson_weekly_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_lesson
    ADD CONSTRAINT scheduled_lesson_weekly_schedule_id_fkey FOREIGN KEY (weekly_schedule_id) REFERENCES public.weekly_schedule(id);


--
-- Name: sibling_relation sibling_relation_student_id1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sibling_relation
    ADD CONSTRAINT sibling_relation_student_id1_fkey FOREIGN KEY (student_id1) REFERENCES public.student(person_id) ON DELETE CASCADE;


--
-- Name: sibling_relation sibling_relation_student_id2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sibling_relation
    ADD CONSTRAINT sibling_relation_student_id2_fkey FOREIGN KEY (student_id2) REFERENCES public.student(person_id) ON DELETE CASCADE;


--
-- Name: student_lesson student_lesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) ON DELETE CASCADE;


--
-- Name: student_lesson student_lesson_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(person_id) ON DELETE CASCADE;


--
-- Name: student student_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: teaches_instrument teaches_instrument_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teaches_instrument
    ADD CONSTRAINT teaches_instrument_person_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(person_id) ON DELETE CASCADE;


--
-- Name: time_slot time_slot_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_slot
    ADD CONSTRAINT time_slot_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(person_id);


--
-- PostgreSQL database dump complete
--

