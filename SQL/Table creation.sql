CREATE TABLE Customers
(
    Customer_ID VARCHAR(50) NOT NULL,
    Customer_Name VARCHAR(150) NOT NULL,
    Segment VARCHAR(50),

    CONSTRAINT PK_Customers
        PRIMARY KEY (Customer_ID)
);
GO

CREATE TABLE Products
(
    Product_ID VARCHAR(50) NOT NULL,
    Product_Name VARCHAR(255) NOT NULL,
    Category VARCHAR(100),
    Subcategory VARCHAR(100),

    CONSTRAINT PK_Products
        PRIMARY KEY (Product_ID)
);
GO

CREATE TABLE Orders
(
    Order_ID VARCHAR(50) NOT NULL,
    Order_Date DATE NOT NULL,
    Customer_ID VARCHAR(50) NOT NULL,
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_Code VARCHAR(50),
    Country VARCHAR(100),
    Region VARCHAR(100),
    Market VARCHAR(100),

    CONSTRAINT PK_Orders
        PRIMARY KEY (Order_ID),

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID)
);
GO

CREATE TABLE Shipments
(
    Shipment_ID INT NOT NULL,
    Order_ID VARCHAR(50) NOT NULL,
    Order_Priority VARCHAR(50),
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),

    CONSTRAINT PK_Shipments
        PRIMARY KEY (Shipment_ID),

    CONSTRAINT FK_Shipments_Orders
        FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
);
GO

CREATE TABLE Order_Lines
(
    Order_Line_ID INT NOT NULL,
    Order_ID VARCHAR(50) NOT NULL,
    Shipment_ID INT NOT NULL,
    Product_ID VARCHAR(50) NOT NULL,
    Quantity INT,
    Sales DECIMAL(18, 2),
    Shipping_Cost DECIMAL(18, 2),
    Profit DECIMAL(18, 2),

    CONSTRAINT PK_Order_Lines
        PRIMARY KEY (Order_Line_ID),

    CONSTRAINT FK_Order_Lines_Orders
        FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID),

    CONSTRAINT FK_Order_Lines_Shipments
        FOREIGN KEY (Shipment_ID)
        REFERENCES Shipments(Shipment_ID),

    CONSTRAINT FK_Order_Lines_Products
        FOREIGN KEY (Product_ID)
        REFERENCES Products(Product_ID)
);
GO

CREATE TABLE Returns
(
    Order_ID VARCHAR(50) NOT NULL,
    Returned VARCHAR(50),
    Region VARCHAR(50),

    CONSTRAINT FK_Returns_Orders
        FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
);
GO

