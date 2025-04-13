CREATE DATABASE Bookstore;

USE Bookstore;
 -- Order_status table
 CREATE TABLE Order_status(
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(255) NOT NULL
 );

-- Shipping_method table
 CREATE TABLE Shipping_method(
    shipping_method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(255) NOT NULL
 );
 
 --Address_status table
 CREATE TABLE Address_status(
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(255) NOT NULL
 );

--Book_language table
 CREATE TABLE Book_language(
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR (255) NOT NULL
 );

 --Publisher table
 CREATE TABLE Publisher(
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(255) NOT NULL,
);

--Country table
CREATE TABLE Country(
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(255) NOT NULL,
);

--Customer table
CREATE TABLE Customer(
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,

);


--Address table
CREATE TABLE Address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street VARCHAR(255) NOT NULL,
    country_name VARCHAR(255) NOT NULL,
    postal_code VARCHAR(255) NOT NULL,
    country_id INT,  

    FOREIGN KEY (country_id) REFERENCES Country(country_id)
);

-- Customer_address table
CREATE TABLE Customer_address (
    customer_id INT,
    address_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);
-- Customer_order table
 CREATE TABLE Customer_order(
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    shipping_method_id INT,
    status_id INT,
      
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES Shipping_method(shipping_method_id),
    FOREIGN KEY (status_id) REFERENCES Address_status(status_id)
    
 );


--Author table
  CREATE TABLE Author(
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(255) NOT NULL,
    author_info VARCHAR(255) NOT NULL
 );
 
 -- book table
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    language_id INT,
    price DECIMAL(10,2),

    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

--Book_author table
 CREATE  TABLE Book_author(
    book_id INT,
    author_id INT,

    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (author_id) REFERENCES Author(author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)

 );


-- Order_history table
CREATE TABLE Order_history(
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    status_id INT,
    change_date DATE,

    FOREIGN KEY (order_id) REFERENCES Customer_order(order_id),
    FOREIGN KEY (status_id) REFERENCES Address_status(status_id)
);



-- order_line table
 CREATE TABLE order_line(
    order_line_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id) REFERENCES Customer_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)

);


-- adding data to the tables
INSERT INTO Order_status (status_name) VALUES 
('Pending'),
('Shipped'),
('Delivered'),
('Cancelled');


INSERT INTO Shipping_method (method_name) VALUES 
('Standard Shipping'),
('Express Shipping'),
('Overnight Shipping');


INSERT INTO Address_status (status_name) VALUES 
('Active'),
('Inactive'),
('Deleted');


INSERT INTO Book_language (language_name) VALUES 
('English'),
('French'),
('Spanish');

INSERT INTO Publisher (publisher_name) VALUES 
('Myles'),
('Pastor Chris'),
('Gods General');


INSERT INTO Country (country_name) VALUES 
('Bahamas'),
('Nigeria'),
('UK');

INSERT INTO Customer (first_name, last_name, email, phone) VALUES 
('Brian', 'kots', 'brian@gmail.com', '0798456782'),
('June', 'bett', 'june@gmail.com', '0787654123');


INSERT INTO Address (street, country_name, postal_code, country_id) VALUES 
('123 good Street', 'USA', '10001', 1),
('456  Avenue', 'Canada', 'M5V 2T6', 2);

INSERT INTO Customer_address (customer_id, address_id) VALUES 
(1, 1),
(2, 2);

INSERT INTO Author (author_name, author_info) VALUES 
('Myles', 'The best of them all'),
('Pastor Chris', 'British author, best ');

INSERT INTO Book (title, publisher_id, language_id, price) VALUES 
 ('Daily life', 1, 1, 19.99),
('Waiting and dating', 2, 1, 29.99);



INSERT INTO Book_author (book_id, author_id) VALUES 
(1, 1),
(2, 2);


INSERT INTO Customer_order (customer_id, order_date, shipping_method_id, status_id) VALUES 
(1, '2025-01-01', 1, 1),
(2, '2025-01-03', 2, 2);

INSERT INTO Order_history (order_id, status_id, change_date) VALUES 
(1, 1, '2025-04-01'),
(1, 2, '2025-04-02'),
(2, 1, '2025-04-03');

INSERT INTO order_line (order_id, book_id, quantity, price) VALUES 
(1, 1, 2, 19.99),
(2, 2, 1, 29.99);


-- Create an admin user
 CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_pass';
GRANT ALL PRIVILEGES ON Bookstore.* TO 'admin_user'@'localhost';

-- Create a manager user
CREATE USER 'manager_user'@'localhost' IDENTIFIED BY 'manager_pass';
GRANT SELECT, INSERT, UPDATE, DELETE ON Bookstore.* TO 'manager_user'@'localhost';

-- Create a second  user
CREATE USER 'second_user'@'localhost' IDENTIFIED BY 'second_user';
GRANT SELECT ON Bookstore.* TO 'second_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;
-- data
SELECT 
    b.title,
    SUM(ol.quantity * ol.price) AS total_sales
FROM order_line ol
JOIN book b ON ol.book_id = b.book_id
GROUP BY b.title;

--data
SELECT * FROM Customer_order;
-- data
SELECT 
    ol.order_id,
    b.title,
    ol.quantity
FROM order_line ol
JOIN book b ON ol.book_id = b.book_id;
