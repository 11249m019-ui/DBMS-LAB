-- EXPERIMENT 07: CREATION OF VIEWS, SEQUENCES, INDEXES AND SAVEPOINTS

-- Query 1: Create and Select Database
CREATE DATABASE WarehouseDB;
USE WarehouseDB;

-- Query 2: Create Product Table
CREATE TABLE Product (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(60) NOT NULL,
    Category VARCHAR(30) NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,
    Stock_Qty INT NOT NULL,
    Warehouse VARCHAR(30) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1001;

-- Query 3: Insert Eight Sample Products
INSERT INTO Product
(Product_Name,Category,Unit_Price,Stock_Qty,Warehouse)
VALUES
('Keyboard','Electronics',800,40,'Chennai'),
('Mouse','Electronics',450,12,'Chennai'),
('Office Chair','Furniture',4500,8,'Bengaluru'),
('Desk','Furniture',7200,15,'Chennai'),
('Notebook','Stationery',60,100,'Hyderabad'),
('Pen Pack','Stationery',120,25,'Hyderabad'),
('Monitor','Electronics',12500,6,'Bengaluru'),
('Printer','Electronics',9500,4,'Chennai');

-- Query 4: Create Product View
CREATE VIEW vw_product_catalog AS
SELECT Product_ID,Product_Name,Category,Unit_Price
FROM Product;

-- Query 5: Retrieve Data From View
SELECT * FROM vw_product_catalog
ORDER BY Product_ID;

-- Query 6: Create Low-Stock View
CREATE VIEW vw_low_stock AS
SELECT Product_ID,Product_Name,Stock_Qty
FROM Product
WHERE Stock_Qty < 10;

-- Query 7: Display Low-Stock Products
SELECT * FROM vw_low_stock
ORDER BY Product_ID;

-- Query 8: Replace View Definition
CREATE OR REPLACE VIEW vw_low_stock AS
SELECT Product_ID,Product_Name,Category,Stock_Qty
FROM Product
WHERE Stock_Qty <= 12;

-- Query 9: Generate Next Automatic ID
INSERT INTO Product
(Product_Name,Category,Unit_Price,Stock_Qty,Warehouse)
VALUES
('Webcam','Electronics',2200,18,'Chennai');

SELECT LAST_INSERT_ID() AS New_Product_ID;

-- Query 10: Create Index
CREATE INDEX idx_product_category
ON Product(Category);

-- Query 11: Inspect Indexes
SHOW INDEX FROM Product;

-- Query 12: Inspect Indexed Query Plan
EXPLAIN SELECT * FROM Product
WHERE Category='Electronics';

-- Query 13: Create and Use Savepoint
START TRANSACTION;

UPDATE Product
SET Stock_Qty=Stock_Qty-5
WHERE Product_ID=1001;

SAVEPOINT sp_after_keyboard;

UPDATE Product
SET Stock_Qty=Stock_Qty-3
WHERE Product_ID=1002;

SELECT Product_ID,Stock_Qty
FROM Product
WHERE Product_ID IN (1001,1002)
ORDER BY Product_ID;

-- Query 14: Rollback to Savepoint
ROLLBACK TO SAVEPOINT sp_after_keyboard;

SELECT Product_ID,Stock_Qty
FROM Product
WHERE Product_ID IN (1001,1002)
ORDER BY Product_ID;

-- Query 15: Commit Retained Changes
COMMIT;

SELECT Product_ID,Stock_Qty
FROM Product
WHERE Product_ID IN (1001,1002)
ORDER BY Product_ID;

-- Query 16: Demonstrate Full Rollback
START TRANSACTION;

UPDATE Product
SET Stock_Qty=0
WHERE Product_ID=1003;

ROLLBACK;

SELECT Product_ID,Stock_Qty
FROM Product
WHERE Product_ID=1003;

-- Query 17: Drop Secondary Index
DROP INDEX idx_product_category ON Product;

SHOW INDEX FROM Product;

-- Verification Queries
SELECT COUNT(*) AS Total_Products FROM Product;

SELECT Product_ID,Stock_Qty
FROM Product
WHERE Product_ID IN (1001,1002,1003);

SHOW FULL TABLES IN WarehouseDB;
