# CartNest - Customer Segmentation using RFM Analysis

End-to-end data analytics project using **SQL, Python, and Power BI** to segment customers based on purchasing behavior and drive data-informed marketing decisions.

## Business Problem
CartNest, a mid-sized e-commerce retailer, spends marketing budget equally across all customers with no way to identify which customers actually drive revenue. This project builds an RFM (Recency, Frequency, Monetary) segmentation model to fix that.

## Key Findings
- **Champions** (29% of customers) generate **75% of total revenue**
- **Electronics** is the top revenue category across all customer segments
- Revenue grew consistently month-over-month across the 2-year dataset (2023-2024)
- No dominant payment/channel preference among high-value customers

## Tech Stack
- **SQL** (SQL Server) :- RFM scoring using window functions (NTILE), CTEs, JOINs, Views
- **Python** (Pandas, Matplotlib, Seaborn) :- data cleaning, RFM cross-validation, visualization
- **Power BI** :- 3-page interactive dashboard (Executive, Operational, Manager views)

## Repository Structure
'''
**SQL/**                 -> RFM analysis queries | 
**Python/**             -> Data cleaning, EDA, RFM notebook | 
**Excel/**              -> Pivot Table validation & VLOOKUP demo
**PowerBi/**             -> Dashboard screenshots | 
**Data/**              -> Cleaned datasets used in analysis | 
**Documentation/**        -> Full project documentation (BRD, FRD, recommendations)
'''

## Dashboard Preview
See `PowerBi/` folder for Executive Summary, Operational Analysis, and Manager Insights pages.

## Business Recommendations
1. Prioritize retention programs for Champions segment
2. Launch win-back campaigns for At-Risk customers
3. Cross-sell Electronics with Home & Kitchen/Sports
4. Maintain multi-channel and multi-payment support

## Author
Anmol Bhaskar
