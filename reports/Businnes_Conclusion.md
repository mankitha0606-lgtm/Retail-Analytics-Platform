# Final Business Insights 

## Overall Performance
- **Total Sales:** $12.63M
- **Total Profit:** $1.47M
- **Profit Margin:** 11.60%
- **Orders:** 26K
- **Customers:** 17K
- **Products:** 3,788

## Key Business Findings

- **Discounting is the major profitability risk.**
  - Discount and Profit correlation: **-0.32**
  - Profitability turns negative at approximately **20% discount**.
  - Higher discounts lead to increasingly severe losses.

- **Technology is the strongest category.**
  - Profit: **$663.8K**
  - Margin: **13.99%**
  - Furniture has much lower profitability at **6.94% margin**.

- **Regional losses require attention.**
  - Western Asia: **-$53.9K**
  - Western Africa: **-$50.4K**
  - Central Asia: **-$7.3K**
  - High discounts contribute significantly to these regional losses.

- **Product profitability varies significantly.**
  - **1,371 Strong Products**
  - **523 Problem Products**
  - **523 Hidden Opportunities**
  - **1,371 Weak Products**

- **Consumer** generates the highest total profit, while **Home Office** has the highest profit margin.

- **Standard Class** has the lowest shipping-cost percentage, while **Same Day** has the highest.

## Machine Learning Outcome

The final model is a **Gradient Boosting Classifier** with a **0.40 threshold**.

| Metric | Result |
|---|---:|
| Accuracy | **92.77%** |
| Precision | **86.61%** |
| Recall | **83.30%** |
| F1 Score | **84.92%** |

The model correctly identifies **2,090 of 2,509 loss-making transactions**.

**Discount** was overwhelmingly the most important predictive feature, confirming the SQL and EDA findings.

## Recommendations

1. Control discounts above **20%**.
2. Investigate **high-sales, low-profit products**.
3. Improve Furniture profitability.
4. Review loss-making regions and their discount practices.
5. Use the ML model to flag **high-risk loss-making transactions**.
6. Track **profit and profit margin**, not sales alone.

## Conclusion

The project shows that **discount strategy, product economics, and regional performance are the major factors affecting profitability**. Combining SQL, Power BI, EDA, and Machine Learning provides a practical framework for identifying and preventing financial losses.