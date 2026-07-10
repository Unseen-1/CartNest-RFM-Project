use CartNestDB
-- Query 1: Top 10% customers by revenue
select top 10 percent 
	customer_ID,
	ROUND(SUM(Net_Amount),2) as Total_Revenue
from transactions
group by Customer_ID
order by Total_Revenue desc;

-- Query 2a: Calculate RFM base metrics
SELECT
    Customer_ID,
    DATEDIFF(DAY, MAX(Transaction_Date), '2024-12-31') AS Recency,
    COUNT(DISTINCT Transaction_ID) AS Frequency,
    ROUND(SUM(Net_Amount),2) AS Monetary
FROM transactions
GROUP BY Customer_ID
ORDER BY Monetary DESC;

-- Query 2b: RFM Scoring (splits customers into 5 groups each for R, F, M)
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

-- Creating a reusable view for RFM segments
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
        GROUP BY Customer_ID
    ) AS base
) AS scored;

-- Query 3: Count customers per segment
SELECT Segment, COUNT(*) AS Customer_Count
FROM vw_customer_rfm
GROUP BY Segment
ORDER BY Customer_Count DESC;

-- Query 5: Revenue contribution by segment
SELECT
    Segment,
    COUNT(*) AS Customer_Count,
    ROUND(SUM(Monetary), 2) AS Total_Revenue,
    ROUND(SUM(Monetary) * 100.0 / (SELECT SUM(Monetary) FROM vw_customer_rfm), 2) AS Revenue_Pct
FROM vw_customer_rfm
GROUP BY Segment
ORDER BY Total_Revenue DESC;

-- Query 6: Revenue by category within each segment (answers Q4)
SELECT r.Segment, t.Category, ROUND(SUM(t.Net_Amount), 2) AS Category_Revenue
FROM transactions t
JOIN vw_customer_rfm r ON t.Customer_ID = r.Customer_ID
GROUP BY r.Segment, t.Category
ORDER BY r.Segment, Category_Revenue DESC;

-- Query 7: Champions distribution by region (answers Q5)
SELECT
    c.Region,
    COUNT(*) AS Champion_Count
FROM customers c
JOIN vw_customer_rfm r ON c.Customer_ID = r.Customer_ID
WHERE r.Segment = 'Champions'
GROUP BY c.Region
ORDER BY Champion_Count DESC;

-- Query 8: Monthly revenue trend (answers Q7)
SELECT 
    FORMAT(Transaction_Date, 'yyyy-MM') AS Month,
    ROUND(SUM(Net_Amount), 2) AS Monthly_Revenue
FROM transactions
GROUP BY FORMAT(Transaction_Date, 'yyyy-MM')
ORDER BY Month;

-- Query 9: Payment mode & channel preference among Champions (answers Q8)
SELECT t.Payment_Mode, t.Channel, COUNT(*) AS Transaction_Count
FROM transactions t
JOIN vw_customer_rfm r ON t.Customer_ID = r.Customer_ID
WHERE r.Segment = 'Champions'
GROUP BY t.Payment_Mode, t.Channel
ORDER BY Transaction_Count DESC;
