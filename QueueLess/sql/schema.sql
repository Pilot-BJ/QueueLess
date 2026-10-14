CREATE DATABASE IF NOT EXISTS queueless;
USE queueless;
CREATE TABLE users(id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(80) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL,
  password CHAR(64) NOT NULL, role ENUM('STUDENT','ADMIN') DEFAULT 'STUDENT');
CREATE TABLE menu_items(id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(80) NOT NULL, category VARCHAR(40),
  price DECIMAL(8,2) NOT NULL, available BOOLEAN DEFAULT TRUE);
CREATE TABLE orders(id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, token_no INT NOT NULL, order_date DATE NOT NULL,
  pickup_slot VARCHAR(20) NOT NULL, total DECIMAL(9,2) NOT NULL,
  status ENUM('PLACED','PREPARING','READY','COLLECTED') DEFAULT 'PLACED',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, UNIQUE(order_date, token_no), FOREIGN KEY(user_id) REFERENCES users(id));
CREATE TABLE order_items(id INT AUTO_INCREMENT PRIMARY KEY, order_id INT NOT NULL, item_id INT NOT NULL, qty INT NOT NULL,
  price DECIMAL(8,2) NOT NULL, FOREIGN KEY(order_id) REFERENCES orders(id), FOREIGN KEY(item_id) REFERENCES menu_items(id));
INSERT INTO menu_items(name,category,price) VALUES
('Masala Dosa','Breakfast',45),('Idli (3 pcs)','Breakfast',30),('Veg Sandwich','Snacks',35),('Samosa','Snacks',15),
('Veg Meals','Lunch',70),('Chicken Biryani','Lunch',110),('Fried Rice','Lunch',80),
('Filter Coffee','Drinks',15),('Masala Tea','Drinks',12),('Fresh Lime Soda','Drinks',25);
INSERT INTO users(name,email,password,role) VALUES('Canteen Admin','admin@queueless.com','240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9','ADMIN');
