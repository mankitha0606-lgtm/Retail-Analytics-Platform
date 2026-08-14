-- Verifying Customers_Staging table

SELECT COUNT(*) AS Rows
FROM Customers_Staging;

SELECT TOP 10 *
FROM Customers_Staging;

SELECT
    [Customer ID],
    COUNT(*) AS Duplicate_Count
FROM Customers_Staging
GROUP BY [Customer ID]
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS Null_Customer_IDs
FROM Customers_Staging
WHERE [Customer ID] IS NULL
   OR LTRIM(RTRIM([Customer ID])) = '';

-- Data importing into actual Customers table

INSERT INTO Customers
(
    Customer_ID,
    Customer_Name,
    Segment
)
SELECT
    [Customer ID],
    [Customer Name],
    [Segment]
FROM Customers_Staging;



SELECT COUNT(*) AS Customer_Rows
FROM Customers;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Customers;


-- Verifying Products_Staging table

SELECT COUNT(*) AS Product_Rows
FROM Products_Staging;

SELECT TOP 10 *
FROM Products_Staging;

SELECT
    [Product ID],
    COUNT(*) AS Duplicate_Count
FROM Products_Staging
GROUP BY [Product ID]
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS Null_Product_IDs
FROM Products_Staging
WHERE [Product ID] IS NULL
   OR LTRIM(RTRIM([Product ID])) = '';

-- Data importing into actual Products table

INSERT INTO Products
(
    Product_ID,
    Product_Name,
    Category,
    Subcategory
)
SELECT
    [Product ID],
    [Product Name],
    [Category],
    [Sub_Category]
FROM Products_Staging;

SELECT
    COUNT(*) AS Total_Products,
    COUNT(DISTINCT Product_ID) AS Unique_Products
FROM Products;

SELECT TOP 10 *
FROM Products;


-- Verifying Orders_Staging table

SELECT COUNT(*) AS Order_Rows
FROM Orders_Staging;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Order_ID) AS Unique_Orders,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM Orders_Staging;

SELECT
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Null_Order_IDs,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_Customer_IDs
FROM Orders_Staging;

SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM Orders_Staging
GROUP BY Order_ID
HAVING COUNT(*) > 1;

SELECT
    MIN(Order_Date) AS Earliest_Order_Date,
    MAX(Order_Date) AS Latest_Order_Date
FROM Orders_Staging;

SELECT
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Null_Order_Date,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS Null_State,
    SUM(CASE WHEN Postal_Code IS NULL THEN 1 ELSE 0 END) AS Null_Postal_Code,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Null_Country,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Null_Region,
    SUM(CASE WHEN Market IS NULL THEN 1 ELSE 0 END) AS Null_Market
FROM Orders_Staging;

-- Data importing into actual Orders table

INSERT INTO Orders
(
    Order_ID,
    Order_Date,
    Customer_ID,
    City,
    State,
    Postal_Code,
    Country,
    Region,
    Market
)
SELECT
    Order_ID,
    Order_Date,
    Customer_ID,
    City,
    State,
    Postal_Code,
    Country,
    Region,
    Market
FROM Orders_Staging;

SELECT
    COUNT(*) AS Total_orders,
    COUNT(DISTINCT Order_ID) AS Unique_orders
FROM Orders;

SELECT TOP 10 *
FROM Orders;

SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;


-- Verifying Shipments_Staging table

SELECT COUNT(*) AS Shipment_Rows
FROM Shipments_Staging;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Shipment_ID) AS Unique_Shipments,
    COUNT(DISTINCT Order_ID) AS Unique_Orders
FROM Shipments_Staging;

SELECT
    Shipment_ID,
    COUNT(*) AS Duplicate_Count
FROM Shipments_Staging
GROUP BY Shipment_ID
HAVING COUNT(*) > 1;

SELECT
    SUM(CASE WHEN Shipment_ID IS NULL THEN 1 ELSE 0 END) AS Null_Shipment_ID,
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN Order_Priority IS NULL THEN 1 ELSE 0 END) AS Null_Order_Priority,
    SUM(CASE WHEN Ship_Date IS NULL THEN 1 ELSE 0 END) AS Null_Ship_Date,
    SUM(CASE WHEN Ship_Mode IS NULL THEN 1 ELSE 0 END) AS Null_Ship_Mode
FROM Shipments_Staging;

-- Data importing into actual Shipments table

INSERT INTO Shipments
(
    Shipment_ID,
    Order_ID,
    Order_Priority,
    Ship_Date,
    Ship_Mode
)
SELECT
    Shipment_ID,
    Order_ID,
    Order_Priority,
    Ship_Date,
    Ship_Mode
FROM Shipments_Staging;



SELECT
    COUNT(*) AS Total_Shipments,
    COUNT(DISTINCT Shipment_ID) AS Unique_Shipments,
    COUNT(DISTINCT Order_ID) AS Unique_Orders
FROM Shipments;

SELECT TOP 10 *
FROM Shipments;

SELECT COUNT(*) AS Orphan_Shipments
FROM Shipments s
LEFT JOIN Orders o
    ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


-- Verifying Order_Line_Staging table

SELECT COUNT(*) AS Order_Line_Rows
FROM Order_Lines_Staging;

SELECT TOP 10 *
FROM Order_Lines_Staging;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT [Order_Line_ID]) AS Unique_Order_Lines,
    COUNT(DISTINCT [Order_ID]) AS Unique_Orders,
    COUNT(DISTINCT [Shipment_ID]) AS Unique_Shipments
FROM Order_Lines_Staging;

SELECT
    SUM(CASE WHEN [Order_Line_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Order_Line_ID,
    SUM(CASE WHEN [Order_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN [Shipment_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Shipment_ID,
    SUM(CASE WHEN [Product_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN [Quantity] IS NULL THEN 1 ELSE 0 END) AS Null_Quantity,
    SUM(CASE WHEN [Sales] IS NULL THEN 1 ELSE 0 END) AS Null_Sales,
    SUM(CASE WHEN [Shipping_Cost] IS NULL THEN 1 ELSE 0 END) AS Null_Shipping_Cost,
    SUM(CASE WHEN [Profit] IS NULL THEN 1 ELSE 0 END) AS Null_Profit,
    SUM(CASE WHEN [Discount] IS NULL THEN 1 ELSE 0 END) AS Null_Discount
FROM Order_Lines_Staging;

SELECT
    [Order_Line_ID],
    COUNT(*) AS Duplicate_Count
FROM Order_Lines_Staging
GROUP BY [Order_Line_ID]
HAVING COUNT(*) > 1;

-- Data importing into actual Order_Lines  table

INSERT INTO Order_Lines
(
    [Order_Line_ID],
    [Order_ID],
    [Shipment_ID],
    [Product_ID],
    [Quantity],
    [Sales],
    [Shipping_Cost],
    [Profit],
    [Discount]
)
SELECT
    [Order_Line_ID],
    [Order_ID],
    [Shipment_ID],
    [Product_ID],
    [Quantity],
    [Sales],
    [Shipping_Cost],
    [Profit],
    [Discount]
FROM Order_Lines_Staging;

SELECT COUNT(*) AS Order_Line_Rows
FROM Order_Lines;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT [Order_Line_ID]) AS Unique_Order_Lines,
    COUNT(DISTINCT [Order_ID]) AS Unique_Orders,
    COUNT(DISTINCT [Shipment_ID]) AS Unique_Shipments,
    COUNT(DISTINCT [Product_ID]) AS Unique_Products
FROM Order_Lines;

SELECT
    SUM(CASE WHEN [Order_Line_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Order_Line_ID,
    SUM(CASE WHEN [Order_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN [Shipment_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Shipment_ID,
    SUM(CASE WHEN [Product_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN [Quantity] IS NULL THEN 1 ELSE 0 END) AS Null_Quantity,
    SUM(CASE WHEN [Sales] IS NULL THEN 1 ELSE 0 END) AS Null_Sales,
    SUM(CASE WHEN [Shipping_Cost] IS NULL THEN 1 ELSE 0 END) AS Null_Shipping_Cost,
    SUM(CASE WHEN [Profit] IS NULL THEN 1 ELSE 0 END) AS Null_Profit,
    SUM(CASE WHEN [Discount] IS NULL THEN 1 ELSE 0 END) AS Null_Discount
FROM Order_Lines;


-- Order IDs without matching Orders
SELECT COUNT(*) AS Missing_Orders
FROM Order_Lines ol
LEFT JOIN Orders o
    ON ol.[Order_ID] = o.[Order_ID]
WHERE o.[Order_ID] IS NULL;

-- Shipment IDs without matching Shipments
SELECT COUNT(*) AS Missing_Shipments
FROM Order_Lines ol
LEFT JOIN Shipments s
    ON ol.[Shipment_ID] = s.[Shipment_ID]
WHERE s.[Shipment_ID] IS NULL;

-- Product IDs without matching Products
SELECT COUNT(*) AS Missing_Products
FROM Order_Lines ol
LEFT JOIN Products p
    ON ol.[Product_ID] = p.[Product_ID]
WHERE p.[Product_ID] IS NULL;


-- Verifying Order_Line_Staging table
SELECT COUNT(*) AS Return_Rows
FROM Returns_Staging;

SELECT TOP 10 *
FROM Returns_Staging;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT [Order_ID]) AS Unique_Orders
FROM Returns_Staging;

SELECT
    SUM(CASE WHEN [Order_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN [Returned] IS NULL THEN 1 ELSE 0 END) AS Null_Returned,
    SUM(CASE WHEN [Region] IS NULL THEN 1 ELSE 0 END) AS Null_Region
FROM Returns_Staging;

SELECT COUNT(*) AS Missing_Orders
FROM Returns_Staging r
LEFT JOIN Orders o
    ON r.[Order_ID] = o.[Order_ID]
WHERE o.[Order_ID] IS NULL;

SELECT *
FROM Returns_Staging r
LEFT JOIN Orders o
    ON r.[Order_ID] = o.[Order_ID]
WHERE o.[Order_ID] IS NULL;

SELECT
    r.[Order_ID],
    LEN(r.[Order_ID]) AS Return_ID_Length,
    '[' + r.[Order_ID] + ']' AS Return_ID_Check
FROM Returns_Staging r
LEFT JOIN Orders o
    ON r.[Order_ID] = o.[Order_ID]
WHERE o.[Order_ID] IS NULL;


-- Data importing into actual Order_Lines  table

INSERT INTO Returns
(
    [Order_ID],
    [Returned],
    [Region]
)
SELECT
    r.[Order_ID],
    r.[Returned],
    r.[Region]
FROM Returns_Staging r
WHERE EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.[Order_ID] = r.[Order_ID]
);

SELECT
    COUNT(*) AS Return_Rows,
    COUNT(DISTINCT [Order_ID]) AS Unique_Return_Orders
FROM Returns;

SELECT COUNT(*) AS Missing_Orders
FROM Returns r
LEFT JOIN Orders o
    ON r.[Order_ID] = o.[Order_ID]
WHERE o.[Order_ID] IS NULL;

SELECT
    SUM(CASE WHEN [Order_ID] IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN [Returned] IS NULL THEN 1 ELSE 0 END) AS Null_Returned,
    SUM(CASE WHEN [Region] IS NULL THEN 1 ELSE 0 END) AS Null_Region
FROM Returns;



-- Droping the Staging tables

DROP TABLE Customers_Staging

DROP TABLE Products_Staging

DROP TABLE Orders_Staging

DROP TABLE Order_Lines_Staging

DROP TABLE Shipments_Staging

DROP TABLE Returns_Staging