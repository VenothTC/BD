use challenge1;


-- 1. What is the total amount each customer spent at the restaurant?
SELECT customer_id, SUM(m.price) as total
FROM sales s
LEFT JOIN menu m ON s.product_id = m.product_id
GROUP BY customer_id
ORDER BY total DESC;


-- 2. How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(order_date) as days
FROM (
	SELECT customer_id, order_date
	FROM sales
	GROUP BY customer_id, order_date
) as s
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
SELECT customer_id, product_id
FROM
( 
	SELECT customer_id, product_id,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date ASC) as order_num
	FROM sales
) as s
WHERE order_num = 1
;



-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT product_id, COUNT(*) as total_orders
FROM sales s
GROUP BY product_id
ORDER BY total_orders DESC;

-- 5. Which item was the most popular for each customer?
WITH product_counts AS (
	SELECT customer_id, product_id, 
		COUNT(*) as total_p_o,
		RANK() OVER (PARTITION BY customer_id ORDER BY COUNT(*) DESC) as rnk 
	FROM sales 
	GROUP BY customer_id, product_id 
	ORDER BY customer_id, total_p_o DESC
) 
SELECT customer_id, product_id, total_p_o as most_purchased
FROM product_counts
WHERE rnk=1;

-- 6. Which item was purchased first by the customer after they became a member?

WITH after_join AS (
	SELECT s.customer_id,
		s.product_id,
		ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ASC) as rn
	FROM sales s 
	LEFT JOIN members m ON s.customer_id = m.customer_id
	WHERE s.order_date >= m.join_date  
)
SELECT *
from after_join
WHERE rn=1
;

-- 7. Which item was purchased just before the customer became a member?
WITH before_join AS (
	SELECT s.customer_id,
		s.product_id,
		ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) as rn
	FROM sales s 
	LEFT JOIN members m ON s.customer_id = m.customer_id
	WHERE s.order_date < m.join_date 
)
SELECT *
FROM before_join
WHERE rn=1 ;

-- 8. What is the total items and amount spent for each member before they became a member?

WITH before_joined AS (
	SELECT s.customer_id, s.product_id, s.order_date, m.join_date 
	FROM sales s
	LEFT JOIN members m ON s.customer_id = m.customer_id
	WHERE s.order_date < m.join_date
)
SELECT s.customer_id, 
	COUNT(s.customer_id) as total_items, 
    SUM(m.price) as total_spent
FROM before_joined s
LEFT JOIN menu m ON m.product_id = s.product_id
GROUP BY s.customer_id
;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH points AS 
(
	SELECT s.customer_id, s.product_id, m.price, m.product_name,
    CASE
		WHEN m.product_name = "sushi" THEN m.price*20
        ELSE m.price*10
        END AS points
    FROM sales s LEFT JOIN menu m ON m.product_id = s.product_id
)
SELECT customer_id, SUM(points) FROM points
GROUP BY customer_id;



-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi 
-- 		how many points do customer A and B have at the end of January?
WITH points AS 
(
	SELECT s.customer_id, s.product_id, m.price, m.product_name, mm.join_date, s.order_date,
    DATEDIFF(s.order_date, mm.join_date),
    CASE
		WHEN m.product_name = "sushi" THEN m.price*20
        WHEN (DATEDIFF(s.order_date, mm.join_date) BETWEEN 0 AND 7) THEN m.price*20
        ELSE m.price*10
        END AS points
    FROM sales s 
    LEFT JOIN menu m ON m.product_id = s.product_id
    LEFT JOIN members mm ON mm.customer_id = s.customer_id
)
SELECT customer_id, SUM(points)
FROM points s
WHERE order_date <= '2021-01-31' AND customer_id != 'C'
GROUP BY customer_id
;

