# Netflix Movies and TV Shows Data Analysis using SQL
# Project By Yaw Dapaa
![](https://github.com/SyedaAyeshaNoor/netflix_sql_project/blob/main/NETFLIX_OFFICIAL_LOGO.png)
## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Netflix_Movies_TV_Shows Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Netflix Project Schemas

```sql
DROP TABLE IF EXISTS NETFLIX;
CREATE TABLE NETFLIX
(
	show_id VARCHAR(10),
	type VARCHAR (10),
	title VARCHAR(150),
	director VARCHAR(250),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR (50),
	release_year INT,
	rating VARCHAR(15),
	duration VARCHAR(15),
	listed_in VARCHAR (100),
	description VARCHAR (300)
);
```
## Business Problems and Solutions
### 15 concerns from the Netflix dataset answered using SQL Queries.
### 1. Count the number of Movies Vs TV Shows

```sql
SELECT
	type,
	count(*) as total_content
FROM netflix
Group By type;
```
**Objective:** Determine the distribution of content types on Netflix.

## 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT
	type,
	rating
FROM
(
	SELECT
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT (*) DESC) as ranking
FROM netflix
GROUP BY 1,2
	) as t1
WHERE
	ranking =1;
```
**Objective:** Identify the most frequently occurring rating for each type of content.

## 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT*
FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020;
```
**Objective:** Retrieve all movies released in a specific year.

## 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	Count(show_id) as Total_Content
FROM netflix
Group By 1
ORDER BY 2 DESC
LIMIT 5;
```
**Objective:** Identify the top 5 countries with the highest number of content items.

## 5. Identify the Longest Movie

```sql
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix);
```
**Objective:** Find the movie with the longest duration.

## 6. Find Content Added in the Last 5 Years

```sql
SELECT * 
FROM netflix
WHERE 
  date_added IS NOT NULL
  AND date_added LIKE '__-___-__'
  AND TO_DATE(TRIM(date_added), 'DD-Mon-YY') >= CURRENT_DATE - INTERVAL '5 years';
```
**Objective:** Retrieve content added to Netflix in the last 5 years.

## 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT*
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

--OR

SELECT *
	FROM
(
	SELECT 
	*,
	UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
	FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```
**Objective:** List all content directed by 'Rajiv Chilaka'.

## 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT*
FROM NETFLIX
WHERE type = 'TV Show'
AND SPLIT_PART(duration, ' ', 1)::INT> 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

## 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;
```
**Objective:** Count the number of content items in each genre.

## 10.Find each year and the average numbers of content release in United States on netflix. return top 5 year with highest avg_relaese of contents.	

```sql
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM  netflix WHERE country = 'United States')::numeric * 100,2) AS avg_release
FROM netflix
WHERE country = 'United States'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```
**Objective:** Calculate and rank years by the average number of content releases by United States.

## 11. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix
WHERE listed_in ILIKE '%documentaries%';
```
**Objective:** Retrieve all movies classified as documentaries.

## 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```
**Objective:** List content that does not have a director.

## 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT*
	FROM netflix
	WHERE
		casts ILIKE '%Salman Khan%'
		AND
		release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10;
```
**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

## 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in United States

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'United States'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```
**Objective:** Identify the top 10 actors with the most appearances in USA-produced movies.

## 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords. Label content containing these keywords as 'Bad' and all other content as 'Good. '' Count how many items fall into each category.

```sql
SELECT 
    category,
    COUNT(*) AS content_count
FROM(
	SELECT
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
FROM netflix) AS categorized_content
GROUP BY category;
```
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## 📊 Findings & Conclusion

**Diverse Content Portfolio**: The dataset showcases a wide variety of movies and TV shows across multiple genres, reflecting Netflix’s commitment to broad audience appeal.

**Audience Targeting Through Ratings**: Analyzing the most common content ratings reveals how Netflix tailors its offerings to different age groups and viewer preferences.

**Regional Distribution**: Country-wise insights, especially the yearly average content released in United States, highlight Netflix’s strategic focus on key regional markets.

**Content Categorization Trends**: Grouping titles by keywords and genres offers a clearer picture of popular themes and storytelling patterns on the platform.

**Overall, this analysis provides valuable insights into Netflix's content strategy, helping stakeholders make data-driven decisions around audience engagement, market expansion, and content curation.**
