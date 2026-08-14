SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME IN
(
    'Customers',
    'Products',
    'Orders',
    'Order_Lines',
    'Shipments',
    'Returns'
)
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

Customers
   │
   └── Orders
          │
          ├── Order_Lines ─── Products
          │        │
          │        └── Shipments
          │
          └── Returns