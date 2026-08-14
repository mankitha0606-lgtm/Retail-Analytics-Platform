# 📊 Retail Sales & Profitability Analytics

An end-to-end **Data Analytics + Machine Learning project** that analyzes retail sales, profitability, discounts, products, customers, regions, and shipping performance, and uses Machine Learning to predict potentially loss-making transactions.

---

## 📌 Project Overview

This project transforms retail transaction data into actionable business insights using:

- **SQL Server** for data preparation and business analysis
- **Python** for Exploratory Data Analysis
- **Power BI** for interactive dashboards
- **Scikit-learn** for Machine Learning
- **Streamlit** for model deployment

The project focuses on understanding **what drives profitability** and building a predictive solution to identify transactions that are likely to result in losses.

---

## 🎯 Business Problem

The business generates significant sales, but high sales do not always translate into high profitability.

The key questions addressed in this project are:

- Which products and categories generate the highest profit?
- How does discounting affect profitability?
- Which regions are performing poorly?
- Which customer segments are most profitable?
- How does shipping affect profitability?
- Which products have high sales but poor profitability?
- Can Machine Learning identify potentially loss-making transactions?

---

## 🎯 Project Objectives

1. Clean and prepare retail transaction data.
2. Perform business analysis using SQL Server.
3. Build an interactive Power BI dashboard.
4. Perform detailed EDA using Python.
5. Identify major profitability drivers.
6. Build a Machine Learning model for loss prediction.
7. Optimize the classification threshold based on the business objective.
8. Deploy the ML model using Streamlit.
9. Convert analytical findings into actionable business recommendations.

---

# 🏗️ Project Architecture

```text
                    RETAIL DATA
                         │
                         ▼
                 Excel / CSV Data
                         │
                         ▼
                    SQL SERVER
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
       Data Preparation       SQL Business Analysis
              │                     │
              └──────────┬──────────┘
                         ▼
                    POWER BI
                  Interactive Dashboard
                         │
                         ▼
                      PYTHON
                         │
                  Exploratory Analysis
                         │
                         ▼
                Machine Learning
                         │
                Gradient Boosting
                         │
                         ▼
                 Loss Probability
                         │
                         ▼
                    STREAMLIT
                  Model Deployment
