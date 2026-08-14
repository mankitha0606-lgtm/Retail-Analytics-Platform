-- Business KPI's : the core KPI numbers

SELECT
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,
    COUNT(DISTINCT ol.Product_ID) AS Total_Products,
    SUM(ol.Quantity) AS Total_Quantity,
    SUM(ol.Sales) AS Total_Sales,
    SUM(ol.Profit) AS Total_Profit,
    SUM(ol.Shipping_Cost) AS Total_Shipping_Cost
FROM Orders o
JOIN Order_Lines ol
    ON o.Order_ID = ol.Order_ID;
SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    CAST(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines;

-- Sales & Profit by Year : year-wise performance

SELECT
    YEAR(o.Order_Date) AS Order_Year,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    SUM(ol.Quantity) AS Total_Quantity,
    SUM(ol.Sales) AS Total_Sales,
    SUM(ol.Profit) AS Total_Profit,
    SUM(ol.Shipping_Cost) AS Total_Shipping_Cost,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Orders o
JOIN Order_Lines ol
    ON o.Order_ID = ol.Order_ID
GROUP BY YEAR(o.Order_Date)
ORDER BY Order_Year;

-- YoY Sales & Profit Growth : demonstrates CTE + LAG() + window functions + growth calculations
WITH yearly_sales AS
(
    SELECT
        YEAR(o.Order_Date) AS Order_Year,
        SUM(ol.Sales) AS Total_Sales,
        SUM(ol.Profit) AS Total_Profit
    FROM Orders o
    JOIN Order_Lines ol
        ON o.Order_ID = ol.Order_ID
    GROUP BY YEAR(o.Order_Date)
)
SELECT
    Order_Year,
    Total_Sales,
    Total_Profit,

    LAG(Total_Sales) OVER (
        ORDER BY Order_Year
    ) AS Previous_Year_Sales,

    CAST(
        (Total_Sales - LAG(Total_Sales) OVER (ORDER BY Order_Year))
        * 100.0 /
        NULLIF(LAG(Total_Sales) OVER (ORDER BY Order_Year), 0)
        AS DECIMAL(10,2)
    ) AS Sales_Growth_Percent,

    LAG(Total_Profit) OVER (
        ORDER BY Order_Year
    ) AS Previous_Year_Profit,

    CAST(
        (Total_Profit - LAG(Total_Profit) OVER (ORDER BY Order_Year))
        * 100.0 /
        NULLIF(LAG(Total_Profit) OVER (ORDER BY Order_Year), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Growth_Percent

FROM yearly_sales
ORDER BY Order_Year;

-- Region & Market Analysis : identify which regions and markets are driving sales and profit

SELECT
    o.Region,
    o.Market,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(SUM(ol.Shipping_Cost) AS DECIMAL(18,2)) AS Total_Shipping_Cost,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Orders o
JOIN Order_Lines ol
    ON o.Order_ID = ol.Order_ID
GROUP BY
    o.Region,
    o.Market
ORDER BY
    Total_Sales DESC;

-- Product Category & Subcategory : we'll identify: Best-selling category, Most profitable category, Highest-margin subcategory, Loss-making subcategories, Highest-volume products/categories

SELECT
    p.Category,
    p.Subcategory,
    COUNT(DISTINCT ol.Order_ID) AS Total_Orders,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(SUM(ol.Shipping_Cost) AS DECIMAL(18,2)) AS Total_Shipping_Cost,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Products p
    ON ol.Product_ID = p.Product_ID
GROUP BY
    p.Category,
    p.Subcategory
ORDER BY
    Total_Sales DESC;

-- Category-level performance : aggregate the subcategories into the three main categories

SELECT
    p.Category,
    COUNT(DISTINCT ol.Order_ID) AS Total_Orders,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(SUM(ol.Shipping_Cost) AS DECIMAL(18,2)) AS Total_Shipping_Cost,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Products p
    ON ol.Product_ID = p.Product_ID
GROUP BY
    p.Category
ORDER BY
    Total_Sales DESC;

-- Top 10 Products by Sales : identify the products actually driving revenue
SELECT TOP 10
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Products p
    ON ol.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory
ORDER BY
    Total_Sales DESC;

-- Top 10 Products by Profit : find the products that actually generate the most profit
SELECT TOP 10
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Products p
    ON ol.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory
ORDER BY
    Total_Profit DESC;

-- Loss-Making Products : identify the products that are actually losing money

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Products p
    ON ol.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory
HAVING SUM(ol.Profit) < 0
ORDER BY
    Total_Profit ASC;

-- Discount vs Profit Analysis : investigate whether high discounts are contributing to the losses

SELECT
    CASE
        WHEN Discount = 0 THEN '0%'
        WHEN Discount <= 0.10 THEN '1-10%'
        WHEN Discount <= 0.20 THEN '11-20%'
        WHEN Discount <= 0.30 THEN '21-30%'
        WHEN Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END AS Discount_Range,
    COUNT(*) AS Order_Lines,
    SUM(Quantity) AS Total_Quantity,
    CAST(SUM(Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales),0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines
GROUP BY
    CASE
        WHEN Discount = 0 THEN '0%'
        WHEN Discount <= 0.10 THEN '1-10%'
        WHEN Discount <= 0.20 THEN '11-20%'
        WHEN Discount <= 0.30 THEN '21-30%'
        WHEN Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END
ORDER BY
    MIN(Discount);

-- Discount vs Category : Which category is suffering the most from high discounts

SELECT
    p.Category,
    CASE
        WHEN ol.Discount = 0 THEN '0%'
        WHEN ol.Discount <= 0.10 THEN '1-10%'
        WHEN ol.Discount <= 0.20 THEN '11-20%'
        WHEN ol.Discount <= 0.30 THEN '21-30%'
        WHEN ol.Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END AS Discount_Range,
    COUNT(*) AS Order_Lines,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales),0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Products p
    ON ol.Product_ID = p.Product_ID
GROUP BY
    p.Category,
    CASE
        WHEN ol.Discount = 0 THEN '0%'
        WHEN ol.Discount <= 0.10 THEN '1-10%'
        WHEN ol.Discount <= 0.20 THEN '11-20%'
        WHEN ol.Discount <= 0.30 THEN '21-30%'
        WHEN ol.Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END
ORDER BY
    p.Category,
    MIN(ol.Discount);

-- Customer Analysis

    --Customer Segment Performance : Which customer segment generates the most sales and profit
    SELECT
    c.Segment,
    COUNT(DISTINCT o.Customer_ID) AS Unique_Customers,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
        ) AS Profit_Margin_Percent
    FROM Orders o
    JOIN Customers c
        ON o.Customer_ID = c.Customer_ID
    JOIN Order_Lines ol
        ON o.Order_ID = ol.Order_ID
    GROUP BY
        c.Segment
    ORDER BY
        Total_Sales DESC;

    --Top 10 Customers by Profit : identify most valuable individual customers
    SELECT TOP 10
        c.Customer_ID,
        c.Customer_Name,
        c.Segment,
        COUNT(DISTINCT o.Order_ID) AS Total_Orders,
        SUM(ol.Quantity) AS Total_Quantity,
        CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
        CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
        CAST(
            SUM(ol.Profit) * 100.0 /
            NULLIF(SUM(ol.Sales), 0)
            AS DECIMAL(10,2)
        ) AS Profit_Margin_Percent
    FROM Customers c
    JOIN Orders o
        ON c.Customer_ID = o.Customer_ID
    JOIN Order_Lines ol
        ON o.Order_ID = ol.Order_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name,
        c.Segment
    ORDER BY
        Total_Profit DESC;
    
    -- Customer Sales vs Profit : identify customers who generate high sales but relatively low profit
    SELECT TOP 10
        c.Customer_ID,
        c.Customer_Name,
        c.Segment,
        COUNT(DISTINCT o.Order_ID) AS Total_Orders,
        CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
        CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
        CAST(
            SUM(ol.Profit) * 100.0 /
            NULLIF(SUM(ol.Sales), 0)
            AS DECIMAL(10,2)
        ) AS Profit_Margin_Percent
    FROM Customers c
    JOIN Orders o
        ON c.Customer_ID = o.Customer_ID
    JOIN Order_Lines ol
        ON o.Order_ID = ol.Order_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name,
        c.Segment
    ORDER BY
        Total_Sales DESC;

    -- Customer Profitability Risk : identify all customers who are generating losses, then quantify the problem
    SELECT
        COUNT(*) AS Loss_Making_Customers,
        CAST(SUM(Total_Sales) AS DECIMAL(18,2)) AS Sales_From_Loss_Customers,
        CAST(SUM(Total_Profit) AS DECIMAL(18,2)) AS Total_Loss
    FROM
    (
        SELECT
            c.Customer_ID,
            SUM(ol.Sales) AS Total_Sales,
            SUM(ol.Profit) AS Total_Profit
        FROM Customers c
        JOIN Orders o
            ON c.Customer_ID = o.Customer_ID
        JOIN Order_Lines ol
            ON o.Order_ID = ol.Order_ID
        GROUP BY
            c.Customer_ID
        HAVING SUM(ol.Profit) < 0
    ) AS Loss_Customers;

-- Shipping Analysis : investigate whether shipping mode and shipping costs are affecting profitability

SELECT
    s.Ship_Mode,
    COUNT(DISTINCT s.Shipment_ID) AS Total_Shipments,
    COUNT(DISTINCT ol.Order_ID) AS Total_Orders,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Shipping_Cost) AS DECIMAL(18,2)) AS Total_Shipping_Cost,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Shipping_Cost) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Shipping_Cost_Percent,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Shipments s
    ON ol.Shipment_ID = s.Shipment_ID
GROUP BY
    s.Ship_Mode
ORDER BY
    Total_Sales DESC;

-- Shipping Cost by Region : ind out where shipping is most expensive geographically
SELECT
    o.Region,
    o.Market,
    COUNT(DISTINCT s.Shipment_ID) AS Total_Shipments,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Shipping_Cost) AS DECIMAL(18,2)) AS Total_Shipping_Cost,
    CAST(
        SUM(ol.Shipping_Cost) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Shipping_Cost_Percent,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Orders o
JOIN Order_Lines ol
    ON o.Order_ID = ol.Order_ID
JOIN Shipments s
    ON ol.Shipment_ID = s.Shipment_ID
GROUP BY
    o.Region,
    o.Market
ORDER BY
    Shipping_Cost_Percent DESC;

-- Regional Loss Analysis : identify loss-making regions and quantify their financial impact
SELECT
    o.Region,
    o.Market,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Shipping_Cost) AS DECIMAL(18,2)) AS Total_Shipping_Cost,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Orders o
JOIN Order_Lines ol
    ON o.Order_ID = ol.Order_ID
GROUP BY
    o.Region,
    o.Market
HAVING SUM(ol.Profit) < 0
ORDER BY
    Total_Profit ASC;

-- Find what's causing the regional losses : the products responsible for the losses
SELECT TOP 15
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Shipping_Cost) AS DECIMAL(18,2)) AS Total_Shipping_Cost,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Orders o
JOIN Order_Lines ol
    ON o.Order_ID = ol.Order_ID
JOIN Products p
    ON ol.Product_ID = p.Product_ID
WHERE o.Region = 'Western Asia'
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory
HAVING SUM(ol.Profit) < 0
ORDER BY
    Total_Profit ASC;
    
-- Investigate Discounts : the discount levels for Western Asia

SELECT
    o.Region,
    CASE
        WHEN ol.Discount = 0 THEN '0%'
        WHEN ol.Discount <= 0.10 THEN '1-10%'
        WHEN ol.Discount <= 0.20 THEN '11-20%'
        WHEN ol.Discount <= 0.30 THEN '21-30%'
        WHEN ol.Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END AS Discount_Range,
    COUNT(*) AS Order_Lines,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Orders o
JOIN Order_Lines ol
    ON o.Order_ID = ol.Order_ID
WHERE o.Region = 'Western Asia'
GROUP BY
    o.Region,
    CASE
        WHEN ol.Discount = 0 THEN '0%'
        WHEN ol.Discount <= 0.10 THEN '1-10%'
        WHEN ol.Discount <= 0.20 THEN '11-20%'
        WHEN ol.Discount <= 0.30 THEN '21-30%'
        WHEN ol.Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END
ORDER BY
    MIN(ol.Discount);
    
-- Quantify the discount impact : determine how much profit is being lost specifically because of 40%+ discounts across the entire business, not just Western Asia
SELECT
    CASE
        WHEN ol.Discount = 0 THEN '0%'
        WHEN ol.Discount <= 0.10 THEN '1-10%'
        WHEN ol.Discount <= 0.20 THEN '11-20%'
        WHEN ol.Discount <= 0.30 THEN '21-30%'
        WHEN ol.Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END AS Discount_Range,
    COUNT(*) AS Order_Lines,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
GROUP BY
    CASE
        WHEN ol.Discount = 0 THEN '0%'
        WHEN ol.Discount <= 0.10 THEN '1-10%'
        WHEN ol.Discount <= 0.20 THEN '11-20%'
        WHEN ol.Discount <= 0.30 THEN '21-30%'
        WHEN ol.Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END
ORDER BY
    MIN(ol.Discount);

-- Discount × Category : Which categories are being hurt most by high discounts
SELECT
    p.Category,
    CASE
        WHEN ol.Discount = 0 THEN '0%'
        WHEN ol.Discount <= 0.10 THEN '1-10%'
        WHEN ol.Discount <= 0.20 THEN '11-20%'
        WHEN ol.Discount <= 0.30 THEN '21-30%'
        WHEN ol.Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END AS Discount_Range,
    COUNT(*) AS Order_Lines,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Products p
    ON ol.Product_ID = p.Product_ID
GROUP BY
    p.Category,
    CASE
        WHEN ol.Discount = 0 THEN '0%'
        WHEN ol.Discount <= 0.10 THEN '1-10%'
        WHEN ol.Discount <= 0.20 THEN '11-20%'
        WHEN ol.Discount <= 0.30 THEN '21-30%'
        WHEN ol.Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END
ORDER BY
    p.Category,
    MIN(ol.Discount);

-- Find the exact subcategories causing these losses
SELECT
    p.Category,
    p.Subcategory,
    COUNT(*) AS Order_Lines,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Products p
    ON ol.Product_ID = p.Product_ID
WHERE ol.Discount > 0.40
GROUP BY
    p.Category,
    p.Subcategory
ORDER BY
    Total_Profit ASC;

-- High Sales + Low/Negative Profit Products : Which products generate significant revenue but fail to generate sufficient profit

SELECT TOP 20
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales),0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Products p
    ON ol.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory
HAVING SUM(ol.Sales) > 10000
ORDER BY
    Total_Profit ASC;
    
-- High-Value Products : Which products are the strongest profit generators

SELECT TOP 20
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory,
    SUM(ol.Quantity) AS Total_Quantity,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales),0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Order_Lines ol
JOIN Products p
    ON ol.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Subcategory
ORDER BY
    Total_Profit DESC;

-- Customer Segmentation — Profitability : customer profitability classification
WITH Customer_Performance AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        c.Segment,

        SUM(ol.Sales) AS Total_Sales,
        SUM(ol.Profit) AS Total_Profit
    FROM Customers c
    JOIN Orders o
        ON c.Customer_ID = o.Customer_ID
    JOIN Order_Lines ol
        ON o.Order_ID = ol.Order_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name,
        c.Segment
)
SELECT
    CASE
        WHEN Total_Profit < 0 THEN 'Loss Making'
        WHEN Total_Profit < 500 THEN 'Low Profit'
        WHEN Total_Profit < 2000 THEN 'Medium Profit'
        ELSE 'High Profit'
    END AS Customer_Profitability,
    COUNT(*) AS Customers,
    CAST(SUM(Total_Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(Total_Profit) AS DECIMAL(18,2)) AS Total_Profit
FROM Customer_Performance
GROUP BY
    CASE
        WHEN Total_Profit < 0 THEN 'Loss Making'
        WHEN Total_Profit < 500 THEN 'Low Profit'
        WHEN Total_Profit < 2000 THEN 'Medium Profit'
        ELSE 'High Profit'
    END
ORDER BY
    Total_Profit DESC;

-- Final Risk Analysis — Where Losses Concentrate : Where do losses occur when we simultaneously consider geography, product category and discount level

SELECT
    o.Region,
    p.Category,
    CASE
        WHEN ol.Discount = 0 THEN '0%'
        WHEN ol.Discount <= 0.10 THEN '1-10%'
        WHEN ol.Discount <= 0.20 THEN '11-20%'
        WHEN ol.Discount <= 0.30 THEN '21-30%'
        WHEN ol.Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END AS Discount_Range,
    COUNT(*) AS Order_Lines,
    CAST(SUM(ol.Sales) AS DECIMAL(18,2)) AS Total_Sales,
    CAST(SUM(ol.Profit) AS DECIMAL(18,2)) AS Total_Profit,
    CAST(
        SUM(ol.Profit) * 100.0 /
        NULLIF(SUM(ol.Sales),0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percent
FROM Orders o
JOIN Order_Lines ol
    ON o.Order_ID = ol.Order_ID
JOIN Products p
    ON ol.Product_ID = p.Product_ID
GROUP BY
    o.Region,
    p.Category,
    CASE
        WHEN ol.Discount = 0 THEN '0%'
        WHEN ol.Discount <= 0.10 THEN '1-10%'
        WHEN ol.Discount <= 0.20 THEN '11-20%'
        WHEN ol.Discount <= 0.30 THEN '21-30%'
        WHEN ol.Discount <= 0.40 THEN '31-40%'
        ELSE '40%+'
    END
HAVING SUM(ol.Profit) < 0
ORDER BY
    Total_Profit ASC;