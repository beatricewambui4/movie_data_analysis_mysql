#Movie Project
#create database
CREATE DATABASE movie_mysql_project;
#access the database
USE movie_mysql_project;
#creating table
CREATE TABLE movie_table(
Budget	DECIMAL(12,3),
Genres	VARCHAR(500),
Keywords	TEXT,
Original_Language	TEXT,
Original_Title	TEXT,
Overview	TEXT,
Popularity	DECIMAL(12,8),
Production_Companies TEXT,
Production_Countries	TEXT,
Release_Date	DATE NULL,
Revenue	DECIMAL(12,2),
Runtime	INT,
Spoken_Languages	TEXT,
Status	VARCHAR(100),
Tagline	VARCHAR(500),
Title	VARCHAR(500),
Vote_Average	DECIMAL(12,4),
Vote_Count	DECIMAL(12,4),
Cast	TEXT,
Director TEXT,	
Release_Year YEAR NULL																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																									
);

#Loading data 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clean_movie_data.csv'
INTO TABLE movie_table
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
Budget,
Genres,
Keywords, 
Original_Language, 
Original_Title,
Overview,
Popularity, 
Production_Companies, 
Production_Countries, 
@Release_Date,
Revenue,
Runtime,
Spoken_Languages,
Status,
Tagline, 
Title, 
Vote_Average, 
Vote_Count,
Cast, 
Director, 
@Release_Year
)
SET 
Release_Date = CASE
                   WHEN @Release_Date = '' THEN NULL
                   ELSE STR_TO_DATE(@Release_Date, '%Y-%m-%d')
               END,
Release_Year = CASE
                   WHEN @Release_Year = '' THEN NULL
                   ELSE @Release_Year
               END;

#querying the data  for analysis
#Count the Number of Movies
SELECT
COUNT(*) AS Numberof_movies
FROM movie_table;
#View all unique original languages
SELECT
DISTINCT Original_Language
FROM movie_table
ORDER BY Original_Language;
#Earliest and latest release dates
SELECT
MIN(Release_Date) AS Earliest_release_date,
MAX(Release_Date)AS Latest_release_date
FROM movie_table;
#Top 10 most popular movies
SELECT
Original_Title,
CEIL(Popularity) AS Most_Popular
FROM movie_table
ORDER BY CEIL(Popularity) DESC
LIMIT 10; 
#Top 10 highest rated movies (with enough votes)
SELECT
ROUND(Vote_Average,1) AS Average_ratings,
ROUND(Vote_Count,1) AS Ratings_count,
Original_Title
FROM movie_table
ORDER BY ROUND(Vote_Average,1) DESC,ROUND(Vote_Count,1) DESC
LIMIT 10;
#Average rating of all movies
SELECT
ROUND(AVG(Vote_Average),2) AS Average_ratings
FROM movie_table;
#Top 10 highest revenue movies
SELECT 
Original_Title,
Revenue
FROM movie_table
ORDER BY Revenue DESC
LIMIT 1;
#Top 10 most expensive movies (by budget)
SELECT
Original_Title,
Budget
FROM movie_table
ORDER BY Budget DESC
LIMIT 1;
#Profit for each movie
SELECT 
Original_Title,
ROUND(Revenue-Budget,2) AS Profit
FROM movie_table
ORDER BY ROUND(Revenue-Budget,2) DESC;
#Movies that made a loss
SELECT
Original_Title,
Budget,
Revenue,
(Revenue-Budget) AS Profit
FROM movie_table
WHERE Budget>Revenue
ORDER BY Profit;
#Most common genres
SELECT
Genres,
COUNT(*) AS Number_of_Genres
FROM movie_table
GROUP BY Genres
ORDER BY Number_of_Genres DESC
LIMIT 20;
#Average rating per genre group
SELECT
Genres,
ROUND(AVG(Vote_Average),2) AS Average_Ratings
FROM movie_table
GROUP BY Genres
ORDER BY ROUND(AVG(Vote_Average),2) DESC;
#Number of movies per language
SELECT
COUNT(*) AS Number_of_Movies,
Original_Language
FROM movie_table
GROUP BY Original_Language
ORDER BY Number_of_Movies DESC;
#Highest revenue language
SELECT
Original_Language,
MAX(Revenue) AS Highest_Revenue
FROM movie_table
GROUP BY Original_Language
ORDER BY Highest_Revenue DESC
LIMIT 1;
#count of Movies released per year
SELECT
    Release_Year,
    COUNT(DISTINCT (Original_Title)) AS Number_of_movies
    FROM movie_table
    GROUP BY Release_Year
    ORDER BY Number_of_movies DESC;

#Average rating per year
SELECT
Release_Year,
ROUND(AVG(Vote_Average),2) AS Average_Rating
FROM movie_table
GROUP BY Release_Year
ORDER BY Average_Rating DESC;
#Revenue trend over years
SELECT
ROUND(SUM(Revenue),2) AS Revenue_Totals_Yearly,
Release_Year
FROM movie_table
GROUP BY Release_Year
ORDER BY Revenue_Totals_Yearly DESC;
#Top 5 movies per year (using window function)
SELECT *
FROM (
    SELECT 
        Original_Title,
        YEAR(Release_Date) AS release_year,
        Popularity,
        RANK() OVER (PARTITION BY YEAR(Release_Date) ORDER BY Popularity DESC) AS rank_in_year
    FROM movie_table
) ranked
WHERE rank_in_year <= 5;
#Running total revenue over years
SELECT 
    release_year,
    SUM(yearly_revenue) OVER (ORDER BY release_year) AS running_total_revenue
FROM (
    SELECT 
        YEAR(Release_Date) AS release_year,
        SUM(Revenue) AS yearly_revenue
    FROM movie_table
    GROUP BY YEAR(Release_Date)
) t
ORDER BY release_year;
#Do more popular movies earn more revenue?
SELECT 
    ROUND(AVG(Popularity),2) AS avg_popularity,
    ROUND(AVG(Revenue),2) AS avg_revenue
FROM movie_table;




















