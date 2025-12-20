USE imdb;

show tables;

describe director_mapping; 
describe genre; 
describe movie; 
describe names; 
describe ratings; 
describe role_mapping;

-- confirm date & text formats
select date_published, country, languages from movie limit 5;

-- Q1: Find total number of movies released each year.

SELECT 'director_mapping' AS table_name, COUNT(*) AS total_rows FROM director_mapping
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'movie', COUNT(*) FROM movie
UNION ALL
SELECT 'names', COUNT(*) FROM names
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings
UNION ALL
SELECT 'role_mapping', COUNT(*) FROM role_mapping;


-- Q2: Check which columns in movie table have NULL values.

SELECT
    COUNT(*) - COUNT(id) AS id_nulls,
    COUNT(*) - COUNT(title) AS title_nulls,
    COUNT(*) - COUNT(year) AS year_nulls,
    COUNT(*) - COUNT(date_published) AS date_published_nulls,
    COUNT(*) - COUNT(duration) AS duration_nulls,
    COUNT(*) - COUNT(country) AS country_nulls,
    COUNT(*) - COUNT(worlwide_gross_income) AS worldwide_income_nulls,
    COUNT(*) - COUNT(languages) AS languages_nulls,
    COUNT(*) - COUNT(production_company) AS production_company_nulls
FROM movie;


-- Q3: Find total movies per year and month-wise trend.

-- movies released each year
SELECT 
    year AS Year,
    COUNT(*) AS number_of_movies
FROM movie
WHERE year IS NOT NULL
GROUP BY year
ORDER BY year;

-- movies released each month

SELECT MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM movie
WHERE date_published IS NOT NULL
GROUP BY month_num
ORDER BY month_num;


-- Q4: Count movies produced in USA or India in 2019.

SELECT COUNT(*) AS number_of_movies, year
FROM movie
WHERE year = 2019
  AND (country LIKE '%USA%' OR country LIKE '%India%');


-- Q5: List all unique genres in the dataset.

SELECT DISTINCT genre
FROM genre
ORDER BY genre;

-- Q6: Find the genre with highest number of movies.

SELECT genre, COUNT(movie_id) AS number_of_movies
FROM genre
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1;

-- Q7: Count movies that belong to only one genre.

SELECT COUNT(*) AS movies_with_single_genre
FROM (SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(genre) = 1) AS single_genre_movies;

-- Q8: Find average movie duration for each genre.

SELECT g.genre,
    ROUND(AVG(m.duration), 2) AS avg_duration
FROM movie m
JOIN genre g 
    ON m.id = g.movie_id
WHERE m.duration IS NOT NULL
GROUP BY g.genre
ORDER BY avg_duration DESC;

-- Q9: Rank genres by number of movies (to find Thriller rank).

SELECT genre,
    COUNT(movie_id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre
ORDER BY genre_rank;

-- Q10: Get min and max values for all numeric columns in ratings.

SELECT
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;


-- Q11: List top 10 movies based on average rating.

SELECT title, avg_rating, movie_rank
FROM (SELECT 
        m.title,
        r.avg_rating,
        RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
    FROM movie m
    JOIN ratings r 
        ON m.id = r.movie_id) AS ranked_movies
WHERE movie_rank <= 10
ORDER BY movie_rank, title;


-- Q12: Summarize number of movies by each median rating.

SELECT median_rating,
    COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;


-- Q13: Find top production house producing movies with avg rating > 8.

SELECT production_company,
    COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_company_rank
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
WHERE r.avg_rating > 8
  AND production_company IS NOT NULL
GROUP BY production_company
ORDER BY prod_company_rank;


-- Q14: Count movies per genre released in USA during March 2017 with >1000 votes.

SELECT g.genre,
    COUNT(*) AS movie_count
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
JOIN genre g 
    ON m.id = g.movie_id
WHERE YEAR(m.date_published) = 2017
  AND MONTH(m.date_published) = 3
  AND m.country LIKE '%USA%'
  AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;

-- Q15: Find movies starting with 'The' having avg rating > 8.

SELECT m.title, r.avg_rating, g.genre
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
JOIN genre g 
    ON m.id = g.movie_id
WHERE m.title LIKE 'The%'
  AND r.avg_rating > 8
ORDER BY r.avg_rating DESC, m.title;


-- Q16: Count movies released between Apr 2018 and Apr 2019 with median rating = 8.

SELECT 
    COUNT(*) AS movie_count
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
  AND r.median_rating = 8;

-- Q17: Compare total votes of German vs Italian movies.

SELECT m.country,
    SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
WHERE m.country LIKE '%Germany%' 
   OR m.country LIKE '%Italy%'
GROUP BY m.country
ORDER BY total_votes DESC;

-- Q18: Check which columns in names table have NULL values.

SELECT
    COUNT(*) - COUNT(name) AS name_nulls,
    COUNT(*) - COUNT(height) AS height_nulls,
    COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
    COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;


-- Q19: Find top 3 directors in top 3 genres with avg rating > 8.
	
    -- Find top 3 genres with avg rating > 8
SELECT 
    g.genre,
    COUNT(g.movie_id) AS movie_count
FROM genre g
JOIN ratings r 
    ON g.movie_id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY g.genre
ORDER BY movie_count DESC;

	-- Find top 3 directors from those genres with avg rating > 8
SELECT 
    n.name AS director_name,
    COUNT(*) AS movie_count
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
JOIN genre g 
    ON m.id = g.movie_id
JOIN director_mapping d 
    ON m.id = d.movie_id
JOIN names n 
    ON d.name_id = n.id
WHERE r.avg_rating > 8
  AND g.genre IN ('Drama', 'Action', 'Thriller')  -- 👈 Replace with your actual top 3 genres
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;


-- Q20: Find top 2 actors whose movies have median rating >= 8.

SELECT 
    n.name AS actor_name,
    COUNT(*) AS movie_count
FROM names n
JOIN role_mapping rm 
    ON n.id = rm.name_id
JOIN ratings r 
    ON rm.movie_id = r.movie_id
WHERE rm.category = 'actor'
  AND r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;


-- Q21: Find top 3 production houses by total votes received.

SELECT 
    m.production_company,
    SUM(r.total_votes) AS vote_count,
    RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
WHERE m.production_company IS NOT NULL
GROUP BY m.production_company
ORDER BY prod_comp_rank
LIMIT 3;


-- Q22: Rank Indian actors (with >=5 movies) by weighted average rating.

CREATE TEMPORARY TABLE indian_movies AS
SELECT id FROM movie WHERE country LIKE '%India%';

	-- Join only what’s needed
    
SELECT n.name, COUNT(*) AS movie_count
FROM indian_movies im
JOIN role_mapping rm ON im.id = rm.movie_id
JOIN ratings r ON im.id = r.movie_id
JOIN names n ON rm.name_id = n.id
WHERE r.median_rating >= 8
GROUP BY n.name
order by movie_count DESC;


-- Q23: Find top 5 Hindi actresses (>=3 movies) by weighted average rating.

SELECT 
    n.name AS actress_name,
    COUNT(r.movie_id) AS movie_count,
    SUM(r.total_votes) AS total_votes,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS avg_rating
FROM names n
JOIN role_mapping rm ON n.id = rm.name_id
JOIN ratings r ON rm.movie_id = r.movie_id
JOIN movie m ON m.id = r.movie_id
WHERE rm.category = 'actress'
  AND m.country LIKE '%India%'
  AND m.languages LIKE '%Hindi%'
GROUP BY n.name
HAVING COUNT(r.movie_id) >= 3
ORDER BY avg_rating DESC
LIMIT 5;

-- Q24: Classify thriller movies (≥25k votes) into Superhit/Hit/One-time/Flop by avg rating.

SELECT 
    m.title AS movie_name,
    CASE 
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS movie_category
FROM movie m
JOIN ratings r ON m.id = r.movie_id
JOIN genre g ON m.id = g.movie_id
WHERE g.genre = 'Thriller'
  AND r.total_votes >= 25000
ORDER BY r.avg_rating DESC;


-- Q25: Calculate genre-wise running total and moving average of movie durations.

SELECT 
    g.genre,
    ROUND(AVG(m.duration), 2) AS avg_duration,
    ROUND(SUM(AVG(m.duration)) OVER (ORDER BY g.genre), 2) AS running_total_duration,
    ROUND(AVG(AVG(m.duration)) OVER (ORDER BY g.genre ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM movie m
JOIN genre g ON m.id = g.movie_id
WHERE m.duration IS NOT NULL
GROUP BY g.genre
ORDER BY g.genre;


-- Q26: Find top 5 highest-grossing movies of each year in top 3 genres.

SELECT 
    g.genre,
    COUNT(*) AS movie_count
FROM genre g
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 3;

	-- step 2

SELECT *
FROM (
    SELECT 
        g.genre,
        m.year,
        m.title AS movie_name,
        m.worlwide_gross_income,
        RANK() OVER (PARTITION BY m.year, g.genre ORDER BY m.worlwide_gross_income DESC) AS movie_rank
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    WHERE g.genre IN ('Drama', 'Comedy', 'Action')  -- replace with your actual top 3
      AND m.worlwide_gross_income IS NOT NULL
) AS ranked_movies
WHERE movie_rank <= 5
ORDER BY year, genre, movie_rank;

-- Q27: Find top 2 production houses with most hits (median rating ≥8) among multilingual movies.

SELECT 
    m.production_company,
    COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_comp_rank
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE r.median_rating >= 8
  AND m.languages LIKE '%,%'      -- multilingual check
  AND m.production_company IS NOT NULL
GROUP BY m.production_company
ORDER BY prod_comp_rank
LIMIT 2;


-- Q28: Find top 3 actresses in Drama genre with Superhit movies (avg rating > 8).

SELECT 
    n.name AS actress_name,
    COUNT(r.movie_id) AS movie_count,
    SUM(r.total_votes) AS total_votes,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS avg_rating
FROM names n
JOIN role_mapping rm ON n.id = rm.name_id
JOIN ratings r ON rm.movie_id = r.movie_id
JOIN genre g ON rm.movie_id = g.movie_id
WHERE rm.category = 'actress'
  AND g.genre = 'Drama'
  AND r.avg_rating > 8
GROUP BY n.name
ORDER BY avg_rating DESC, total_votes DESC, actress_name ASC
LIMIT 3;


-- Q29: Show stats for top 9 directors (movies count, avg rating, votes, duration, etc.).

SELECT 
    n.id AS director_id,
    n.name AS director_name,
    COUNT(m.id) AS number_of_movies,
    ROUND(AVG(r.avg_rating), 2) AS avg_rating,
    SUM(r.total_votes) AS total_votes,
    MIN(r.avg_rating) AS min_rating,
    MAX(r.avg_rating) AS max_rating,
    SUM(m.duration) AS total_duration
FROM names n
JOIN director_mapping d ON n.id = d.name_id
JOIN movie m ON d.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
GROUP BY n.id, n.name
ORDER BY number_of_movies DESC
LIMIT 9;

