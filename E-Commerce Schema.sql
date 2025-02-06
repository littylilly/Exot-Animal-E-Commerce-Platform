DROP SCHEMA ecommerce;

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
	UserType ENUM('Admin', 'Customer') NOT NULL,
    First_Name VARCHAR(100) NOT NULL,
    Last_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Street TEXT,
    City TEXT,
    State TEXT, 
	Zipcode TEXT
);

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL
);

CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ContactPerson VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address TEXT,
    Website VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    PName VARCHAR(100) NOT NULL,
	PDescription TEXT,
	PType TEXT,
    CategoryID INT NOT NULL,
	SupplierID INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    Minimum_Stock INT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE ShippingAddresses (
    ShippingID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    Address TEXT NOT NULL,
    EstimatedDelivery DATETIME,
    TrackingNumber VARCHAR(50),
    IsDefault BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Discounts (
    DiscountID INT AUTO_INCREMENT PRIMARY KEY,
    DiscountType ENUM('Percentage', 'Flat') NOT NULL,
    DiscountValue DECIMAL(10, 2) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    ProductID INT,
    CategoryID INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    OrderNumber VARCHAR(50) UNIQUE NOT NULL,
    Order_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Total DECIMAL(10, 2) NOT NULL,
    PaymentID INT,
    ShippingID INT,
    DiscountID INT,
    OStatus ENUM('Pending', 'Shipped', 'Completed', 'Cancelled') NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ShippingID) REFERENCES ShippingAddresses(ShippingID),
    FOREIGN KEY (DiscountID) REFERENCES Discounts(DiscountID)
);

CREATE TABLE OrderDetails (
	OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
	OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    ProductPrice DECIMAL(10, 2) NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
	UserID INT NOT NULL,
    OrderID INT NOT NULL,
	Payment_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Payment_Method ENUM('Credit Card', 'Debit Card', 'Digital Payment') NOT NULL,
    Payment_Status ENUM('Pending', 'Completed', 'Failed') NOT NULL,
	FOREIGN KEY (UserID) REFERENCES Users(UserID),
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
	UserID INT NOT NULL,
    ProductID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    RComment TEXT,
    Review_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

SHOW TABLES;

# INSERTING CUSTOMERS & ADMINS
INSERT INTO Users (UserType, First_Name, Last_Name, Email, Phone, Street, City, State, Zipcode)
VALUES 
	('Customer', 'John', 'Doe', 'john.doe@example.com', '1234567890', '123 Main St', 'New York', 'NY', '10001'),
	('Customer', 'Gracie', 'Rehberg', 'drehberg1@student.gsu.edu', '4789733618', '1600 Pennsylvania', 'Washington', 'DC', '20500'),
	('Customer', 'Lilly', 'Parham', 'lparham2@student.gsu.edu', '6785487048', '6000 Universal Boulevard', 'Orlando', 'FL', '32819'),
	('Admin', 'Saeid', 'Motevali', 'smotevali1@gsu.edu', '4044132000', '33 Gilmer Street SE', 'Atlanta', 'GA', '30303'),
	('Customer', 'Bhavin', 'Patel', 'bpatel13@student.ksu.edu', '4784449466', '69 Rainbow Place', 'Atlanta', 'GA', '32879'),
    ('Customer', 'Selena', 'Gomez', 'selenagomez@superstar.com', '7709908989', '99 High Boulevard', 'Los Angeles', 'CA', '67678');

# SHOWS ALL USER INFO.
SELECT * 
FROM Users;

# SHOWS ALL USER INFO - FIRST & LAST NAME ONLY WITH USER TYPE
SELECT CONCAT(First_Name, ' ', Last_Name) AS FullName, UserType
FROM Users;

# INSERT COMPANY SUPPLIERS
INSERT INTO Suppliers (Name, ContactPerson, Email, Phone, Address, Website)
VALUES 
	('Fake Company', 'Liam Maxim', 'fakeemail@gmail.com', '1234567890', '1 Fake Street, Atlanta, GA 12345', 'www.fakewebsite.com'),
	('John Doe Supplies', 'John Doe Smith', 'johndoesupplies@gmail.com', '6795467878', '1 Happy Place Road, New York City, NY 12546', 'www.johndoesupplies.com'),
	('Wildlife Suppliers', 'Mike Smith', 'supplierms@example.com', '123456990', '123 Wildlife Avenue, Los Angeles, CA 30221', 'www.wildlifesuppliers.com'),
	('Luxury Pet Supplies', 'Macy Lee', 'macylee@luxurypetsupplies.com', '0123456789', '707 Pet Lane, Atlanta, GA 54892', 'www.luxurypetsupplies.com'),
	('Animal Superfoods', 'Jason Chin', 'jchin@animalsuperfoods.com', '4885678909', '555 Foxy Trail, Atlanta, GA 90012', 'www.animalsuperfoods.com'),
	('Exotic Petz', 'Shown Li', 'exoticpetz@yahoo.com', '6785409897', ' 6960 Orlado Way Drive, Miami, FL, 34509', 'www.ebay.com/exoticpetz');

# SHOW ALL SUPPLIERS & THEIR INFO.
SELECT * 
FROM Suppliers;

# INSERT SHOPPING ITEM CATEGORIES
INSERT INTO Categories (Category_Name)
VALUES 
	('Animals'),
	('Food'),
    ('Medicine'),
	('Toys'),
	('Bedding');

# SHOW ALL PRODUCT CATEGORIES
SELECT * 
FROM Categories;

# INSERT PRODUCT OPTIONS AVAILABLE FOR SALE
INSERT INTO Products (PName, PDescription, PType, CategoryID, SupplierID, Price, Quantity, Minimum_Stock)
VALUES 
	('Dog Food', 'High-protein dog food for active pets', 'Food', 5, 2, 30.00, 100, 10),
	('Cat Medicine', 'Vitamin supplements for cats', 'Medicine', 3, 3, 15.00, 50, 5),
	('Bird Toy', 'Colorful chewable toy for parrots', 'Toys', 4, 4, 10.00, 200, 20),
	('Hamster Bedding', 'Soft and eco-friendly bedding for small pets', 'Bedding', 4, 5, 8.00, 300, 30),
	('Lion', 'A large wild animal', 'Animals', 1, 6, 5000.00, 10, 1),
	('Bull', 'A large wild animal with horns, common in Spain', 'Animals', 1, 6, 2000.00, 6, 1),
	('Frog', 'Green jumping animal', 'Animals', 1, 6, 25.00, 300, 1),
	('Cat', 'Friendly feline', 'Animals', 1, 6, 150.00, 200, 1),
	('Polar Bear', 'A white, cold weather bear', 'Animals', 1, 6, 8000.00, 2, 1);

# SHOW ALL PRODUCTS
SELECT * 
FROM Products;

# USER 5 (BHAVIN PATEL) WANTS TO BUY A LION - HE STARTS THE ORDER
INSERT INTO Orders (UserID, OrderNumber, Total, PaymentID, ShippingID, DiscountID, OStatus)
VALUES (5, 'ORD10001', 5000.00, NULL, NULL, NULL, 'Pending');

# GIVES US THE ORDER ID
SELECT OrderID
FROM Orders
WHERE OrderNumber = 'ORD10001';

# BHAVIN PAYS FOR THE LION - ORDER # ORD10001
INSERT INTO Payments (UserID, OrderID, Payment_Date, Payment_Method, Payment_Status)
VALUES (5, (SELECT OrderID FROM Orders WHERE OrderNumber = 'ORD10001'), NOW(), 'Credit Card', 'Completed');

# GETS THE PAYMENT ID FOR THE TRANSACTION
SELECT PaymentID 
FROM Payments 
WHERE OrderID = (SELECT OrderID FROM Orders WHERE OrderNumber = 'ORD10001');

# INSERTS BHAVIN'S SHIPPING LOCATION
INSERT INTO ShippingAddresses (UserID, Address, EstimatedDelivery, TrackingNumber, IsDefault)
VALUES (5, '789 New Street, Los Angeles, CA, 90001', '2025-01-15', 'SHIP123456789', TRUE);

# GET THE SHIPPING ID
SELECT ShippingID 
FROM ShippingAddresses 
WHERE UserID = 5
AND Address = '789 New Street, Los Angeles, CA, 90001';

# $50 DISCOUNT ON ANY LION PURCHASES
INSERT INTO Discounts (DiscountType, DiscountValue, StartDate, EndDate, ProductID, CategoryID)
VALUES ('Flat', 50.00, NOW(), '2024-12-31', 6, 1);

# GET THE DISCOUNT ID
SELECT DiscountID 
FROM Discounts 
WHERE DiscountValue = 50.00 AND ProductID = 6;

# UPDATE THE ORDER WITH PAYMENT ID, SHIPPING ID, AND DISCOUNT ID
UPDATE Orders
SET PaymentID = (SELECT PaymentID FROM Payments WHERE OrderID = Orders.OrderID),
    ShippingID = (SELECT ShippingID FROM ShippingAddresses WHERE UserID = Orders.UserID),
    DiscountID = (SELECT DiscountID FROM Discounts WHERE ProductID = 6)
WHERE OrderNumber = 'ORD10001';

# ADD TO ORDER DETAILS WITH DISCOUNT APPLIED
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, ProductPrice, Subtotal)
VALUES (
    (SELECT OrderID FROM Orders WHERE OrderNumber = 'ORD10001'),
    6,              
    1,       
    5000.00,        
    5000.00 - (SELECT DiscountValue 
               FROM Discounts 
               WHERE ProductID = 6 AND CategoryID = 1) 
);

# UPDATE TOTAL IN ORDERS TO REFLECT DISCOUNT
UPDATE Orders
SET Total = Total - (SELECT DiscountValue 
                     FROM Discounts 
                     WHERE ProductID = 6 AND CategoryID = 1)
WHERE OrderNumber = 'ORD10001';

# SET ORDER STATUS TO SHIPPED AFTER PAYMENT IS COMPLETED
UPDATE Orders
SET OStatus = 'Shipped'
WHERE OrderNumber = 'ORD10001' 
AND PaymentID = (SELECT PaymentID FROM Payments WHERE OrderID = Orders.OrderID AND Payment_Status = 'Completed');

# DECREASE PRODUCT INVENTORY AFTER SHIPPING
UPDATE Products
SET Quantity = Quantity - (SELECT Quantity 
                           FROM OrderDetails 
                           WHERE ProductID = Products.ProductID AND OrderID = (SELECT OrderID FROM Orders WHERE OrderNumber = 'ORD10001'))
WHERE ProductID = 6; 

# VERIFY BHAVIN'S ORDER
SELECT * 
FROM Orders 
WHERE OrderNumber = 'ORD10001';

# VERIFY ORDER DETAILS
SELECT * 
FROM OrderDetails 
WHERE OrderID = (SELECT OrderID FROM Orders WHERE OrderNumber = 'ORD10001');

# VERIFY PAYMENT OF BHAVIN'S ORDER
SELECT * 
FROM Payments 
WHERE OrderID = (SELECT OrderID FROM Orders WHERE OrderNumber = 'ORD10001');

# VERIFY SHIPPING
SELECT * 
FROM ShippingAddresses 
WHERE ShippingID = (SELECT ShippingID FROM Orders WHERE OrderNumber = 'ORD10001');

# VERIFY UPDATED PRODUCT INVENTORY
SELECT * 
FROM Products
WHERE ProductID = 6;

# UPDATE FAKE COMPANY SUPPLIERS PHONE #
UPDATE Suppliers
SET Phone = '6789998212'
WHERE Name = 'Fake Company';

SELECT * 
FROM Suppliers;

DELETE FROM Products
WHERE PName = 'Hamster Bedding';

# LETS TAKE GRACIE SHOPPING
INSERT INTO Orders (UserID, OrderNumber, Total, OStatus)
VALUES (2, 'ORD10002', 0.00, 'Pending');

SELECT OrderID
FROM Orders
WHERE OrderNumber = 'ORD10002';

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, ProductPrice, Subtotal)
VALUES (2,                                
    (SELECT ProductID FROM Products WHERE PName = 'Dog Food'), 
    2,                                 
    (SELECT Price FROM Products WHERE PName = 'Dog Food'),  
    2 * (SELECT Price FROM Products WHERE PName = 'Dog Food') 
);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, ProductPrice, Subtotal)
VALUES (2,                        
    (SELECT ProductID FROM Products WHERE PName = 'Cat Medicine'), 
    1,                            
    (SELECT Price FROM Products WHERE PName = 'Cat Medicine'),   
    1 * (SELECT Price FROM Products WHERE PName = 'Cat Medicine') 
);

UPDATE Orders
SET Total = (SELECT SUM(Subtotal) 
             FROM OrderDetails 
             WHERE OrderID = Orders.OrderID)
WHERE OrderID = 2;

SELECT * 
FROM Orders 
WHERE OrderID = 2;

SELECT * 
FROM OrderDetails 
WHERE OrderID = 2;

# NO PAYMENT PROVIDED - SO ORDER CANCELLED
UPDATE Orders
SET OStatus = 'Cancelled'
WHERE OrderID = 2;

# COMPLEX QUERY TO ORDER MOST EXPENSIVE ITEM TO LEAST EXPENSIVE ITEM
SELECT 
    p.ProductID,
    p.PName AS Product_Name,
    p.CategoryID,
    c.Category_Name,
    p.Price,
    p.Quantity,
    RANK() OVER (ORDER BY p.Price DESC) AS Price_Rank
FROM 
    Products p
LEFT JOIN 
    Categories c ON p.CategoryID = c.CategoryID
ORDER BY 
    p.Price DESC;


# COMPLEX QUEREY - GIVE THE CATEGORY WITH THE MOST PRODUCTS
WITH MostPopulatedCategory AS (
    SELECT 
        CategoryID, 
        COUNT(*) AS Product_Count
    FROM 
        Products
    GROUP BY 
        CategoryID
    ORDER BY 
        Product_Count DESC
    LIMIT 1
)
SELECT 
    p.CategoryID,
    c.Category_Name,
    p.ProductID,
    p.PName AS Product_Name,
    p.Price,
    p.Quantity
FROM 
    Products p
JOIN 
    Categories c ON p.CategoryID = c.CategoryID
WHERE 
    p.CategoryID = (SELECT CategoryID FROM MostPopulatedCategory)
ORDER BY 
    p.Price DESC;

# COMPLEX QUERY TO SHOW SUPPLIER WITH MOST PRODUCT DELIVERY 
WITH SupplierProductCounts AS (
    SELECT 
        SupplierID,
        COUNT(*) AS Total_Products
    FROM 
        Products
    GROUP BY 
        SupplierID
    ORDER BY 
        Total_Products DESC
    LIMIT 1
)
SELECT 
    p.SupplierID,
    s.Name,
    p.ProductID,
    p.PName AS Product_Name,
    p.Price,
    p.Quantity
FROM 
    Products p
JOIN 
    Suppliers s ON p.SupplierID = s.SupplierID
WHERE 
    p.SupplierID = (SELECT SupplierID FROM SupplierProductCounts)
ORDER BY 
    p.Price DESC;
    
# TRIGGER WHEN ITEMS FALL BELOW RECOMMENDED MINIMUM INVENTORY LEVEL
DELIMITER $$

CREATE TRIGGER trg_update_low_stock
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.Quantity < NEW.Minimum_Stock THEN
        UPDATE Products
        SET LowStockFlag = 1
        WHERE ProductID = NEW.ProductID;
    ELSE
        UPDATE Products
        SET LowStockFlag = 0
        WHERE ProductID = NEW.ProductID;
    END IF;
END$$

DELIMITER ;
