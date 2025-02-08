/* 
 * This is the first lecture in the "SQL Quick Learn" program. 
 * There are three lectures in total, from very basic to more advanced SQL techniques.
 * The commands we use in this course follow SQLite, which may differ slightly from MySQL or other SQL dialects.
 * Nevertheless, the main purpose of this tutorial is to demonstrate what you can do with general SQL,
 * such as data cleaning, filtering, and more.
 * You should import a dataset you prefer and practice these concepts through hands-on experience.
 * 
 * Author: Louis Dai (2025 Feb)
 */



-- Chapter 0: Setup your tables
-- Date Type such as CHAR(10), VARCHAR(750), DECIMAL(8,2), INTEGER, TEXT
CREATE TABLE production (
    Year INTEGER PRIMARY KEY, -- Year, PRI KEY is used to uniquely identify each record(row) in a table.
    Period TEXT NOT NULL, -- Month, such as 'APR', 'FEB'
    Geo_Level TEXT, -- State
    State_ANSI INTEGER, -- State id
    Value INTEGER -- Production Amount
);
-- However, More often, you import a table from CSV.




-- Chapter 1: Every Learner starts from SELECT
-- Suppose we have a TABLE, AND we want TO GET SOME SPECIFIC columns FROM the TABLE. We should use SELECT.
-- For example, we can select every column in the table using a wildcard *
SELECT * FROM coffee_production;

-- Or just some specific columns
SELECT Year FROM coffee_production;
SELECT Year, Value From coffee_production;

-- You may want to write it more clearly
SELECT coffee_production.'Year' FROM coffee_production;
SELECT coffee_production.Year FROM coffee_production;
SELECT cp.'Year' FROM coffee_production cp; -- Use alias

-- If you want to limit the return numbers, like df.head(3) in Python Pandas
SELECT coffee_production.'Year' FROM coffee_production LIMIT 3;

-- If you want the results in some DESC or ASC order
SELECT coffee_production.'Year' FROM coffee_production ORDER BY coffee_production.'Year' DESC LIMIT 10 ;
SELECT coffee_production.'Year' FROM coffee_production ORDER BY coffee_production.'Year' ASC LIMIT 5;

-- If you want the results under some filter conditions, the most comman way is to use WHERE
SELECT coffee_production.'Year' AS Y FROM coffee_production WHERE Y > 2000 ORDER BY Y ASC LIMIT 5;

-- WHERE supports equal =, not equal <>, larger >, smaller <, >=, <=, Filter1 AND Filter2, Variable IN (1,2,3), Variable IS NULL, Variable BETWEEN 1 and 5, Filter1 OR Filter2
SELECT coffee_production.'Year' AS Y FROM coffee_production WHERE Y BETWEEN 1990 and 2000 ORDER BY Y ASC;
SELECT coffee_production.'Year' AS Y FROM coffee_production WHERE Y NOT BETWEEN 1900 and 2000 ORDER BY Y ASC;
SELECT coffee_production.'Year' AS Y FROM coffee_production WHERE Y NOT BETWEEN 1900 and 2000 AND Y <> 2005 ORDER BY Y ASC;
SELECT coffee_production.'Year' AS Y FROM coffee_production WHERE Y IS NULL;
SELECT coffee_production.'Year' AS Y FROM coffee_production WHERE (Y IN (2000,2001) OR Y > 2005) AND Y < 2001; -- OR will execute the first condition if satisfied

-- Wildcard for STRING '%tring' 'Strin%' '%trin%' 'S%G' or single char wildcard 'Stri_g'
SELECT sl.State FROM state_lookup sl WHERE sl.State like 'F%';

-- Math Operations + - * /
-- Aggregate Functions AVG() COUNT() MIN() MAX() SUM(); you often use these with group by to create aggregate functions for each groups
SELECT COUNT(Year) AS Total_year from coffee_production cp;
SELECT mp.State_ANSI, ROUND(AVG(Value)/1000000, 2) FROM milk_production mp GROUP BY mp.State_ANSI ORDER BY AVG(Value) DESC LIMIT 10;





-- Chapter 2: SQL is all about relational tables
-- Subqueries are fast but little bit hard to understand
SELECT hp.State_ANSI , ROUND(AVG(hp.Value),0) AS A FROM honey_production hp 
	WHERE hp.State_ANSI in (
		SELECT sl.State_ANSI FROM  state_lookup sl
			WHERE sl.State like '%s%')
	GROUP BY hp.State_ANSI ORDER BY A DESC;
	
-- Subqueries can make your query really complex, for example,
-- Notice that a subquery can only select one column at a time.
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name, e.department_id,

    -- Subquery #1: Retrieve the department name from the departments table
    (SELECT d.department_name
     FROM departments d
     WHERE d.department_id = e.department_id
    ) AS department_name,
    
    -- Subquery #2: Calculate this employee's average salary across all historical records
    (SELECT AVG(sh.salary)
     FROM employee_salary_history sh
     WHERE sh.employee_id = e.employee_id
    ) AS average_salary_history,
    
    FROM employee e;
--HOW TO BREAK IT DOWN?! FROM THE INNER MOST!
    
-- LET'S JOIN!!!!!!!!!!!!!!! JOIN allows data retrieval from multiple tables in one query
    -- Basic Framework: LEFT JOIN based on the most important table (no information loss) and combine additional info from other tables
    SELECT hp.State_ANSI, hp."Year" , hp.Value, sl.State 
    FROM honey_production hp LEFT JOIN state_lookup sl ON hp.State_ANSI = sl.State_ANSI 
    
	-- INNER JOIN combine two table based on the intersect part. (both tables may loss info after INNER JOIN)
    SELECT hp.State_ANSI, hp."Year" , hp.Value, sl.State 
    FROM honey_production hp INNER JOIN state_lookup sl ON hp.State_ANSI = sl.State_ANSI 
    
	-- FULL OUTER JOIN, just return and give me everything!
	SELECT *
    FROM honey_production hp FULL OUTER JOIN state_lookup sl ON hp.State_ANSI = sl.State_ANSI 
	
-- UNION (rarely used)
SELECT hp.Value FROM honey_production hp 
UNION 
SELECT coffee_production.'Year' FROM coffee_production;

-- Cross JOIN (rarely used) Return row number will be the number of joins in the first table multipled by the number of rows in second table
SELECT Col1, Col2 FROM TABLE1 CROSS JOIN TABLE2
