-- Skriver ut antalet lektioner per månad för ett visst år.
    --FÖRSTA EXEMPLET: år 2022
SELECT  EXTRACT(MONTH FROM L.lesson_date) AS Month, 
        COUNT(*) AS num_lessons, 
        SUM(CASE WHEN (EXISTS (SELECT * FROM individual_lesson WHERE individual_lesson.lesson_id = L.id)) THEN 1 ELSE 0 END)        AS individual_lessons,
        SUM(CASE WHEN (EXISTS (SELECT * FROM group_lesson WHERE group_lesson.scheduled_lesson_id = L.id)) THEN 1 ELSE 0 END)        AS group_lessons,
        SUM(CASE WHEN (EXISTS (SELECT * FROM ensemble_lesson WHERE ensemble_lesson.scheduled_lesson_id = L.id)) THEN 1 ELSE 0 END)  AS ensemble_lessons
        FROM lesson as L
                WHERE EXTRACT(YEAR FROM L.lesson_date) = 2022 
                GROUP BY Month;

--SELECT * FROM lesson    FULL JOIN individual_lesson ON individual_lesson.lesson_id=lesson.id
--                        FULL JOIN group_lesson ON group_lesson.scheduled_lesson_id=lesson.id
--                        FULL JOIN ensemble_lesson ON ensemble_lesson.scheduled_lesson_id=lesson.id;


  -- COUNT STUDENTS WITH X NUM OF SIBBLINGS
SELECT number_of_siblings, COUNT(*) FROM 
    (SELECT COUNT(*) AS number_of_siblings FROM sibling_relation GROUP BY sibling_relation.student_id1) AS ali
 GROUP BY number_of_siblings ORDER BY number_of_siblings;


  -- LIST NUMBER OF LESSONS EACH INSTRUCOTR HAS IN THE CURRENT MONTH IF MORE THAN 2

SELECT person.first_name, person.last_name, person.person_number, COUNT(lesson.id) AS num_lessons FROM person, instructor, time_slot, lesson 
      WHERE time_slot.instructor_id=instructor.person_id AND lesson.time_slot_id=time_slot.id AND instructor.person_id=person.id
        AND EXTRACT(MONTH FROM lesson.lesson_date) = EXTRACT(MONTH FROM CURRENT_DATE) -- AND LESSONS IS IN CURRENT MONTH
        AND EXTRACT(YEAR FROM lesson.lesson_date) = EXTRACT(YEAR FROM CURRENT_DATE)  -- AND IN CORRECT YEAR
      GROUP BY (person.first_name, person.last_name, person.person_number) 
        HAVING COUNT(lesson.id)>=2 ORDER BY num_lessons;


  -- LIST ENSEMBLES

