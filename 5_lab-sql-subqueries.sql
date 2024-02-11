/*
Write SQL queries to perform the following tasks using the Sakila database:

1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
2 List all films whose length is longer than the average length of all the films in the Sakila database.
3 Use a subquery to display all actors who appear in the film "Alone Trip".
*/

USE sakila;


# 1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT COUNT(f.title) as Num_of_copies, f.title
FROM film AS f
JOIN inventory AS i
ON f.film_id = i.film_id
WHERE f.title = "Hunchback Impossible";



# 2 List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT film_id, title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);



# 3 Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT a.actor_id, a.first_name, a.last_name, f.title
FROM actor as a
JOIN film_actor AS f_a
ON a.actor_id = f_a.actor_id
JOIN film as f
ON f_a.film_id = f.film_id
WHERE f_a.film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip');



# 3.1 Just to join the name in one cell 

SELECT a.actor_id, CONCAT(first_name, ' ', last_name) AS Name_of_Actors, f.title
FROM actor as a
JOIN film_actor AS f_a
ON a.actor_id = f_a.actor_id
JOIN film as f
ON f_a.film_id = f.film_id
WHERE f_a.film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip');



/*
Bonus:

4 Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

5 Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

6 Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

7 Find the films rented by the most profitable customer in the Sakila database. 
You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
*/



# 4 Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

SELECT f.film_id, f.title, c.name AS film_category, f.rating
FROM film AS f
JOIN film_category AS f_c 
ON f.film_id = f_c.film_id
JOIN category AS c
ON f_c.category_id = c.category_id
WHERE c.name = 'Family';



# 5 Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT cu.customer_id, CONCAT(cu.first_name, ' ', cu.last_name) AS Name_of_Custumer, cu.email, con.country
FROM customer AS cu
JOIN address AS a
ON cu.address_id = a.address_id
JOIN city AS c 
ON a.city_id = c.city_id
JOIN country AS con
ON c.country_id = con.country_id
WHERE country = 'Canada';




#6 Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
#  First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.


SELECT COUNT(f_a.actor_id) as num_movies, CONCAT(a.first_name, ' ', a.last_name) AS Name_of_actors, a.actor_id
FROM film_actor AS f_a 
JOIN Actor AS a
ON a.actor_id = f_a.actor_id
GROUP BY f_a.actor_id, a.first_name, a.last_name
ORDER BY num_movies DESC
LIMIT 1;

# actor name GINA DEGENERES with 42 movies with the actor_id_107

SELECT f.film_id, f.title, CONCAT(a.first_name, ' ', a.last_name) AS Name_of_actor
FROM film AS f
JOIN film_actor AS f_a
ON f.film_id = f_a.film_id
JOIN actor AS a
ON a.actor_id = f_a.actor_id
WHERE a.actor_id = 107;





# 7 Find the films rented by the most profitable customer in the Sakila database. 
# You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.




SELECT c.customer_id, SUM(amount) AS total, CONCAT(c.first_name," ", c.last_name) AS name 
FROM payment AS p
Join customer AS c
ON p.customer_id = c.customer_id
group by c.customer_id
Order by total desc
LIMIT 1
;
# the customer that spend more is KARL SEAL with 221.55 and his customer id is 526


SELECT r.customer_id, f.film_id, f.title
FROM rental as r
JOIN inventory as i
ON r.inventory_id = i.inventory_id
JOIN film as f
ON f.film_id = i.film_id
WHERE customer_id = 526;





 # 8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
 
SELECT customer_id, CONCAT(c.first_name, " ", c.last_name) AS name_customer, total_amount_spent
FROM ( SELECT customer_id, SUM(amount) AS total_amount_spent
	  FROM payment
	  GROUP BY customer_id) AS customer_payments
JOIN customer c
USING (customer_id)
WHERE total_amount_spent > (SELECT AVG(total_amount_spent)
FROM (SELECT customer_id, SUM(amount) AS total_amount_spent
		FROM payment
		GROUP BY customer_id
	  ) AS avg_payments
	);
	 
 
 