
-- CREATE TABLE FOR imported data:
DROP TABLE IF EXISTS "imported";

-- EMPY ALL TABLES

DELETE FROM free_slot;


DELETE FROM classroom_lesson;

DELETE FROM learns_instrument;
DELETE FROM teaches_instrument;

DELETE FROM ensemble_lesson;
DELETE FROM group_lesson;

DELETE FROM student_lesson;
DELETE FROM scheduled_lesson;
DELETE FROM individual_lesson;

DELETE FROM instrument_lease;
DELETE FROM instrument;
DELETE FROM instrument_model;

DELETE FROM contact_person;

DELETE FROM classroom;
DELETE FROM sibling_relation;
DELETE FROM student;







DELETE FROM lesson;
DELETE FROM time_slot;
DELETE FROM instructor;

DELETE FROM person;
DELETE FROM adress;
DELETE FROM contact_details;

DELETE FROM weekly_schedule;
DELETE FROM price_information;


CREATE TABLE "imported" (
  id SERIAL PRIMARY KEY,
  first_name varchar(255) default NULL,
  last_name varchar(255) default NULL,
  zip varchar(10) default NULL,
  adrs varchar(255) default NULL,
  street_number varchar(255),
  person_number varchar(255),
  email varchar(255) default NULL,
  phone varchar(100) default NULL,
  ord integer NULL
);

INSERT INTO imported (first_name,last_name,zip,adrs,street_number,person_number,email,phone,ord)
VALUES
  ('Serina','Larson','68782','Ap #602-8347 Risus. St.','27','162135287485','sapien@protonmail.ca','077-136-3657',1),
  ('Paula','Sims','07499','3051 Ut, Street','16','026238112238','congue@aol.ca','045-045-7764',2),
  ('Sacha','Edwards','46668','Ap #346-8610 Donec Rd.','75','539242524046','lobortis.class.aptent@yahoo.com','061-434-2838',3),
  ('Baxter','Hensley','75318','Ap #263-5393 Adipiscing Av.','71','184410375244','malesuada.vel.venenatis@aol.edu','052-261-4731',4),
  ('Tiger','Maldonado','86182','2281 Vel, Avenue','44','867484858738','eget.varius.ultrices@hotmail.net','053-858-7542',5),
  ('Len','Patton','05116','Ap #696-8151 Dictum St.','33','187838245442','risus.a@icloud.com','022-786-3691',6),
  ('Buckminster','Owens','09418','Ap #739-2821 Suspendisse Ave','84','579775470614','sollicitudin.a.malesuada@google.ca','066-103-2764',7),
  ('Kuame','Harrington','13446','4353 Et Rd.','21','107371896159','et.netus@icloud.ca','063-338-6212',8),
  ('Judith','Bowen','31068','142-2528 Purus Avenue','55','444734773476','nisi.aenean@outlook.couk','003-111-9873',9),
  ('Berk','Welch','53684','P.O. Box 598, 1455 Ipsum Street','36','460240030468','auctor.non.feugiat@protonmail.net','081-250-4153',10);


-- Add data to DB:

    -- CREATE ADDRESSES
INSERT INTO adress (zip, street, street_number) 
    SELECT zip, adrs, street_number FROM imported ORDER BY ord;

    -- CREATE CONTACT DELATILS (JOIN?)

INSERT INTO contact_details (email, primary_phone_number) 
    SELECT email, phone FROM imported ORDER BY ord;

    -- CREATE PERSONS
INSERT INTO person (person_number, first_name, last_name, adress_id, contact_details_id)
    SELECT person_number, first_name, last_name, 
    (SELECT adress.id FROM adress WHERE imported.person_number=person_number
        AND adress.street = imported.adrs),
    (SELECT contact_details.id FROM contact_details 
        WHERE imported.person_number = person_number AND
        contact_details.email = imported.email AND 
        contact_details.primary_phone_number = imported.phone) 
    FROM imported;

    -- CREATE STUDNETS
INSERT INTO student (person_id, skill_level) 
    SELECT person.id, 'beginner' FROM person, imported 
    WHERE person.person_number = imported.person_number AND imported.ord <= 6;

    -- CREATE INSTRUCTORS
INSERT INTO instructor (person_id) 
    SELECT person.id FROM person, imported 
    WHERE person.person_number = imported.person_number AND imported.ord > 6;
------ DET FUNGERAR !!!! YEEEES!!!

    -- CREATE SIBLING RELATIONS:
INSERT INTO sibling_relation (student_id1, student_id2)
    VALUES 
    (
      (SELECT person_id FROM person LEFT JOIN student ON person.id=student.person_id WHERE first_name='Serina'),
      (SELECT person_id FROM person LEFT JOIN student ON person.id=student.person_id WHERE first_name='Baxter')
    ),
    (
      (SELECT person_id FROM person LEFT JOIN student ON person.id=student.person_id WHERE first_name='Serina'),
      (SELECT person_id FROM person LEFT JOIN student ON person.id=student.person_id WHERE first_name='Sacha')
    ),
    (
      (SELECT person_id FROM person LEFT JOIN student ON person.id=student.person_id WHERE first_name='Sacha'),
      (SELECT person_id FROM person LEFT JOIN student ON person.id=student.person_id WHERE first_name='Baxter')
    ),
    (
      (SELECT person_id FROM person LEFT JOIN student ON person.id=student.person_id WHERE first_name='Paula'),
      (SELECT person_id FROM person LEFT JOIN student ON person.id=student.person_id WHERE first_name='Tiger')
    );

INSERT INTO sibling_relation (student_id2, student_id1)
    SELECT S1.person_id, S2.person_id FROM student AS S1, student AS S2, sibling_relation
    WHERE sibling_relation.student_id1=S1.person_id AND sibling_relation.student_id2=S2.person_id
    AND NOT EXISTS (SELECT * FROM sibling_relation AS SR 
          WHERE SR.student_id1=S2.person_id AND SR.student_id2=S1.person_id) ;

--INSERT INTO sibling_relation (student_id1, student_id2)
--    SELECT student_id2, student_id1 FROM sibling_relation as S3
--    WHERE NOT EXISTS (SELECT * FROM sibling_relation AS S4 WHERE
--    S3.student_id2 = S4.student_id1 AND S3.student_id1 = S4.student_id2); --??
            -- YYYEEEEEES FUNGERAR NU!!!

    -- CERATE A CLASSROOM
    INSERT INTO adress (zip, street, street_number) VALUES ('14264', 'Kvartettvagen', '2-6');
    INSERT INTO classroom (adress_id, building, classroom_name) SELECT
        id, 'EE36', 'Teknik' FROM adress WHERE adress.zip='14264' LIMIT 1;


    

    -- CREATE WEEKLY SCHEDULES (  =(  )
INSERT INTO weekly_schedule (year, week) 
          VALUES 
          ('2021', '1'),('2021', '2'),('2021', '3'),('2021', '4'),('2021', '5'),('2021', '6'),('2021', '7'),
          ('2021', '8'),('2021', '9'),('2021', '10'),('2021', '11'),('2021', '12'),('2021', '13'),('2021', '14'),
          ('2021', '15'),('2021', '16'),('2021', '17'),('2021', '18'),('2021', '19'),('2021', '20'),('2021', '21'),
          ('2021', '22'),('2021', '23'),('2021', '24'),('2021', '25'),('2021', '26'),('2021', '27'),('2021', '28'),
          ('2021', '29'),('2021', '30'),('2021', '31'),('2021', '32'),('2021', '33'),('2021', '34'),('2021', '35'),
          ('2021', '36'),('2021', '37'),('2021', '38'),('2021', '39'),('2021', '40'),('2021', '41'),('2021', '42'),
          ('2021', '43'),('2021', '44'),('2021', '45'),('2021', '46'),('2021', '47'),('2021', '48'),('2021', '49'),
          ('2021', '50'),('2021', '51'),('2021', '52'),
          ('2022', '1'), ('2022', '2'), ('2022', '3'), ('2022', '4'), ('2022', '5'), ('2022', '6'), ('2022', '7'),
          ('2022', '8'), ('2022', '9'), ('2022', '10'),('2022', '11'),('2022', '12'),('2022', '13'),('2022', '14'),
          ('2022', '15'),('2022', '16'),('2022', '17'),('2022', '18'),('2022', '19'),('2022', '20'),('2022', '21'),
          ('2022', '22'),('2022', '23'),('2022', '24'),('2022', '25'),('2022', '26'),('2022', '27'),('2022', '28'),
          ('2022', '29'),('2022', '30'),('2022', '31'),('2022', '32'),('2022', '33'),('2022', '34'),('2022', '35'),
          ('2022', '36'),('2022', '37'),('2022', '38'),('2022', '39'),('2022', '40'),('2022', '41'),('2022', '42'),
          ('2022', '43'),('2022', '44'),('2022', '45'),('2022', '46'),('2022', '47'),('2022', '48'),('2022', '49'),
          ('2022', '50'),('2022', '51'),('2022', '52');

    -- CREATE a CONTACT PERSON FOR SOME student
    INSERT INTO contact_details (email, primary_phone_number)
        VALUES ('sven.svensson@telia.se', '0768685460');
    INSERT INTO contact_person (student_id, contact_details_id, first_name, last_name)
        VALUES
        (
          (SELECT person_id FROM student ORDER BY RANDOM() LIMIT 1), 
          (SELECT id FROM contact_details AS C WHERE C.email='sven.svensson@telia.se'), 
          'Sven',
          'Svensson'
        );

    -- CREATE AN INSTRUMENT MODEL
    INSERT INTO instrument_model (instrument, brand, model, monthly_price) VALUES
      ('violin', 'yamaha', 'hd650', 666.0);

    -- CREATE 2 INDIVIDUAL INSTRUMENTS OF THE MODEL:
    INSERT INTO instrument (instrument_model_id) VALUES
      ((SELECT id FROM instrument_model LIMIT 1)),
      ((SELECT id FROM instrument_model LIMIT 1));

    -- CREATE ONE INSTRUMENT LEASES FOR THE RICH STUDENT
    INSERT INTO instrument_lease (student_id, instrument_id, lease_start_date, lease_end_date)
        VALUES
        (
          (SELECT person_id FROM student, person WHERE 
                  student.person_id=person.id AND first_name='Serina' LIMIT 1),
          (SELECT id FROM instrument ORDER BY RANDOM() LIMIT 1),
          '2022-11-01',
          '2022-12-01'
        );

    -- CREATE SOME ROWS FOR learns instrument:
    INSERT INTO learns_instrument (instrument, student_id)
        SELECT 'violin', person_id FROM student;


    -- CREATE ROWS FOR teaches_instrument:
    INSERT INTO teaches_instrument (instrument, instructor_id)
        SELECT 'violin', person_id FROM instructor;

------------- BETTER LESSONS ADDS:
DROP TABLE IF EXISTS "imported_lessons";

CREATE TABLE "imported_lessons" (
  id SERIAL PRIMARY KEY,
  date varchar(255),
  type integer NULL,
  instrument varchar(255) default NULL,
  level varchar(255) default NULL,
  start_time varchar(255),
  end_time varchar(255)
);

INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2020-07-31',1,'piano','intermediate','11:51','14:39'),
  ('2022-02-04',1,'guitar','intermediate','11:28','14:56'),
  ('2020-07-15',0,'violin','intermediate','8:46','16:33'),
  ('2022-09-23',1,'piano','intermediate','9:05','14:51'),
  ('2021-10-02',0,'violin','intermediate','11:05','18:36'),
  ('2021-01-07',2,'violin','advanced','9:35','16:18'),
  ('2022-02-01',1,'violin','intermediate','9:50','18:20'),
  ('2021-08-04',1,'piano','beginner','11:04','13:08'),
  ('2021-07-23',0,'piano','intermediate','8:14','12:10'),
  ('2022-07-06',0,'guitar','intermediate','10:27','12:03');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2020-12-21',1,'piano','intermediate','10:04','18:19'),
  ('2021-08-18',0,'violin','beginner','8:10','17:49'),
  ('2022-02-20',1,'piano','intermediate','8:45','17:08'),
  ('2021-04-28',0,'violin','advanced','9:07','12:02'),
  ('2020-11-29',2,'piano','beginner','10:36','18:31'),
  ('2022-01-14',1,'piano','advanced','11:24','16:24'),
  ('2020-11-03',0,'guitar','intermediate','8:32','16:52'),
  ('2022-12-05',0,'violin','beginner','8:15','14:55'),
  ('2022-10-22',2,'guitar','intermediate','10:16','18:16'),
  ('2022-12-15',1,'guitar','advanced','9:35','15:42');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2021-09-26',0,'piano','beginner','9:30','16:17'),
  ('2022-09-06',1,'guitar','intermediate','9:49','15:18'),
  ('2020-09-26',1,'piano','beginner','11:47','14:32'),
  ('2022-11-16',2,'violin','advanced','11:03','14:55'),
  ('2020-10-07',0,'violin','intermediate','10:58','14:19'),
  ('2022-12-09',1,'guitar','beginner','9:02','13:53'),
  ('2020-09-04',1,'violin','beginner','9:22','16:43'),
  ('2021-01-17',1,'piano','advanced','11:27','18:41'),
  ('2020-09-15',1,'guitar','beginner','8:59','13:05'),
  ('2021-12-23',2,'violin','intermediate','9:05','18:21');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2020-12-20',2,'piano','advanced','9:31','15:33'),
  ('2021-02-24',2,'guitar','advanced','11:58','15:08'),
  ('2021-12-16',1,'violin','advanced','9:14','13:53'),
  ('2022-07-15',2,'violin','beginner','9:46','16:50'),
  ('2022-07-02',1,'guitar','intermediate','8:46','14:38'),
  ('2021-04-28',0,'piano','intermediate','8:24','13:07'),
  ('2020-07-13',1,'guitar','beginner','8:43','12:00'),
  ('2022-09-05',0,'piano','intermediate','10:44','13:43'),
  ('2020-07-13',2,'violin','intermediate','10:23','12:23'),
  ('2022-03-20',1,'guitar','intermediate','11:25','13:50');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2020-08-03',2,'violin','intermediate','10:16','17:56'),
  ('2020-12-09',2,'piano','intermediate','8:54','18:58'),
  ('2021-05-31',1,'piano','advanced','8:41','12:34'),
  ('2022-10-16',1,'guitar','intermediate','11:12','13:12'),
  ('2021-02-07',1,'guitar','beginner','10:43','17:00'),
  ('2021-01-08',1,'guitar','intermediate','8:54','16:36'),
  ('2020-07-30',1,'violin','intermediate','10:28','18:52'),
  ('2021-06-17',1,'violin','beginner','9:29','18:15'),
  ('2021-06-24',0,'guitar','intermediate','8:48','18:44'),
  ('2021-06-02',2,'guitar','beginner','8:58','18:43');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2021-01-12',0,'piano','intermediate','9:46','12:54'),
  ('2022-05-26',2,'violin','beginner','10:38','16:19'),
  ('2021-07-28',1,'violin','beginner','11:38','12:58'),
  ('2021-11-18',1,'piano','beginner','10:19','17:15'),
  ('2022-02-12',1,'piano','advanced','9:21','16:26'),
  ('2021-07-26',0,'violin','beginner','9:06','13:44'),
  ('2020-09-04',0,'violin','advanced','11:40','13:47'),
  ('2022-04-24',1,'guitar','beginner','10:39','15:15'),
  ('2020-08-13',1,'guitar','beginner','11:07','15:48'),
  ('2021-08-04',2,'violin','intermediate','9:51','15:41');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2021-06-14',0,'piano','advanced','11:10','12:38'),
  ('2022-12-21',1,'piano','advanced','10:27','13:59'),
  ('2021-11-30',1,'piano','intermediate','9:03','17:34'),
  ('2020-10-26',1,'guitar','intermediate','10:22','12:12'),
  ('2022-04-16',0,'violin','intermediate','10:29','12:14'),
  ('2022-10-01',0,'piano','intermediate','11:38','16:08'),
  ('2022-03-29',2,'guitar','beginner','10:27','14:03'),
  ('2021-01-22',1,'guitar','beginner','9:01','13:05'),
  ('2021-09-08',0,'violin','advanced','10:15','12:11'),
  ('2022-08-13',1,'piano','advanced','11:06','14:30');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2021-07-08',0,'piano','intermediate','10:26','18:59'),
  ('2021-03-07',1,'piano','advanced','8:32','16:22'),
  ('2021-08-28',0,'guitar','beginner','10:00','14:56'),
  ('2021-08-07',1,'guitar','beginner','9:06','18:15'),
  ('2021-09-12',1,'piano','beginner','10:46','13:43'),
  ('2022-09-07',2,'piano','beginner','8:34','13:12'),
  ('2021-04-17',2,'piano','beginner','8:56','18:12'),
  ('2022-01-21',1,'piano','advanced','9:03','16:25'),
  ('2021-07-30',1,'guitar','advanced','8:17','16:03'),
  ('2022-07-08',0,'guitar','intermediate','9:36','15:23');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2021-07-14',2,'guitar','beginner','11:55','17:03'),
  ('2022-09-29',1,'guitar','intermediate','11:02','12:37'),
  ('2020-09-26',1,'piano','advanced','9:28','15:26'),
  ('2022-01-01',1,'violin','advanced','11:54','15:24'),
  ('2022-01-19',2,'guitar','intermediate','11:17','13:46'),
  ('2021-09-01',1,'piano','advanced','10:59','15:55'),
  ('2021-05-16',0,'guitar','intermediate','10:21','14:32'),
  ('2021-11-24',2,'violin','advanced','8:30','12:18'),
  ('2021-04-02',0,'piano','advanced','8:55','15:48'),
  ('2021-11-06',0,'guitar','intermediate','9:53','18:24');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2022-04-19',1,'guitar','intermediate','9:49','13:20'),
  ('2022-08-11',2,'violin','beginner','8:10','14:10'),
  ('2021-07-23',1,'guitar','intermediate','10:56','18:51'),
  ('2021-05-13',1,'violin','intermediate','10:08','17:24'),
  ('2020-12-14',1,'piano','advanced','11:19','16:31'),
  ('2021-07-13',0,'violin','intermediate','9:44','16:01'),
  ('2022-05-13',0,'piano','intermediate','8:50','17:26'),
  ('2022-01-17',1,'piano','intermediate','8:53','15:46'),
  ('2021-01-09',2,'piano','advanced','11:58','14:12'),
  ('2020-10-23',2,'guitar','advanced','8:36','14:34');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2022-12-16',2,'violin','intermediate','9:04','12:12'),
  ('2022-12-14',2,'piano','advanced','9:43','17:30'),
  ('2022-12-12',1,'guitar','advanced','8:01','17:45'),
  ('2022-12-16',0,'violin','intermediate','10:43','17:42'),
  ('2022-12-13',1,'violin','advanced','9:40','17:32'),
  ('2022-12-14',1,'violin','advanced','9:00','15:43'),
  ('2022-12-16',2,'guitar','beginner','8:25','18:52'),
  ('2022-12-13',1,'violin','beginner','9:04','18:22'),
  ('2022-12-14',1,'guitar','advanced','11:30','16:24'),
  ('2022-12-15',1,'violin','intermediate','11:50','16:50');
INSERT INTO imported_lessons (date,type,instrument,level,start_time,end_time)
VALUES
  ('2022-12-16',1,'piano','intermediate','10:18','14:13'),
  ('2022-12-16',2,'guitar','intermediate','8:33','17:11'),
  ('2022-12-14',1,'violin','advanced','10:38','16:49'),
  ('2022-12-16',1,'violin','beginner','9:25','18:43'),
  ('2022-12-16',0,'violin','beginner','8:13','14:12'),
  ('2022-12-15',2,'guitar','beginner','9:29','15:43'),
  ('2022-12-15',0,'guitar','beginner','9:52','18:32'),
  ('2022-12-15',0,'piano','beginner','10:15','16:45'),
  ('2022-12-12',1,'piano','advanced','9:07','17:53'),
  ('2022-12-16',0,'piano','intermediate','10:12','16:41');



-- CLASSROOM LESSON RELATION???
-- CREATE CLASSROOM-LESSON
    --INSERT INTO classroom_lesson (lesson_id, classroom_id) 
    --      SELECT lesson.id, classroom.id FROM lesson, classroom;

--Buckminster','Owens','09418','Ap #739-2821 Suspendisse Ave','84','579775470614','sollicitudin.a.malesuada@google.ca','066-103-2764',7),
--  ('Kuame','Harrington','13446','4353 Et Rd.','21','107371896159','et.netus@icloud.ca','063-338-6212',8),
--  ('Judith','Bowen','31068','142-2528 Purus Avenue','55','444734773476','nisi.aenean@outlook.couk','003-111-9873',9),
--  ('Berk'
--
--
--


-- CREATE TIME SLOTS FOR LESSONS!!!

SELECT * FROM instructor;

INSERT INTO time_slot (instructor_id) SELECT person_id FROM instructor, 
  (SELECT date FROM imported_lessons) AS lim, (SELECT SETSEED(0.2)) AS rnd
  WHERE instructor.person_id = floor(RANDOM()*3.0)+(SELECT person_id FROM instructor ORDER BY person_id ASC LIMIT 1)
  ORDER BY RANDOM() ASC LIMIT 60;

INSERT INTO time_slot (instructor_id) SELECT person_id FROM instructor, 
  (SELECT date FROM imported_lessons) AS lim, (SELECT SETSEED(0.2)) AS rnd
  WHERE instructor.person_id = floor(RANDOM()*3.0)+(SELECT person_id FROM instructor ORDER BY person_id ASC LIMIT 1)
  ORDER BY RANDOM() DESC LIMIT 60;

SELECT * FROM instructor;
-- CREAT PRICEING INFORMATION:

INSERT INTO price_information 
        (
          pricing_name,
          advanced_individual_price,
          intermediate_individual_price,
          beginner_individual_price,

          advanced_group_price,
          intermediate_group_price,
          beginner_group_price,

          sibling_discount
        ) 
        VALUES
        (
          'student pricing',
          1000,
          800,
          800,

          500,
          300,
          300,

          0.1
        );

INSERT INTO price_information 
        (
          pricing_name,
          advanced_individual_price,
          intermediate_individual_price,
          beginner_individual_price,

          advanced_group_price,
          intermediate_group_price,
          beginner_group_price,
          sibling_discount
        ) 
        VALUES
        (
          'instructor pricing',
          600,
          400,
          400,

          1000,
          800,
          800,
          0.0
        );


INSERT  INTO lesson (skill_level, lesson_date, start_time, end_time, student_price_id, instructor_price_id, time_slot_id) 
        SELECT imported_lessons.level::skill_level, imported_lessons.date::DATE, 
                imported_lessons.start_time::TIME, imported_lessons.end_time::TIME, 
                (SELECT id FROM price_information WHERE pricing_name='student pricing' LIMIT 1),
                (SELECT id FROM price_information WHERE pricing_name='instructor pricing' LIMIT 1),
                time_slot.id
  
          FROM 
            (
              SELECT *, ROW_NUMBER() OVER (ORDER BY date) AS r_num  FROM imported_lessons
            )imported_lessons
          LEFT JOIN
          (
            SELECT *, ROW_NUMBER() OVER (ORDER BY id) AS r_num  FROM time_slot
          )time_slot
          ON imported_lessons.r_num = time_slot.r_num;






-- CREATE SOME INDIVIDUAL LESSONS:

INSERT INTO individual_lesson (lesson_id, instrument)
      SELECT 
              L.id,
              instrument::INSTRUMENT_TYPE 
        
        FROM lesson AS L, imported_lessons AS IL
        
      WHERE L.lesson_date=IL.date::DATE AND L.start_time=IL.start_time::TIME AND L.end_time=IL.end_time::TIME AND
        IL.type=0; 




INSERT INTO scheduled_lesson (lesson_id, weekly_schedule_id, number_of_places,
      minimum_enrollments)
        SELECT 
              L.id,
              weekly_schedule.id,
              5,
              3
        FROM imported_lessons AS IL, lesson AS L, weekly_schedule
        WHERE L.lesson_date=IL.date::DATE AND L.start_time=IL.start_time::TIME AND L.end_time=IL.end_time::TIME AND
        IL.type>0 AND weekly_schedule.year = EXTRACT(YEAR FROM L.lesson_date) AND EXTRACT(WEEK FROM L.lesson_date)=weekly_schedule.week
        ORDER BY L.id;


-- CREATE SOME GROUP LESSONS:

INSERT INTO group_lesson (scheduled_lesson_id, instrument)
      SELECT 
              L.id, 
              instrument::INSTRUMENT_TYPE 
        
        FROM lesson AS L, scheduled_lesson AS SL, imported_lessons AS IL
        
      WHERE SL.lesson_id = L.id AND L.lesson_date=IL.date::DATE AND L.start_time=IL.start_time::TIME AND L.end_time=IL.end_time::TIME AND
        IL.type=1; 

-- CREATE SOME ENSEMBLE LESSONS:

INSERT INTO ensemble_lesson (scheduled_lesson_id, genre)
      SELECT 
              L.id, 
              'rock'::GENRE_TYPE 
        
        FROM lesson AS L, scheduled_lesson AS SL, imported_lessons AS IL
        
      WHERE SL.lesson_id = L.id AND L.lesson_date=IL.date::DATE AND L.start_time=IL.start_time::TIME AND L.end_time=IL.end_time::TIME AND
        IL.type=2; 

--STUDENT LESSON RELATIONS?
-- CREATE SOM STUDENT_LESSON RELATIONS (ALL STUDENTS TO ALL scheduled lessons!)
INSERT INTO student_lesson (student_id, lesson_id)
    SELECT student.person_id, lesson.id  
      FROM student, lesson, (SELECT SETSEED(0.7)) AS RND ORDER BY RANDOM() LIMIT 340;


-- EXAMPLE
--  CALCULATE TOTAL PRICE FOR EVERY STUDENT
--  SELECT SUM(price), person.first_name FROM person, lesson, student_lesson 
--     WHERE person.id = student_lesson.student_id AND student_lesson.lesson_id=lesson.id 
--      GROUP BY person.first_name;
-- SELECT SUM(price), person.first_name FROM person, lesson, student_lesson WHERE person.id = student_lesson.student_id AND student_lesson.lesson_id=lesson.id GROUP BY person.first_name;
---------------- ERASE LEFTOVERS -------------------
-- DROP GENERATED TABLES
DROP TABLE imported;
--DROP TABLE imported_lessons;