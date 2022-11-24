
-- CREATE TABLE FOR imported data:
DROP TABLE IF EXISTS "imported";

-- EMPY ALL TABLES

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
DELETE FROM instructor;
DELETE FROM person;
DELETE FROM adress;
DELETE FROM contact_details;


DELETE FROM lesson;


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
    WHERE person.person_number = imported.person_number AND imported.ord <= 5;

    -- CREATE INSTRUCTORS
INSERT INTO instructor (person_id) 
    SELECT person.id FROM person, imported 
    WHERE person.person_number = imported.person_number AND imported.ord > 5;
------ DET FUNGERAR !!!! YEEEES!!!

    -- CREATE SIBLING RELATIONS:
INSERT INTO sibling_relation (student_id1, student_id2)
    SELECT S1.person_id, S2.person_id FROM student AS S1, student AS S2
    WHERE NOT S1.person_id=S2.person_id ORDER BY RANDOM() LIMIT 4; --??
INSERT INTO sibling_relation (student_id1, student_id2)
    SELECT student_id2, student_id1 FROM sibling_relation as S3
    WHERE NOT EXISTS (SELECT * FROM sibling_relation AS S4 WHERE
    S3.student_id2 = S4.student_id1 AND S3.student_id1 = S4.student_id2); --??
            -- YYYEEEEEES FUNGERAR NU!!!

    -- CERATE A CLASSROOM
    INSERT INTO adress (zip, street, street_number) VALUES ('14264', 'Kvartettvagen', '2-6');
    INSERT INTO classroom (adress_id, building, classroom_name) SELECT
        id, 'EE36', 'Teknik' FROM adress WHERE adress.zip='14264' LIMIT 1;


    -- CREATE LESSONS
    INSERT INTO lesson (skill_level, price, instructor_payment, lesson_date, start_time, end_time) 
    VALUES 
    ('beginner',      100.0, 500.0, '2022-11-24', '08:30:00', '10:00:00'),
    ('intermediate',  200.0, 550.0, '2022-11-25', '08:30:00', '10:00:00'),
    ('advanced',      600.0, 600.0, '2022-11-26', '08:30:00', '10:00:00');

    -- CREATE CLASSROOM-LESSON
    INSERT INTO classroom_lesson (lesson_id, classroom_id) 
          SELECT lesson.id, classroom.id FROM lesson, classroom;

    --CREATE A WEEKLY SCHEDULE
    INSERT INTO weekly_schedule (year, week) VALUES ('2022', '47');

    -- CREATE 2 SCHEDULED LESSONS
    INSERT INTO scheduled_lesson (lesson_id, instructor_id, weekly_schedule_id, number_of_places,
      minimum_enrollments) 
        VALUES 
          ((SELECT id FROM lesson WHERE skill_level='beginner'),
          (SELECT person_id FROM instructor ORDER BY RANDOM() LIMIT 1), 
          (SELECT id FROM weekly_schedule ORDER BY RANDOM() LIMIT 1), 10, 4),
          ((SELECT id FROM lesson WHERE skill_level='intermediate'),
          (SELECT person_id FROM instructor ORDER BY RANDOM() LIMIT 1), 
          (SELECT id FROM weekly_schedule ORDER BY RANDOM() LIMIT 1), 15, 6);

    -- CREATE GROUP LESSON FOR FIRST SCHEDULED LESSON
    INSERT INTO group_lesson (scheduled_lesson_id, instrument)
      VALUES ((SELECT lesson_id FROM scheduled_lesson, lesson 
              WHERE scheduled_lesson.lesson_id=lesson.id AND skill_level='beginner'), 'violin');

    -- CREATE ENSEMBLE LESSON FOR THE SECOND SCHEDULED LESSON:
    INSERT INTO ensemble_lesson (scheduled_lesson_id, genre)
      VALUES ((SELECT lesson_id FROM scheduled_lesson, lesson 
              WHERE scheduled_lesson.lesson_id=lesson.id AND skill_level='intermediate'), 'rock');
              -- OBS genre SHOULD BE AN ENUM. HOW COULD I FORGET!!!


    -- CREATE 1 INDIVIDUAL LESSON:
    INSERT INTO individual_lesson (lesson_id, instructor_id, instrument)
        VALUES 
            (
              (SELECT id FROM lesson WHERE lesson.skill_level = 'advanced'),
              (SELECT person_id FROM instructor ORDER BY RANDOM() LIMIT 1), 
              'piano'
            );



    -- CREATE a CONTACT PERSON FOR SOME studnet
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

    -- CREATE SOM STUDENT_LESSON RELATIONS (ALL STUDENTS TO ALL scheduled lessons!)
    INSERT INTO student_lesson (student_id, lesson_id)
        SELECT DISTINCT student.person_id, (SELECT id FROM lesson WHERE skill_level='beginner' 
              LIMIT 1) 
          FROM student;
    INSERT INTO student_lesson (student_id, lesson_id)
        SELECT DISTINCT student.person_id, (SELECT id FROM lesson WHERE skill_level='intermediate' 
              LIMIT 1) 
          FROM student;
    INSERT INTO student_lesson (student_id, lesson_id) VALUES
        (
          (SELECT person_id FROM student LIMIT 1),
          (SELECT id FROM lesson WHERE lesson.skill_level='advanced')
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

-- EXAMPLE
--  CALCULATE TOTAL PRICE FOR EVERY STUDENT
--  SELECT SUM(price), person.first_name FROM person, lesson, student_lesson 
--     WHERE person.id = student_lesson.student_id AND student_lesson.lesson_id=lesson.id 
--      GROUP BY person.first_name;
-- SELECT SUM(price), person.first_name FROM person, lesson, student_lesson WHERE person.id = student_lesson.student_id AND student_lesson.lesson_id=lesson.id GROUP BY person.first_name;
---------------- ERASE LEFTOVERS -------------------
-- DROP GENERATED TABLES
DROP TABLE imported;
