# IMDb Movie Data Analysis using SQL

This project demonstrates the use of **SQL for end-to-end business analysis** on a complex, multi-table IMDb dataset.  
The focus is on uncovering meaningful insights related to movie performance, audience preferences, and industry trends.

All analysis was performed using **pure SQL**, without altering the dataset externally.


## Project Overview

The IMDb dataset consists of multiple interrelated tables containing information about movies, ratings, genres, production houses, cast, and crew.

The data was imported into MySQL, relationships were established between tables, and structured SQL queries were written to extract insights that are relevant from a business and decision-making perspective.

## Key Areas of Analysis

The analysis focuses on:

- Genre-wise movie performance and popularity trends  
- Production houses associated with high-rated and highly voted movies  
- Actor and actress performance based on average ratings  
- Director-level analysis considering ratings, votes, and movie count  
- Classification of movies based on audience ratings  


## Key Insights

Some of the important insights derived from the analysis include:

- **Drama** emerged as the most common movie genre across the dataset.  
- **Marvel Studios** and **Warner Bros.** consistently appeared among top production houses with highly rated and popular movies.  
- **Vijay Sethupathi** ranked among the top Indian actors based on average movie ratings.  
- **Tabu** and **Taapsee Pannu** showed strong performance among Hindi actresses.  
- **Thriller movies** were categorised into Superhit, Hit, One-Time Watch, and Flop based on rating thresholds.  
- Director analysis highlighted patterns between movie count, average ratings, and audience engagement.

## Files Included

- `IMDB_project_final.sql`  
  → Complete SQL script containing all queries with optimised joins and structured logic  

- `IMDB_Project_Report.pdf`  
  → Executive-style report summarising key findings and insights from the analysis  


## What This Project Reinforced

- SQL can independently handle complex analytical workflows  
- Well-structured joins and aliases improve both performance and readability  
- Business insights emerge when queries are driven by clear analytical questions  
- Translating queries into insights is as important as writing the queries themselves  


## Next Steps

Building on this analysis by:
- Extending insights using Python for deeper exploratory analysis  
- Creating visual dashboards for executive storytelling  
- Applying similar SQL-driven analysis to SaaS and business datasets  

