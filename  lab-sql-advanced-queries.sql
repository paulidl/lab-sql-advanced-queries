/* Lab | SQL Advanced queries: In this lab, you will be using the Sakila database of movie rentals.

Instructions:

1. List each pair of actors that have worked together.
2. For each film, list actor that has acted in more films. 
*/

-- 1. List each pair of actors that have worked together.

SELECT * FROM sakila.film_actor;	## actor_id, film_id 
SELECT * FROM sakila.actor;			## actor_id, first_name, last_name 

CREATE OR REPLACE VIEW worked_together AS
    SELECT 
        fa1.actor_id AS ID_actor1,
        fa2.actor_id AS ID_actor2,
        fa1.film_id
    FROM sakila.film_actor fa1
	JOIN sakila.film_actor fa2 ON fa1.film_id = fa2.film_id 
	WHERE fa1.actor_id != fa2.actor_id AND fa1.actor_id < fa2.actor_id;
    
SELECT * FROM worked_together;

SELECT 
    ID_actor1,
    a1.first_name,
    a1.last_name,
    ID_actor2,
    a2.first_name,
    a2.last_name
FROM sakila.worked_together
JOIN sakila.actor a1 ON ID_actor1 = a1.actor_id
JOIN sakila.actor a2 ON ID_actor2 = a2.actor_id
GROUP BY ID_actor1, ID_actor2;

-- 2. For each film, list actor that has acted in more films. 

SELECT * FROM sakila.film_actor;	## actor_id, film_id 
SELECT * FROM sakila.film;			## film_id, title  

## Subquery:
SELECT 
		actor_id, 
		count(film_id) AS number_of_film
FROM sakila.film_actor
GROUP BY actor_id
ORDER BY actor_id ASC;

## Query:
WITH cte AS (
	SELECT 
		actor_id, 
		count(film_id) AS number_of_appearances
	FROM sakila.film_actor
	GROUP BY actor_id
	ORDER BY actor_id ASC
)
SELECT film_id, title, actor_id, number_of_appearances
FROM sakila.film_actor
JOIN cte USING(actor_id)
JOIN sakila.film USING(film_id)
GROUP BY film_id, title, actor_id
ORDER BY actor_id;