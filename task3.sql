
-- Print number of lessons per month, and number of each kind:
CREATE VIEW full_lesson_data AS
    SELECT id, individual_lesson.lesson_id AS ind_id, group_lesson.scheduled_lesson_id AS gro_id, 
            ensemble_lesson.scheduled_lesson_id AS ens_id, lesson_date FROM lesson 
    LEFT JOIN individual_lesson ON individual_lesson.lesson_id=lesson.id 
    LEFT JOIN group_lesson      ON lesson.id=group_lesson.scheduled_lesson_id 
    LEFT JOIN ensemble_lesson   ON lesson.id=ensemble_lesson.scheduled_lesson_id;

SELECT EXTRACT(MONTH FROM lesson_date) AS Month, 
        COUNT(id) AS num_lessons,
        COUNT(ind_id) AS individual_lessons,
        COUNT(gro_id) AS group_lessons,
        COUNT(ens_id) AS ensemble_lessons
        FROM full_lesson_data 
        WHERE EXTRACT(YEAR FROM lesson_date)=2022
        GROUP BY Month; 

DROP VIEW full_lesson_data;

-- Count students with n number of siblings
SELECT number_of_siblings, COUNT(*) FROM 
    (
      SELECT 0 AS number_of_siblings
        FROM student 
          LEFT JOIN sibling_relation 
            ON student.person_id=sibling_relation.student_id1
        WHERE student_id1 IS NULL
        GROUP BY number_of_siblings
      UNION ALL
        SELECT COUNT(*) AS number_of_siblings 
          FROM sibling_relation 
          GROUP BY sibling_relation.student_id1
    ) AS studnet_lesson_data
  GROUP BY number_of_siblings ORDER BY number_of_siblings;

  -- LIST NUMBER OF LESSONS EACH INSTRUCOTR HAS IN THE CURRENT MONTH IF MORE THAN 2

SELECT person.first_name, person.last_name, person.person_number, COUNT(lesson.id) AS num_lessons 
      FROM person, instructor, time_slot, lesson 
      WHERE time_slot.instructor_id=instructor.person_id AND lesson.time_slot_id=time_slot.id AND instructor.person_id=person.id
        AND EXTRACT(MONTH FROM lesson.lesson_date) = EXTRACT(MONTH FROM CURRENT_DATE) -- AND LESSONS IS IN CURRENT MONTH
        AND EXTRACT(YEAR FROM lesson.lesson_date) = EXTRACT(YEAR FROM CURRENT_DATE)  -- AND IN CORRECT YEAR
      GROUP BY (person.first_name, person.last_name, person.person_number) 
        HAVING COUNT(lesson.id)>=2 ORDER BY num_lessons;


  -- LIST ENSEMBLES

CREATE MATERIALIZED VIEW ensemble_lesson_next_week_data  AS
    SELECT 
      EL.genre AS genre, 
      lesson.lesson_date, lesson.start_time, lesson.end_time, 
      scheduled_lesson.number_of_places,
      (scheduled_lesson.number_of_places-
          (SELECT COUNT(student_lesson.student_id) 
              FROM student_lesson WHERE EL.scheduled_lesson_id=student_lesson.lesson_id)) 
          AS places_left

      FROM lesson, scheduled_lesson, ensemble_lesson AS EL
      WHERE lesson.id=scheduled_lesson.lesson_id AND 
          scheduled_lesson.lesson_id=EL.scheduled_lesson_id AND
          -- IN NEXT WEEK
          EXTRACT(WEEK FROM lesson.lesson_date) = EXTRACT(WEEK FROM CURRENT_DATE)+1 AND
          -- OF THIS YEAR
          EXTRACT(YEAR FROM lesson.lesson_date) = EXTRACT(YEAR FROM CURRENT_DATE)
      ORDER BY (genre, lesson.lesson_date, lesson.start_time);

SELECT  genre, 
        lesson_date, start_time, end_time, 
        number_of_places,
        places_left,
        CASE
          WHEN places_left>2 THEN '>2'
          WHEN places_left<=2 AND places_left>0 THEN places_left::varchar(10)
          WHEN places_left=0 THEN 'FULL'
          ELSE 'ERROR'
        END AS places
    FROM
    ensemble_lesson_next_week_data;
        


DROP MATERIALIZED VIEW ensemble_lesson_next_week_data;
