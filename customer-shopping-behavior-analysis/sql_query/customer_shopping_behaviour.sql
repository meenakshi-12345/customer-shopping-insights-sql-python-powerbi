SELECT * FROM customer LIMIT 20;



-- Q1. WHAT IS THE TOTAL REVENUE GENREATED BY MALE VS FEMAL CUSTOMERS 


SELECT gender, SUM(purchase_amount) AS revenue_generated
FROM customer 
GROUP BY (gender)
ORDER BY revenue_generated;


-- Q2. WHICH CUSTOMERS USED A DISCOUNT BUT STILL SPENT MORE THAN THE AVERAGE AMOUNT 

SELECT * FROM customer; 



SELECT CAST(AVG(purchase_amount) AS DECIMAL(10,2))
FROM customer;

SELECT customer_id, purchase_amount 
FROM customer 
WHERE discount_applied = 'Yes' AND purchase_amount >= (SELECT CAST(AVG(purchase_amount) AS DECIMAL(10,2))
                           FROM customer);


-- Q3. WHICH ARE THE TOP 5 PRODUCTS WITH THE HIGHEST AVERAGE REVIEW RATING 


SELECT * FROM customer;

SELECT item_purchased, CAST(AVG(review_rating)AS DECIMAL(10,2)) AS average
FROM customer
GROUP BY item_purchased
ORDER BY average DESC
LIMIT 5;


-- Q4. COMPARE THE AVERAGE PURCHASE AMOUNT BETWEEN STANDARD AND EXPRESS SHIPPING

SELECT * FROM customer;

SELECT shipping_type, CAST(AVG(purchase_amount)AS DECIMAL(10,2)) AS average
FROM customer 
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;





-- Q5. COMPARE AVGERAGE SPEND, TOTAL REVENUE BETWEEN SUBSRIBERS AND NON-SUBSCRIBERS 

SELECT * FROM customer;


SELECT subscription_status, COUNT(customer_id), CAST(AVG(purchase_amount) AS DECIMAL(10,2)),SUM(purchase_amount)
FROM customer 
GROUP BY subscription_status
ORDER BY SUM(purchase_amount);


-- Q6. WHICH 5 PRODUCTS HAVE THE HIGHEST % OF PURCHASE WITH DISCOUNT APPLIED

SELECT * FROM customer;

SELECT item_purchased, CAST(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)*100/COUNT(*) AS DECIMAL(10,2)) AS discount_per
FROM customer
GROUP BY item_purchased
ORDER BY discount_per DESC LIMIT 5;

-- Q7. SEGMENT CUSTOMERS INTO NEW, RETURNING AND LOYAL BASED ON THEIR TOTAL NUMBER OF PREVIOUS
-- PURCHASES, AND SHOW THE COUNT OF EACH SEGMENT 


WITH customer_type AS(
SELECT customer_id, previous_purchases,
CASE WHEN previous_purchases = 1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
	ELSE 'Loyal' 
	END AS customer_segment
FROM customer
)

SELECT customer_segment, COUNT(*) AS "Number of customer" 
FROM customer_type
GROUP BY customer_segment;


-- Q8. WHAT ARE THE TOP 3 MOST PURCHASED PRODUCTS WITHIN EACH CATEGORY 

SELECT * FROM customer;


WITH item_counts AS (
SELECT category, item_purchased, COUNT(customer_id) AS total_orders, 
ROW_NUMBER() OVER(PARTITION BY CATEGORY ORDER BY COUNT(customer_id) DESC) AS item_rank
FROM customer 
GROUP BY category, item_purchased
)

SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank<=3;





-- Q9. ARE CUSTOMERS WHO ARE REPEAT BUYERS(MORE THAN 5 PREVIOUS PURCHASES) ALSO LIKELY TO SUBSCRIBE?


SELECT * FROM customer;

SELECT subscription_status, COUNT(customer_id) AS repeat_buyers
FROM customer 
WHERE previous_purchases >5
GROUP BY subscription_status


-- Q10. WHAT IS THE REVENUE CONTRIBUTION OF EACH AGE GROUP 

SELECT * FROM customer;



SELECT age_group, CAST(SUM(purchase_amount) AS DECIMAL(10,2)) AS revenue
FROM customer
GROUP BY age_group
ORDER BY revenue DESC;



