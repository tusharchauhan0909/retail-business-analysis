Create database if not exists retail_analysis;alter

USE retail_analysis;

SELECT * FROM retail_analysis.fact_order;

SHOW COLUMNS FROM fact_order;


ALTER TABLE fact_order
CHANGE `Customer ID` customer_id BIGINT,
CHANGE `Customer Status` customer_status TEXT,
CHANGE `Order Date` order_date DATETIME,
CHANGE `Delivery Date` delivery_date DATETIME,
CHANGE `Order ID` order_id BIGINT,
CHANGE `Product ID` product_id BIGINT,
CHANGE `Quantity Ordered` quantity_ordered BIGINT,
CHANGE `Total Retail Price for This Order` revenue DOUBLE,
CHANGE `Cost Price Per Unit` cost_price_per_unit DOUBLE,
CHANGE `Total Cost` total_cost DOUBLE,
CHANGE `Profit` profit DOUBLE,
CHANGE `Profit Margin Pct` profit_margin_pct DOUBLE,
CHANGE `Delivery Days` delivery_days BIGINT;

SELECT COUNT(*) AS total_rows
FROM fact_order;
 
SELECT 
	ROUND(SUM(revenue),2) as total_revenue,
    ROUND(SUM(total_cost),2) as total_cost,
    ROUND(SUM(profit),2) as total_profit
FROM fact_order;

SELECT MIN(order_date) as first_order,
MAX(order_date) as last_order 
FROM fact_order;

SELECT 
    customer_status,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(SUM(profit),2) AS profit,
    ROUND(SUM(profit)/SUM(revenue)*100,2) AS margin_pct
FROM fact_order
GROUP BY customer_status
ORDER BY profit DESC;

SELECT 
    product_id,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(SUM(profit),2) AS profit,
    ROUND(SUM(profit)/SUM(revenue)*100,2) AS margin_pct
FROM fact_order
GROUP BY product_id
ORDER BY profit DESC
LIMIT 10;

SELECT 
    ROUND(AVG(cost_price_per_unit),2) AS avg_unit_cost,
    ROUND(AVG(revenue/quantity_ordered),2) AS avg_unit_price
FROM fact_order;

SELECT 
    CASE 
        WHEN delivery_days <= 3 THEN 'Fast'
        WHEN delivery_days <= 7 THEN 'Medium'
        ELSE 'Slow'
    END AS delivery_speed,
    COUNT(*) AS orders,
    ROUND(SUM(profit),2) AS total_profit
FROM fact_order
GROUP BY delivery_speed
ORDER BY total_profit DESC;

CREATE VIEW vw_business_summary AS
SELECT 
    customer_status,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(SUM(profit),2) AS profit,
    ROUND(SUM(profit)/SUM(revenue)*100,2) AS margin_pct
FROM fact_order
GROUP BY customer_status;

CREATE VIEW vw_delivery_impact AS
SELECT 
    CASE 
        WHEN delivery_days <= 3 THEN 'Fast'
        WHEN delivery_days <= 7 THEN 'Medium'
        ELSE 'Slow'
    END AS delivery_speed,
    ROUND(SUM(profit),2) AS total_profit
FROM fact_order
GROUP BY delivery_speed;

SELECT 
    p.product_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.quantity_ordered) AS total_quantity_sold,
    ROUND(SUM(f.revenue),2) AS total_revenue,
    ROUND(SUM(f.profit),2) AS total_profit
FROM fact_order f
JOIN product p
    ON f.product_id = p.product_id
GROUP BY p.product_name;

SELECT 
    p.product_name,
    SUM(f.revenue) AS total_revenue,
    SUM(f.quantity_ordered) AS quantity_sold
FROM fact_order f
JOIN product p
    ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

SELECT 
    p.product_name,
    SUM(f.revenue) AS total_revenue,
    SUM(f.quantity_ordered) AS quantity_sold
FROM fact_order f
JOIN product p
    ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue ASC
LIMIT 10;

SELECT 
    p.product_name,
    ROUND(SUM(f.revenue),2) AS revenue,
    ROUND(SUM(f.profit),2) AS profit,
    ROUND(SUM(f.profit)/SUM(f.revenue)*100,2) AS profit_margin_pct
FROM fact_order f
JOIN product p
    ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit_margin_pct DESC
LIMIT 10;

SELECT 
    p.product_name,
    ROUND(SUM(f.revenue),2) AS revenue,
    ROUND(SUM(f.profit),2) AS profit,
    ROUND(SUM(f.profit)/SUM(f.revenue)*100,2) AS profit_margin_pct
FROM fact_order f
JOIN product p
    ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit_margin_pct ASC
LIMIT 10;

-- Project: Retail Business Performance & Profitability Analysis
-- Author: Tushar Singh Chauhan
-- Database: MySQL 
-- Description: Business KPIs and profitability analysis
