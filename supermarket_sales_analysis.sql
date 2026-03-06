SELECT * FROM supermarket_sales;

INSERT INTO supermarket_sales_final
SELECT
    invoice_id,
    branch,
    city,
    customer_type,
    gender,
    product_line,
    unit_price::NUMERIC,
    quantity::INT,
    tax::NUMERIC,
    sales::NUMERIC,
    TO_DATE(sale_date, 'MM/DD/YYYY'),
    TO_TIMESTAMP(sale_time, 'HH12:MI:SS AM')::TIME,
    payment,
    cogs::NUMERIC,
    gross_margin_percentage::NUMERIC,
    gross_income::NUMERIC,
    rating::NUMERIC
FROM supermarket_sales;

-- 1.Qual é a margem de lucro geral da empresa?

SELECT 
    ROUND(SUM(sales),2) AS total_revenue,
    ROUND(SUM(gross_income),2) AS total_profit,
    ROUND(SUM(gross_income) / SUM(sales) * 100,2) AS profit_margin_pct
FROM supermarket_sales_final;

-- 2.Qual filial possui maior faturamento e lucro?

SELECT branch,
       ROUND(SUM(sales),2) AS total_revenue,
       ROUND(SUM(gross_income),2) AS total_profit
FROM supermarket_sales_final
GROUP BY branch
ORDER BY total_profit DESC;

-- 3.Qual product_line gera mais receita?

SELECT product_line,
       ROUND(SUM(sales),2) AS total_revenue,
       ROUND(SUM(gross_income),2) AS total_profit
FROM supermarket_sales_final
GROUP BY product_line
ORDER BY total_profit DESC;

-- 4.Existe diferença de gasto médio entre gêneros?

SELECT gender,
       ROUND(AVG(sales),2) AS avg_ticket
FROM supermarket_sales_final
GROUP BY gender;

-- 5.Qual período do dia gera mais receita?

SELECT 
    CASE
        WHEN sale_time BETWEEN '08:00:00' AND '11:59:59' THEN 'Morning'
        WHEN sale_time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END AS period,
    ROUND(SUM(sales),2) AS total_revenue
FROM supermarket_sales_final
GROUP BY period
ORDER BY total_revenue DESC;

-- 6.Maior volume gera maior lucro?

SELECT product_line,
       SUM(quantity) AS total_quantity,
       ROUND(SUM(gross_income),2) AS total_profit
FROM supermarket_sales_final
GROUP BY product_line
ORDER BY total_quantity DESC;

-- 7.Existe padrão de venda ao longo da semana?

SELECT 
    TRIM(TO_CHAR(sale_date, 'Day')) AS weekday,
    ROUND(SUM(sales),2) AS total_revenue
FROM supermarket_sales_final
GROUP BY weekday
ORDER BY total_revenue DESC;

-- 8.O programa de fidelidade impacta o ticket médio?

SELECT customer_type,
       ROUND(AVG(sales),2) AS avg_ticket,
       ROUND(SUM(sales),2) AS total_revenue
FROM supermarket_sales_final
GROUP BY customer_type;