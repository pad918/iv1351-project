-- Creates a historical database in the form of a psql schema 
-- and stores information from sgms database in a
-- denormalized form. The schema can then be dumped and
-- loaded separatly. Postgres does not support SQL statements
-- Across multiple databases, but is does support it between
-- multiple schemas. Postgres schemas are the same as 
-- mysql databases. 

--Make a dump of the schema:
--pg_dump -U postgres -d sgmsdb -n sgms_historical_db > C:\Users\Public\Downloads\dump20230108_2.sql


DROP TABLE sgms_historical_db.student_lesson;
DROP TABLE sgms_historical_db.lesson;
DROP TABLE sgms_historical_db.student;
DROP TABLE sgms_historical_db.sibling_relation;

DROP VIEW lesson_joiner;
DROP VIEW lesson_joiner_without_price;
DROP VIEW scheduled_lesson_joiner;
DROP VIEW group_lesson_joiner;
DROP VIEW ensemble_lesson_joiner;
DROP VIEW individual_lesson_joiner;

DROP SCHEMA sgms_historical_db;
CREATE SCHEMA sgms_historical_db;
-- Load data from sgmsdb

    -- Loading a student is much simpler than loading a lesson:
DROP VIEW person_joiner;
CREATE VIEW person_joiner AS
    SELECT W.id, W.person_number, first_name, last_name,
        skill_level::text, zip, street, street_number, apartment_number, 
        email, primary_phone_number, secondary_phone_number
    FROM 
    (
        (
            public.person AS p JOIN public.student AS s 
            ON p.id = s.person_id
        ) AS K   
            JOIN public.contact_details 
            AS c (c_id, email, primary_phone_number, secondary_phone_number) 
            ON K.contact_details_id = c.c_id
    ) AS W
        JOIN public.adress AS a ON a.id=W.adress_id
    ;

CREATE VIEW individual_lesson_joiner AS
    SELECT 
        id, skill_level::text, lesson_date, start_time, 
        end_time, student_price_id, NULL::INTEGER AS number_of_places,
        NULL::INTEGER AS minimum_enrollments, instrument::text, 
        'individual'::text AS lesson_type
        FROM 
            lesson JOIN individual_lesson ON lesson.id=individual_lesson.lesson_id;

CREATE VIEW group_lesson_joiner AS SELECT id, skill_level::text, lesson_date, 
    start_time, end_time, student_price_id, 
    number_of_places, minimum_enrollments, instrument::text AS instrument,
    'group'::text AS lesson_type
    FROM
    (lesson JOIN scheduled_lesson ON lesson.id=scheduled_lesson.lesson_id) as s
    JOIN group_lesson ON s.id=group_lesson.scheduled_lesson_id;

CREATE VIEW ensemble_lesson_joiner AS SELECT id, skill_level::text, lesson_date, 
    start_time, end_time, student_price_id, 
    number_of_places, minimum_enrollments, NULL AS instrument,
    'ensemble'::text AS lesson_type
    FROM
    (lesson JOIN scheduled_lesson ON lesson.id=scheduled_lesson.lesson_id) as s
    JOIN ensemble_lesson ON s.id=ensemble_lesson.scheduled_lesson_id;

CREATE VIEW scheduled_lesson_joiner AS SELECT * FROM (
    SELECT * FROM group_lesson_joiner 
        UNION ALL 
            SELECT * FROM ensemble_lesson_joiner
) AS sqlforcedmetonamethis1;

CREATE VIEW lesson_joiner_without_price AS 
    SELECT * FROM (
        SELECT * FROM scheduled_lesson_joiner
            UNION ALL
                SELECT * FROM individual_lesson_joiner
    ) AS sqlforcedmetonamethis2;

CREATE VIEW lesson_joiner AS SELECT L.id as id, skill_level::text, lesson_date, 
    start_time, end_time,
    -- FIND THE PRICE OF EACH LESSON (SLOW PROCESS)  
    (CASE 
        WHEN L.lesson_type='individual' AND L.skill_level = 'advanced'
            THEN P.advanced_individual_price
        WHEN L.lesson_type='individual' AND L.skill_level = 'intermediate'
            THEN P.intermediate_individual_price
        WHEN L.lesson_type='individual' AND L.skill_level = 'beginner'
            THEN P.beginner_individual_price
        WHEN L.skill_level = 'advanced'
            THEN P.advanced_group_price
        WHEN L.skill_level = 'intermediate'
            THEN P.intermediate_group_price
        WHEN L.skill_level = 'beginner'
            THEN P.beginner_group_price
    END)
    AS price, 
    sibling_discount,
    number_of_places, minimum_enrollments, 
    -- Find the number of participants of the lesson
    (
        SELECT COUNT(*) 
            FROM public.student_lesson as SL
            WHERE SL.lesson_id = L.id
    )   AS participants,
    instrument,
    lesson_type 
    FROM lesson_joiner_without_price as L, price_information as P
    WHERE L.student_price_id = P.id;





CREATE TABLE sgms_historical_db.student (
    person_id INTEGER NOT NULL UNIQUE,
    person_number char(12) NOT NULL UNIQUE,
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    skill_level varchar(100) NOT NULL,
    
    -- Adress related
    zip CHAR(5) NOT NULL,
    street varchar(100) NOT NULL,
    street_number varchar(100) NOT NULL,
    apartment_number varchar(100),

    -- Contact details related
    email varchar(100) NOT NULL,
    primary_phone_number varchar(100) NOT NULL,
    secondary_phone_number varchar(100),

    -- Constraints
    PRIMARY KEY (person_id)
    );

-- Create denormalized tables:
CREATE TABLE sgms_historical_db.lesson (
    id SERIAL UNIQUE,
    skill_level varchar(100) NOT NULL,
    lesson_date DATE NOT NULL,
    start_time TIME(4) NOT NULL,
    end_time TIME(4) NOT NULL,
    price real NOT NULL,
    sibling_discount real NOT NULL,
    number_of_places int,
    minimum_enrollments int,
    participants int NOT NULL,
    instrument varchar(100),
    lesson_type varchar(100) NOT NULL,
    PRIMARY KEY (id)
    );

CREATE TABLE sgms_historical_db.student_lesson (
    student_id INTEGER REFERENCES sgms_historical_db.student (person_id) NOT NULL,
    lesson_id INTEGER REFERENCES sgms_historical_db.lesson (id) NOT NULL,
    PRIMARY KEY (student_id, lesson_id)
);

CREATE TABLE sgms_historical_db.sibling_relation (
    student_id1 INTEGER NOT NULL,
    student_id2 INTEGER NOT NULL,
    PRIMARY KEY (student_id1, student_id2)
);

INSERT INTO sgms_historical_db.lesson
    SELECT * FROM lesson_joiner;

INSERT INTO sgms_historical_db.student 
    SELECT * FROM person_joiner;     

INSERT INTO sgms_historical_db.student_lesson
    SELECT * FROM public.student_lesson;

INSERT INTO sgms_historical_db.sibling_relation
    SELECT * FROM public.sibling_relation;