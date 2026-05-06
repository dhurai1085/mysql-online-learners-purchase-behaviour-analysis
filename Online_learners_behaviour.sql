/*Tasks
1. Create the database and schema. Populate the Schema:
●	Create a Database for this project and
●	Create all three tables in MySQL with appropriate data types and relationships.
●	Insert sample data covering at least:
○	4–5 learners
○	4–5 courses (spread across multiple categories)
○	6–8 purchase records*/
create database online_learners_behaviour;
use online_learners_behaviour;

-- creating learners table
create table learners(
learner_id int primary key,
full_name varchar(50),
country varchar(20)
);

-- Creating courses table
create table courses(
course_id int primary key,
course_name varchar(50),
category varchar(20),
unit_price decimal
);
alter table courses
modify category varchar(100);

-- creating purchases table
create table purchases(
purchase_id int primary key,
learner_id int,
course_id int,
quantity int,
purchase_date date,
foreign key(learner_id) references learners(learner_id)
on delete cascade
on update cascade,
foreign key(course_id) references courses(course_id)
on delete cascade
on update cascade

);

/*•	Insert sample data covering at least:
○	4–5 learners
○	4–5 courses (spread across multiple categories)
○	6–8 purchase records
*/
-- Populating learners table
INSERT INTO learners (learner_id, full_name, Country) VALUES
(101, 'Arun Kumar', 'India'),
(102, 'Meera Nair', 'India'),
(103, 'John Smith', 'USA'),
(104, 'Aisha Khan', 'UAE'),
(105, 'Daniel Lee', 'Singapore'),
(106, 'Priya Sharma', 'India'),
(107, 'Carlos Gomez', 'Spain'),
(108, 'Fatima Ali', 'Saudi Arabia');

-- Populating courses table
INSERT INTO courses (course_id, course_name, category, unit_price) VALUES
(201, 'SQL Basics', 'Database', 120),
(202, 'Advanced SQL', 'Database', 180),
(203, 'Python for Data Analysis', 'Programming', 200),
(204, 'Excel for Beginners', 'Productivity', 90),
(205, 'Power BI Fundamentals', 'Data Visualization', 150),
(206, 'Machine Learning Intro', 'Artificial Intelligence', 250),
(207, 'Web Development HTML & CSS', 'Web Development', 110),
(208, 'Java Programming', 'Programming', 170);

-- Populating purchases table
INSERT INTO purchases (purchase_id, learner_id, course_id, Quantity, purchase_date) VALUES
(301, 101, 201, 1, '2025-01-10'),
(302, 102, 203, 1, '2025-01-12'),
(303, 103, 202, 2, '2025-01-15'),
(304, 104, 205, 1, '2025-01-18'),
(305, 105, 204, 3, '2025-01-20'),
(306, 106, 201, 1, '2025-01-22'),
(307, 107, 207, 2, '2025-01-25'),
(308, 108, 206, 1, '2025-01-28'),
(309, 101, 205, 1, '2025-02-02'),
(310, 102, 208, 1, '2025-02-05'),
(311, 103, 203, 1, '2025-02-07'),
(312, 104, 201, 2, '2025-02-10');

select * from learners;
select * from courses;
select * from purchases;


/*2. Data Exploration Using Joins
		 Data Presentation Guidelines for the following query 
●	Format currency values to 2 decimal places.
●	Use aliases for column names (e.g., AS total_revenue).
●	Sort results appropriately (e.g., highest total_spent first).
*/
alter table courses
modify unit_price decimal(10,2);

select p.*, 
(c.unit_price * p.quantity) as total_revenue
from purchases p
join courses c on
p.course_id = c.course_id
order by total_revenue desc;

/*Use SQL INNER JOIN, LEFT JOIN, and RIGHT JOIN to:
●	Combine learner, course, and purchase data.
●	Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date).
*/

select l.learner_id, c.course_name,c.category,
p.quantity,(c.unit_price * p.quantity) total_amount,
purchase_date from learners l
join purchases p on
l.learner_id = p.learner_id
join courses c on
c.course_id = p.course_id;

/*3. Analytical Queries
		Write SQL queries to answer the following questions:
Q1. Display each learner’s total spending (quantity × unit_price) along with their country.
*/
select l.learner_id, l.full_name,
(p.quantity * c.unit_price) total_spending
from learners l 
join purchases p on
l.learner_id = p.learner_id
join courses c on
c.course_id = p.course_id;

/* Q2. Find the top 3 most purchased courses based on total quantity sold.*/
SELECT 
    c.course_id,
    c.course_name,
    SUM(p.quantity) AS total_quantity
FROM courses c
JOIN purchases p 
    ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_quantity DESC
LIMIT 3;

/*Q3. Show each course category’s total revenue and the number of unique learners who purchased from that category.*/
select c.course_name,
sum(p.quantity * c.unit_price)total_revenue,
count(distinct p.learner_id)unique_learners
from courses c 
join purchases p on
c.course_id = p.course_id
group by c.course_name
order by total_revenue desc;

/*Q4. List all learners who have purchased courses from more than one category.*/
select l.learner_id,l.full_name,
count(distinct c.category) purchased_category
from learners l 
join purchases p on
l.learner_id = p.learner_id
join courses c on
c.course_id = p.course_id
group by l.learner_id,l.full_name
having purchased_category > 1;


/*Q5. Identify courses that have not been purchased at all.*/
select course_id,course_name
from courses
where course_id not in(select course_id from purchases);

-- alternate method
SELECT c.course_id, c.course_name
FROM courses c
LEFT JOIN purchases p
ON c.course_id = p.course_id
WHERE p.course_id IS NULL;




























