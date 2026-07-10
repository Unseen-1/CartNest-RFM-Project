USE CartNestDB

-- Query 1: Top 10% customers by revenue
-- Output: 78 customers returned, led by highest spenders (e.g. CUST0002 ~2.4L)
select top 10 percent 
	customer_ID,
	ROUND(SUM(Net_Amount),2) as Total_Revenue
from transactions
group by Customer_ID
order by Total_Revenue desc;

-- Query 2a: Calculate RFM base metrics
-- Output: Recency (days since last purchase), Frequency (order count), Monetary (total spend) per customer
SELECT
    Customer_ID,
    DATEDIFF(DAY, MAX(Transaction_Date), '2024-12-31') AS Recency,
    COUNT(DISTINCT Transaction_ID) AS Frequency,
    ROUND(SUM(Net_Amount),2) AS Monetary
FROM transactions
GROUP BY Customer_ID
ORDER BY Monetary DESC;

-- Query 2b: RFM Scoring (splits customers into 5 groups each for R, F, M)
-- Output: R_Score, F_Score, M_Score (1-5) assigned per customer using NTILE
SELECT Customer_ID, Recency, Frequency, Monetary,
    NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
    NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
    NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
FROM (
    SELECT
        Customer_ID,
        DATEDIFF(DAY, MAX(Transaction_Date), '2024-12-31') AS Recency,
        COUNT(DISTINCT Transaction_ID) AS Frequency,
        SUM(Net_Amount) AS Monetary
    FROM transactions
    GROUP BY Customer_ID
) AS base
ORDER BY Monetary DESC;

-- Query 2c: Assign customer segments based on RFM score
-- Output: Each customer labeled Champions / Loyal / At Risk / Lost based on RFM_Total
SELECT Customer_ID, Recency, Frequency, Monetary,
    (R_Score + F_Score + M_Score) AS RFM_Total,
    CASE
        WHEN (R_Score + F_Score + M_Score) >= 12 THEN 'Champions'
        WHEN (R_Score + F_Score + M_Score) >= 9 THEN 'Loyal'
        WHEN (R_Score + F_Score + M_Score) >= 6 THEN 'At Risk'
        ELSE 'Lost'
    END AS Segment
FROM (
    SELECT
        Customer_ID, Recency, Frequency, Monetary,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM (
        SELECT
            Customer_ID,
            DATEDIFF(DAY, MAX(Transaction_Date), '2024-12-31') AS Recency,
            COUNT(DISTINCT Transaction_ID) AS Frequency,
            SUM(Net_Amount) AS Monetary
        FROM transactions
        GROUP BY Customer_ID
    ) AS base
) AS scored
ORDER BY RFM_Total DESC;

-- Creating a reusable view for RFM segments (reused in Queries 3, 5, 6, 7, 9)
CREATE VIEW vw_customer_rfm AS
SELECT Customer_ID, Recency, Frequency, Monetary, (R_Score + F_Score + M_Score) AS RFM_Total,
    CASE
        WHEN (R_Score + F_Score + M_Score) >= 12 THEN 'Champions'
        WHEN (R_Score + F_Score + M_Score) >= 9 THEN 'Loyal'
        WHEN (R_Score + F_Score + M_Score) >= 6 THEN 'At Risk'
        ELSE 'Lost'
    END AS Segment
FROM (
    SELECT Customer_ID, Recency, Frequency, Monetary,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM (
        SELECT
            Customer_ID,
            DATEDIFF(DAY, MAX(Transaction_Date), '2024-12-31') AS Recency,
            COUNT(DISTINCT Transaction_ID) AS Frequency,
            SUM(Net_Amount) AS Monetary
        FROM transactions
