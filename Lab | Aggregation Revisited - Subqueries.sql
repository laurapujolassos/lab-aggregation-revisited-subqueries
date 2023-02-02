# Lab | Aggregation Revisited - Subqueries
# 1. Select the first name, last name, and email address of all the customers who have rented a movie.
select c.first_name, c.last_name, a.address from sakila.address a
join sakila.customer c on a.address_id= c.address_id;

# 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made)
SELECT 
  customer.customer_id, 
  CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, 
  AVG(payment.amount) AS avg_payment
FROM 
  sakila.customer
  JOIN sakila.payment ON customer.customer_id = payment.customer_id
GROUP BY 
  customer.customer_id, customer_name;
  
  # Select the name and email address of all the customers who have rented the "Action" movies.
  # Write the query using multiple join statements
select * from sakila.category;

select c.first_name, c.last_name, c.email, cat.name from sakila.customer c
join sakila.rental r
on c.customer_id = r.customer_id
join sakila.inventory i
on r.inventory_id = i.inventory_id
join sakila.film f
on i.film_id = f.film_id
join sakila.film_category fc
on f.film_id = fc.film_id
join sakila.category cat
on fc.category_id = cat.category_id
where name='Action';

# Write the query using sub queries with multiple WHERE clause and IN condition
SELECT 
  c.first_name, c.last_name, c.email, cat.name
FROM 
  sakila.customer c
  JOIN (
    SELECT customer_id
    FROM sakila.rental r
    WHERE inventory_id IN (
      SELECT inventory_id
      FROM sakila.inventory i
      WHERE film_id IN (
        SELECT film_id
        FROM sakila.film f
        WHERE film_id IN (
          SELECT film_id
          FROM sakila.film_category fc
          WHERE category_id IN (
            SELECT category_id
            FROM sakila.category cat
            WHERE name = 'Action'
          )
        )
      )
    )
  ) AS rental_filters
  ON c.customer_id = rental_filters.customer_id
  JOIN sakila.category cat
  ON (
    SELECT category_id
    FROM sakila.film_category fc
    WHERE film_id IN (
      SELECT film_id
      FROM sakila.film f
      WHERE film_id IN (
        SELECT film_id
        FROM sakila.inventory i
        WHERE inventory_id IN (
          SELECT inventory_id
          FROM sakila.rental r
          WHERE customer_id = c.customer_id
        )
      )
    )
  ) = cat.category_id
WHERE 
  cat.name = 'Action';
  
  
  # Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high
  SELECT amount,
  CASE 
    WHEN amount BETWEEN 0 AND 2 THEN 'low'
    WHEN amount BETWEEN 2 AND 4 THEN 'medium'
    WHEN amount > 4 THEN 'high'
    ELSE 'undetermined'
  END AS transaction_value
FROM 
  sakila.payment;


