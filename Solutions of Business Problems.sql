SELECT * FROM Customer;
SELECT * FROM Product;
SELECT * FROM Sales;

/* Marketing */

SELECT region, case when age<36 then 'Category 1'
					when age>54 then 'Category 3'
                    else 'Category 2' end as age_group, count(*) AS total_count
FROM Customer
GROUP BY region,age_group
ORDER BY region;


/* Operations */

SELECT c.product_id, d.product_name, c.total_q_sold
FROM (SELECT e.product_id, SUM(e.quantity) AS total_q_sold FROM
	SELECT a.*, b.region
	FROM sales as a
	LEFT JOIN customer as b
	ON a.customer_id=b.customer_id) AS e WHERE e.region = 'East' GROUP BY e.product_id) AS c
LEFT JOIN product AS d
ON c.product_id=d.product_id
ORDER BY total_q sold DESC
LIMIT

