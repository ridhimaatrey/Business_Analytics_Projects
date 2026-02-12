# Customer Churn Analysis – Banking Industry (SQL Project)

## Project Overview
This project focuses on analysing customer churn behaviour in the banking industry using SQL.
The analysis was performed using PostgreSQL to identify patterns in customer attrition and understand which factors influence churn the most.
The final output includes SQL queries, cohort analysis, business insights, and strategic recommendations for reducing churn.

## Business Objective
Customer churn is a major problem for banks because losing customers directly impacts revenue and long-term growth.

### The objective of this project was to:
Identify key factors contributing to customer churn
Segment customers based on behaviour
Calculate churn rates across important variables
Provide actionable recommendations to improve retention
The analysis was designed from a business perspective, focusing on areas that the bank can actually act upon.

## Dataset Summary
The dataset contains customer-level information including:
Customer ID

Credit Score

Age

Tenure

Account Balance

Number of Products

IsActiveMember

Geography

Exited (Churn Indicator)

The Exited column was used as the target variable to calculate churn rate.

Total records:10,000 customers

## Tools Used
PostgreSQL
SQL (DDL, DML, Aggregations, CASE statements, Window Functions)
Excel (for validation and review)
PowerPoint (for presentation of findings)

## Approach

The analysis was carried out in structured and logical steps to ensure clarity and business relevance.

### 1. Data Setup and Exploration
The dataset was loaded into PostgreSQL.
Initial exploration was done to understand the structure, data types, and key variables. Basic validation checks were performed to ensure the data was usable for analysis.

### 2. Understanding Overall Churn Rate
The overall churn percentage was calculated using aggregation functions.
This helped establish a baseline understanding of the churn problem before diving deeper.

### 3. Summary Statistics Analysis
Descriptive statistics such as mean, median, minimum, and maximum were calculated for numerical variables like Credit Score and Balance.
This helped understand the distribution and variability of customer financial behaviour.

### 4. Segmentation Using CASE Statements
Customers were segmented into groups based on:

Credit Score ranges

Tenure ranges

This allowed comparison of churn rates across meaningful business segments rather than individual raw values.

### 5. Churn Rate Comparison Across Segments
Churn rates were calculated for each segment to identify patterns.
This step helped determine which customer groups were more likely to leave.

### 6. Cohort Analysis (Tenure-Based)
Customers were grouped into tenure-based cohorts to analyse churn behaviour across different lifecycle stages.
Churn rate was calculated for each cohort to identify when churn risk is highest.

### 7. Customer Ranking Using Window Functions
SQL window functions (ROW_NUMBER) were used to rank retained customers based on Tenure and Credit Score.
This helped identify high-value customers who should be prioritised for retention strategies.

### 8. Business Interpretation and Recommendation Development
All analytical results were interpreted from a business perspective.
The final step involved identifying three key focus areas that leadership can act upon to reduce churn.

## Key Insights / Findings

* Customers with lower tenure showed relatively higher churn rates.
* Financial stability (Credit Score) had a measurable impact on churn behaviour.
* Early-stage customers are more likely to leave if not engaged properly.
* Long-tenure and high-credit customers are high-value retention targets.
* Cohort analysis helped identify which tenure segments need immediate attention.

Based on this, strategic recommendations were provided to improve onboarding, engagement, and targeted retention programs.

## File Structure
### dataset
bank_churn_dataset.csv
### sql
customer_churn_analysis.sql
### presentation
Customer_Churn_Analysis_Presentation.pptx
