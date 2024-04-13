use sakila;   

#Q1 -- Use JOIN, compute total number of rentals for movies that have one OR more of the following
#in its description: "cat", "boy", "love"

SELECT title, COUNT(rental_id) FROM film f
	JOIN inventory USING (film_id) 
	JOIN rental USING (inventory_id)
    WHERE f.description 
		LIKE '%cat%'  
		OR f.description LIKE '%boy%' 
		OR f.description LIKE '%love%'  
		GROUP BY f.title;


#Q2. Use subqueries, compute total number of rentals for movies that have one OR more of the 
#following in its description: "cat", "boy", "love"
SELECT title, (SELECT COUNT(rental.rental_id) FROM rental 
	WHERE rental.inventory_id IN  
    (SELECT inventory.inventory_id FROM inventory WHERE inventory.film_id=film.film_id)) 
    FROM film WHERE film.film_id IN 
		(SELECT inventory.film_id FROM inventory WHERE inventory.inventory_id IN
        (SELECT rental.inventory_id FROM rental WHERE film.film_id IN
        (SELECT film_id FROM film WHERE
		film.description LIKE '%cat%' OR
		film.description LIKE '%boy%' OR
		film.description LIKE '%love%'
		GROUP BY title)));  
        
#Q3. List of film titles and count of their inventories (copies), for movies that
#have two or more copies of films available

 SELECT title, COUNT(inventory_id) 
	FROM inventory i JOIN film f USING (film_id)
    GROUP BY title
    HAVING COUNT(DISTINCT(inventory_id))>=2
    ORDER BY COUNT(DISTINCT(inventory_id)) DESC;
    
#Q4. Calculate total amount of all transactions for each of the top 100 customers
#(use both table customer and payment)

 SELECT customer_id, first_name, last_name, SUM(amount)
	FROM customer c JOIN payment p USING (customer_id)
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 100;
 
#Q5. List films that are in English and starred by actors whose first name is Julia.
	#You should let the query search the IDs for corresponding film and actor, instead of manually 
		#inputting the IDs in where condition
		#If more than one Julia starred in the same film, one film should be counted as one

SELECT DISTINCT(title)
	FROM film f JOIN language USING (language_id)
    JOIN film_actor fa USING (film_id)
    JOIN actor a USING (actor_id)
    WHERE language.name='English' AND
	a.first_name='Julia';
 

#Q6. list of 5 film names and descriptions that have made the most number of payment transactions

  SELECT r.rental_id, title, f.description, COUNT(p.payment_id) FROM film f
	JOIN inventory i USING (film_id)
    JOIN rental r USING (inventory_id)
    JOIN payment p USING (customer_id)
    GROUP BY rental_id
    ORDER BY COUNT(payment_id) DESC
    LIMIT 5;

#Q7. in one query, list addresses that lie in the city/cities that have the maximum number of 
#addresses in table address
SELECT address, district, city_id, postal_code FROM address
	WHERE city_id IN 
		(SELECT city_id FROM address GROUP BY city_id
			HAVING COUNT(*)=(SELECT MAX(city_count) FROM (SELECT COUNT(*) AS city_count
					FROM address GROUP BY city_id) 
					AS city_counts));
 

#q8. in one query, list the count of films that is in the category "Family"
SELECT COUNT(f.film_id), c.name
	FROM film f JOIN film_category fc USING (film_id)
    JOIN category c USING (category_id)
    WHERE c.name = 'Family';
 

#q9. in one query, list actors' full name and count of times that they have starred in 
#	film category "Family" from largest to smallest

  SELECT a.actor_id, a.first_name, a.last_name, c.name, COUNT(c.name) FROM actor a
	JOIN film_actor fa USING (actor_id)
    JOIN film_category fc USING (film_id)
    JOIN category c USING (category_id)
    WHERE c.name = 'Family'
    GROUP BY actor_id
    ORDER BY COUNT(c.name) DESC;

#Q10. List a query that lists the film genres and gross revenue for that genre, 
#conditional to the average gross revenue for that genre being higher than the average gross revenue per genre.

#Hint: Use a View to simplify the query. 

DROP VIEW IF EXISTS genre_avg_gross;
CREATE VIEW genre_avg_gross AS
	SELECT c.name AS genre, AVG(f.rental_rate*p.amount) AS avg_genre_gross FROM film f
		JOIN film_category fc ON f.film_id = fc.film_id
		JOIN category c ON fc.category_id = c.category_id
		JOIN inventory i ON f.film_id = i.film_id
		JOIN rental r ON i.inventory_id = r.inventory_id
		JOIN payment p ON r.rental_id = p.rental_id
		GROUP BY c.name;
SELECT g.genre, SUM(f.rental_rate * p.amount) AS gross_revenue FROM film f
	JOIN film_category fc ON f.film_id = fc.film_id
	JOIN category c ON fc.category_id = c.category_id
	JOIN inventory i ON f.film_id = i.film_id
	JOIN rental r ON i.inventory_id = r.inventory_id
	JOIN payment p ON r.rental_id = p.rental_id
	JOIN genre_avg_gross g ON c.name = g.genre
	WHERE f.rental_rate * p.amount > g.avg_genre_gross
	GROUP BY g.genre HAVING AVG(f.rental_rate * p.amount) > (SELECT AVG(avg_genre_gross) FROM genre_avg_gross)
	ORDER BY gross_revenue DESC;