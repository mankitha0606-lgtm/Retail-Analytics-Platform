# EDA Summary Report

## Dataset Overview
- **Rows:** 51,290
- **Columns:** 24
- **Products:** 3,788
- **Customers:** 17,415
- **Orders:** 25,728

## Data Quality
- No exact duplicate rows were found.
- **Postal Code:** 41,296 missing values (**80.51%**).
- No invalid Sales, Quantity, Discount, or Shipping Cost values were detected.
- Shipping duration ranges from **0–7 days**, with an average of approximately **3.97 days**.
- 20 transaction-level records were flagged because similar transaction details had different shipping costs.

## Key EDA Findings

### Sales & Profit
- Sales are highly right-skewed (**skewness: 8.14**).
- Profit is also right-skewed (**skewness: 4.16**).
- High-sales transactions do not always produce high profits.

### Discount Impact
- Discount and Profit have a negative correlation of **-0.32**.
- Profitability becomes negative at approximately **20% discount**.
- Discounts above 40% lead to severe negative margins across categories.

### Category Performance
- **Technology:** strongest category with approximately **$663.8K profit** and **13.99% margin**.
- **Office Supplies:** approximately **$518.6K profit** and **13.69% margin**.
- **Furniture:** approximately **$285.1K profit** and only **6.94% margin**.

### Regional Performance
Loss-making regions include:
- **Western Asia:** -$53.9K profit
- **Western Africa:** -$50.4K profit
- **Central Asia:** -$7.3K profit

High-discount transactions contribute significantly to regional losses.

### Customer Segments
- **Consumer:** highest total sales and profit.
- **Home Office:** highest profit margin at approximately **11.99%**.

### Product Analysis
Products were classified into:
- **1,371 Strong Products**
- **523 Problem Products**
- **523 Hidden Opportunities**
- **1,371 Weak Products**

Problem products generate relatively high sales but poor or negative profit, while Hidden Opportunities have lower sales but strong profitability.

## Major Business Insights
1. **Excessive discounting is a major profitability risk.**
2. **High sales do not guarantee high profit.**
3. **Technology is the strongest overall category.**
4. **Furniture requires profitability improvement.**
5. **Several regions are consistently loss-making.**
6. **Product-level profitability varies significantly.**
7. **Shipping cost should be evaluated alongside sales, discounts, and product mix.**

## Conclusion

EDA revealed that **discount strategy, product economics, and regional performance are the major areas affecting profitability**. These findings provide the foundation for the next stage of the project: **Machine Learning and predictive analytics**.