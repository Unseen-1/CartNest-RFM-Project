# 🛒 CartNest — Customer Segmentation using RFM Analysis

End-to-end data analytics project using **SQL, Python, Power BI, and Excel** to segment customers based on purchasing behavior and drive data-informed marketing decisions.

---

## 📌 Business Problem
CartNest, a mid-sized e-commerce retailer, spends marketing budget equally across all customers with no way to identify which customers actually drive revenue. This project builds an RFM (Recency, Frequency, Monetary) segmentation model to fix that.

---

## 🔑 Key Findings
- 🏆 **Champions** (29% of customers) generate **75% of total revenue**
- 📦 **Electronics** is the top revenue category across all customer segments
- 📈 Revenue grew consistently month-over-month across the 2-year dataset (2023-2024)
- 💳 No dominant payment/channel preference among high-value customers

---

## 🧰 Tech Stack & What Each Tool Did

### 🗄️ SQL (SQL Server)
- Built RFM scoring using window functions (`NTILE`), CTEs, and JOINs
- Created a reusable **View** for segment logic
- Answered 9 business questions using aggregations and CASE statements
- 📂 See: `SQL/`

### 🐍 Python (Pandas, Matplotlib, Seaborn)
- Cleaned data (handled nulls, duplicates)
- Cross-validated RFM segmentation independently using `qcut`
- Built visualizations for segment revenue, category trends, and monthly patterns
- 📂 See: `Python/`

### 📊 Power BI
- Built a **3-page interactive dashboard**: Executive, Operational, and Manager views
- Added drill-through filters, slicers, and region/segment breakdowns
- 📂 See: `PowerBi/`

### 📗 Excel
- Validated segment-wise revenue using **Pivot Tables**
- Used **VLOOKUP** to cross-check individual customer segments
- 📂 See: `Excel/`

---

## 📁 Repository Structure
```
├── SQL/                  → RFM analysis queries
├── Python/                → Data cleaning, EDA, RFM notebook
├── PowerBi/                → Dashboard screenshots
├── Excel/                  → Pivot Table validation & VLOOKUP demo
├── Data/                  → Cleaned datasets used in analysis
├── Screenshots/            → Key SQL output evidence
└── Documentation/          → Full project documentation (BRD, FRD, recommendations)
```

---

## 🖥️ Dashboard Preview
See `PowerBi/` folder for Executive Summary, Operational Analysis, and Manager Insights pages.

---

## ✅ Business Recommendations
1. Prioritize retention programs for Champions segment
2. Launch win-back campaigns for At-Risk customers
3. Cross-sell Electronics with Home & Kitchen/Sports
4. Maintain multi-channel and multi-payment support

---

## 👤 Author
Anmol Bhaskar
