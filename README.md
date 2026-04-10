# Project-Based Internship — Performance Analytics (Kimia Farma 2020–2023)

![Sales Dashboard Preview](./assets/assets/Screenshot 2026-04-10 152542.png)

## 1) Project Overview
This project delivers a unified analytical view of **business performance** for Kimia Farma across **2020–2023**. As part of the Big Data Analytics Final Task, the solution integrates raw tables into a curated dataset in BigQuery and publishes an **interactive dashboard** in Google Looker Studio to explore trends, branch performance, and profitability.

## 2) Objectives & Business Questions
**Objectives**
- Build a **single source of truth** (Tabel Analisa) for sales & operational analytics.
- Surface **trends, anomalies, and opportunities** to improve revenue, margin, and service quality.

**Key Questions**
- What are the **year‑over‑year revenue** trends (2020–2023)?
- Which **provinces and branches** outperform or lag behind in sales and transactions?
- Which branches possess high customer ratings but suffer from low transaction ratings?
- How is total profit distributed geographically across Indonesia?

## 3) Data Sources
The dataset consists of four raw tables:
- `kf_final_transaction` — transactions (price, discount, customer, date).
- `kf_product` — product master (name, category, master price).
- `kf_kantor_cabang` — branches (name, city, province, branch rating).
- `kf_inventory` — inventory stock data.

## 4) Architecture & Tech Stack
- **Data Platform**: Google Cloud Platform (GCP) / BigQuery  
- **Transformations**: StandardSQL (`CREATE OR REPLACE TABLE`, `LEFT JOIN`, `CASE WHEN`)  
- **BI / Visualization**: Google Looker Studio  

## 5) Data Modeling & Core Transformations
**Integrated Analysis Table (`tabel_analisa`)**
- Joined **transactions ↔ branches ↔ products** to form a comprehensive Data Mart containing mandatory fields (e.g., `transaction_id`, `branch_name`, `provinsi`, `rating_cabang`, etc.).
- Computed **nett_sales** = `actual_price × (1 − discount_percentage)`.
- Computed **persentase_gross_laba** using a mandatory tiered conditional logic based on actual price:
  - <= Rp 50.000 (10% profit)
  - \> Rp 50.000 - 100.000 (15% profit)
  - \> Rp 100.000 - 300.000 (20% profit)
  - \> Rp 300.000 - 500.000 (25% profit)
  - \> Rp 500.000 (30% profit)
- Computed **nett_profit** = `nett_sales × persentase_gross_laba`.

> SQL scripts are placed under `/sql` (e.g., `syntax_tabel_analisa.sql`).

## 6) Dashboard Features
Built in Google Looker Studio, fulfilling all mandatory challenge requirements:

**Global Filters**: Date Range, Province, Branch.

**Visualizations Included:**
- **Summary Dashboard / Snapshot Data**: KPI cards for Total Transactions, Total Revenue, and Total Profit.
- **Revenue per Year**: Year-over-Year (YoY) comparison of Kimia Farma's revenue.
- **Top 10 Total Transaction by Province**
- **Top 10 Total Nett Sales by Province**
- **Top 5 Branches Evaluation**: Highlighting branches with the highest branch rating but lowest transaction rating.
- **Indonesia's Geo Map**: Geographic distribution of total profit across all provinces.


## 7) How to Reproduce
1. **GCP Setup**: Create project `Rakamin-KF-Analytics` and dataset `kimia_farma` in BigQuery.  
2. **Load Source Tables**: Import `kf_final_transaction`, `kf_product`, `kf_kantor_cabang`, `kf_inventory` (CSV).  
3. **Run SQL**: Execute transformation script to build `tabel_analisa`.  
4. **Connect Looker Studio**: Point to the curated table `tabel_analisa`; add filter controls and configure visuals.  

## 8) Important Links
- **Looker Studio Dashboard**: [Insert Your Dashboard Link Here]
- **Video Presentation**: [Insert Your YouTube/GDrive Link Here]
- **Final Submission Deck (PPT)**: [Insert Your PPT Link Here]

## 9) Repository Structure
.
├── assets/ <br>
│   ├── Sales_Dashboard_preview.png <br>
│   └── Inventory_Dashboard_preview.png <br>
├── sql/ <br>
│   └── syntax_tabel_analisa.sql <br>
└── README.md
