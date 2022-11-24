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
-- Name: group_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_lesson (
    scheduled_lesson_id integer NOT NULL,
    instrument public.instrument_type NOT NULL
);


ALTER TABLE public.group_lesson OWNER TO postgres;

--
-- Name: individual_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.individual_lesson (
    lesson_id integer NOT NULL,
    instructor_id integer,
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
    price real NOT NULL,
    sibling_discount real,
    instructor_payment real NOT NULL,
    lesson_date date NOT NULL,
    start_time time(4) without time zone NOT NULL,
    end_time time(4) without time zone NOT NULL
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
-- Name: scheduled_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scheduled_lesson (
    lesson_id integer NOT NULL,
    instructor_id integer,
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
-- Data for Name: group_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_lesson (scheduled_lesson_id, instrument) FROM stdin;
\.


--
-- Data for Name: individual_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.individual_lesson (lesson_id, instructor_id, instrument) FROM stdin;
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

COPY public.lesson (id, skill_level, price, sibling_discount, instructor_payment, lesson_date, start_time, end_time) FROM stdin;
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person (id, person_number, first_name, last_name, adress_id, contact_details_id) FROM stdin;
\.


--
-- Data for Name: scheduled_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scheduled_lesson (lesson_id, instructor_id, weekly_schedule_id, number_of_places, minimum_enrollments) FROM stdin;
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
-- Data for Name: weekly_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weekly_schedule (id, year, week) FROM stdin;
1	2022	47
2	2022	47
3	2022	47
4	2022	47
5	2022	47
6	2022	47
7	2022	47
8	2022	47
9	2022	47
10	2022	47
11	2022	47
12	2022	47
13	2022	47
14	2022	47
15	2022	47
16	2022	47
17	2022	47
18	2022	47
19	2022	47
20	2022	47
21	2022	47
22	2022	47
23	2022	47
\.


--
-- Name: adress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adress_id_seq', 645, true);


--
-- Name: classroom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classroom_id_seq', 34, true);


--
-- Name: contact_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contact_details_id_seq', 581, true);


--
-- Name: instrument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_id_seq', 20, true);


--
-- Name: instrument_lease_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_lease_id_seq', 10, true);


--
-- Name: instrument_model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_model_id_seq', 10, true);


--
-- Name: lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_id_seq', 88, true);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_id_seq', 412, true);


--
-- Name: weekly_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weekly_schedule_id_seq', 23, true);


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
-- Name: group_lesson group_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_pkey PRIMARY KEY (scheduled_lesson_id);


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
-- Name: individual_lesson individual_lesson_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(person_id) ON DELETE SET NULL;


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
-- Name: scheduled_lesson scheduled_lesson_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scheduled_lesson
    ADD CONSTRAINT scheduled_lesson_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(person_id) ON DELETE SET NULL;


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
-- PostgreSQL database dump complete
--

