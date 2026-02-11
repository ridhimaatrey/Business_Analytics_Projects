--Created table and loaded data

drop Table bank_churn;
CREATE TABLE bank_churn (
    RowNumber INT,
    CustomerId INT,
    Surname TEXT,
    CreditScore INT,
    Geography TEXT,
    Gender TEXT,
    Age INT,
    Tenure INT,
    Balance NUMERIC,
    NumOfProducts INT,
    HasCrCard INT,
    IsActiveMember INT,
    EstimatedSalary NUMERIC,
    Exited INT
);



--checked data loaded perfecly

select count (*) from bank_churn;
SELECT * FROM bank_churn LIMIT 5;



-- read data

SELECT
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'bank_churn'
ORDER BY ordinal_position;



-- added and populated creditScoreBand

alter table bank_churn
add column creditScoreBand text;

UPDATE bank_churn
SET creditScoreBand =
	CASE 
	WHEN creditScore < 600 then 'Low'
	WHEN creditScore between 600 and 700 then 'Medium'
	Else 'High'
	END;

Select
creditScoreBand,
Round(AVG(exited) *100,2) as churn_rate,
Count(*) as Total_Customer
From bank_churn
Group BY creditScoreBand;



-- added and populated Tenure band

alter table bank_churn
add column TenureBand text;

UPDATE bank_churn
SET TenureBand =
	CASE 
	WHEN tenure <= 2 then 'New Customers'
	WHEN tenure between 3 and 6 then 'Mid Tenure'
	Else 'Long Tenure'
	END;

Select
tenureBand,
Round(AVG(exited) *100,2) as churn_rate,
Count(*) as Total_Customer
From bank_churn
Group BY tenureBand;

-- Summary statistics

Select
Round(AVG(creditScore),2) as Mean,
percentile_cont(0.5) within group (order by creditscore) as Median,
min(CreditScore) as Minimum,
max(creditScore) as Maximum
from bank_churn;

select
Round(AVG(balance),2) as Mean,
percentile_cont(0.5) within group (order by balance) as Median,
min(balance) as Minimum,
max(balance) as Maximum
from bank_churn;

WITH retention_customers AS (
    SELECT
        CustomerId,
        Tenure,
        CreditScore,
        ROW_NUMBER() OVER (ORDER BY Tenure DESC, CreditScore DESC) AS retention_rank
    FROM bank_churn
    WHERE Exited = 0
)
SELECT
    CustomerId,
    Tenure,
    CreditScore
FROM retention_customers
WHERE retention_rank <= 5;

--cohort

SELECT
    CASE
        WHEN Tenure BETWEEN 0 AND 1 THEN '0–1 Years'
        WHEN Tenure BETWEEN 2 AND 4 THEN '2–4 Years'
        WHEN Tenure BETWEEN 5 AND 7 THEN '5–7 Years'
        ELSE '8–10 Years'
    END AS tenure_cohort,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM bank_churn
GROUP BY tenure_cohort
ORDER BY tenure_cohort;



