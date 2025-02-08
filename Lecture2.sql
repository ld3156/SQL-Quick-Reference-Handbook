/* 
 * This is the second lecture in the "SQL Quick Learn" program. 
 * There are three lectures in total, from very basic to more advanced SQL techniques.
 * The commands we use in this course follow SQLite, which may differ slightly from MySQL or other SQL dialects.
 * Nevertheless, the main purpose of this tutorial is to demonstrate what you can do with general SQL,
 * such as data cleaning, filtering, and more.
 * You should import a dataset you prefer and practice these concepts through hands-on experience.
 * 
 * Author: Louis Dai (2025 Feb)
 */

-- In this lecture, we want to have some more detailed and sophisticated queries doing complex tasks.
-- Lets first start with several small techniques.

-- Chapter 3 Useful Techniques: String Concat, TRIM, SUBSTRING, UPPER, DATE
-- Concate
SELECT hp."Year"|| '('|| hp.State_ANSI||')' FROM honey_production hp;

-- Trim Spaces, LTRIM(), RTRIM(), TRIM()
SELECT TRIM('    This is it!   ') AS TRIMSTRING;

-- SUBSTRING(String name, string position to start, number of char for this substring)
SELECT SUBSTRING(sl.State,1,2) FROM state_lookup sl;

-- UPPER(),LOWER()
SELECT LOWER(sl.state) FROM state_lookup sl;

-- DATE(timestring, modifier, modifier...)
-- STRFTIME('%Y', Birthdate) AS YEAR
SELECT DATE('NOW');
SELECT STRFTIME('%Y %m %d', 'NOW');

/* CASE STATEMENT
 * CASE
		WHEN C1 THEN E1
		WHEN C2 THEN E2
		ELSE [result else]
   END;
   
 * The example below shows how to incorperate CASE with self-join, it is pretty advanced but useful, can you see how it works?*/
SELECT
    CASE
       WHEN hp.value > (SELECT AVG(hp2.value) FROM honey_production hp2)
            THEN 'OUTPERFORM'
       ELSE 'UNDERPERFORM'
    END AS SIGNAL
FROM honey_production hp;

-- VIEW, a stored query, you can see as a temp table
CREATE VIEW my_view
AS
SELECT
sl.State,
hpp.hpsum
FROM state_lookup sl
LEFT JOIN (SELECT SUM(hp.Value) AS hpsum, hp.State_ANSI  FROM honey_production hp GROUP BY hp.State_ANSI) AS hpp ON sl.State_ANSI = hpp.State_ANSI;
-- Then, we can check.
SELECT * FROM my_view;




