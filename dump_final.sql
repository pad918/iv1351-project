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
-- Name: sibling_relation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sibling_relation (
    student_id1 integer NOT NULL,
    student_id2 integer NOT NULL
);


ALTER TABLE public.sibling_relation OWNER TO postgres;

--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    person_id integer NOT NULL,
    skill_level public.skill_level NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_lesson (
    student_id integer NOT NULL,
    lesson_id integer NOT NULL
);


ALTER TABLE public.student_lesson OWNER TO postgres;

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
\.


--
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classroom (id, adress_id, building, classroom_name) FROM stdin;
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
\.


--
-- Data for Name: contact_person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_person (student_id, first_name, last_name, contact_details_id) FROM stdin;
\.


--
-- Data for Name: ensemble_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ensemble_lesson (scheduled_lesson_id, genre) FROM stdin;
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
\.


--
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructor (person_id) FROM stdin;
\.


--
-- Data for Name: instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument (id, instrument_model_id) FROM stdin;
\.


--
-- Data for Name: instrument_lease; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument_lease (id, student_id, instrument_id, lease_start_date, lease_end_date) FROM stdin;
\.


--
-- Data for Name: instrument_model; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument_model (id, instrument, brand, model, monthly_price) FROM stdin;
\.


--
-- Data for Name: learns_instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.learns_instrument (instrument, student_id) FROM stdin;
\.


--
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson (id, skill_level, lesson_date, start_time, end_time, student_price_id, instructor_price_id, time_slot_id) FROM stdin;
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person (id, person_number, first_name, last_name, adress_id, contact_details_id) FROM stdin;
\.


--
-- Data for Name: price_information; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_information (id, pricing_name, advanced_individual_price, intermediate_individual_price, beginner_individual_price, advanced_group_price, intermediate_group_price, beginner_group_price, sibling_discount) FROM stdin;
245	student pricing	1000	800	800	500	300	300	0.1
246	instructor pricing	600	400	400	1000	800	800	0
\.


--
-- Data for Name: scheduled_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scheduled_lesson (lesson_id, weekly_schedule_id, number_of_places, minimum_enrollments) FROM stdin;
\.


--
-- Data for Name: sibling_relation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sibling_relation (student_id1, student_id2) FROM stdin;
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (person_id, skill_level) FROM stdin;
\.


--
-- Data for Name: student_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_lesson (student_id, lesson_id) FROM stdin;
\.


--
-- Data for Name: teaches_instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teaches_instrument (instrument, instructor_id) FROM stdin;
\.


--
-- Data for Name: time_slot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.time_slot (id, instructor_id) FROM stdin;
\.


--
-- Data for Name: weekly_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weekly_schedule (id, year, week) FROM stdin;
\.


--
-- Name: adress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adress_id_seq', 2404, true);


--
-- Name: classroom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classroom_id_seq', 193, true);


--
-- Name: contact_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contact_details_id_seq', 2341, true);


--
-- Name: imported_lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.imported_lessons_id_seq', 120, true);


--
-- Name: instrument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_id_seq', 340, true);


--
-- Name: instrument_lease_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_lease_id_seq', 170, true);


--
-- Name: instrument_model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_model_id_seq', 170, true);


--
-- Name: lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_id_seq', 10808, true);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_id_seq', 1976, true);


--
-- Name: price_information_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.price_information_id_seq', 246, true);


--
-- Name: time_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.time_slot_id_seq', 25540, true);


--
-- Name: weekly_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weekly_schedule_id_seq', 14298, true);


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

