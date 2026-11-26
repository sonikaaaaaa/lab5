-- 1. Вимір часу
CREATE TABLE Dim_Date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day_of_week VARCHAR(15) NOT NULL,
    month_num INT NOT NULL CHECK (month_num BETWEEN 1 AND 12),
    month_name VARCHAR(20) NOT NULL,
    quarter INT NOT NULL CHECK (quarter BETWEEN 1 AND 4),
    year INT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

-- 2. Вимір товарів (автозапчастин)
CREATE TABLE Dim_Product (
    product_key SERIAL PRIMARY KEY,
    product_code VARCHAR(30) NOT NULL UNIQUE,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    truck_brand VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(50) NOT NULL,
    purchase_cost NUMERIC(10, 2) NOT NULL
);

-- 3. Вимір клієнтів
CREATE TABLE Dim_Customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id_src VARCHAR(20) NOT NULL UNIQUE,
    customer_name VARCHAR(150) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    region VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    discount_tier VARCHAR(20) DEFAULT 'Базовий'
);

-- 4. Вимір менеджерів збуту
CREATE TABLE Dim_Manager (
    manager_key SERIAL PRIMARY KEY,
    employee_id VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL
);

-- 5. Вимір доставки та оплати
CREATE TABLE Dim_Delivery (
    delivery_key SERIAL PRIMARY KEY,
    delivery_method VARCHAR(50) NOT NULL,
    carrier_name VARCHAR(50),
    payment_method VARCHAR(50) NOT NULL
);

-- 6. Центральна таблиця фактів продажів
CREATE TABLE Fact_Sales (
    sale_key SERIAL PRIMARY KEY,
    date_key INT NOT NULL REFERENCES Dim_Date(date_key),
    product_key INT NOT NULL REFERENCES Dim_Product(product_key),
    customer_key INT NOT NULL REFERENCES Dim_Customer(customer_key),
    manager_key INT NOT NULL REFERENCES Dim_Manager(manager_key),
    delivery_key INT NOT NULL REFERENCES Dim_Delivery(delivery_key),
    order_number VARCHAR(20) NOT NULL,
    quantity_sold INT NOT NULL CHECK (quantity_sold > 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    total_revenue NUMERIC(12, 2) NOT NULL CHECK (total_revenue >= 0),
    discount_amount NUMERIC(12, 2) DEFAULT 0 CHECK (discount_amount >= 0),
    net_profit NUMERIC(12, 2) NOT NULL
);

-- Індекси для прискорення OLAP-з'єднань
CREATE INDEX idx_fact_sales_date ON Fact_Sales(date_key);
CREATE INDEX idx_fact_sales_product ON Fact_Sales(product_key);
CREATE INDEX idx_fact_sales_customer ON Fact_Sales(customer_key);
CREATE INDEX idx_fact_sales_manager ON Fact_Sales(manager_key);
