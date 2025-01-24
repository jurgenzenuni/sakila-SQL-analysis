-- ***** -> means used as direct data for analysis in tableau ----
-- Total revenue
SELECT SUM(amount) as `Total Revenue` from payment;

-- Total Revenue by month
SELECT
  DATE_FORMAT(payment_date, '%Y-%m') AS month,
  SUM(amount) AS `Total Revenue`
FROM payment GROUP BY month ORDER BY `Total Revenue` DESC;

-- Total Rentals by month
SELECT
  DATE_FORMAT(r.rental_date, '%Y-%m') AS `Month`,
  COUNT(r.rental_id) AS `Total Rentals`
FROM rental r
GROUP BY `Month`
ORDER BY `Month`;

-- Revenue by month for each store in long format *************************
SELECT
  DATE_FORMAT(p.payment_date, '%Y-%m') AS `Month`,
  s.store_id AS `Store`,
  CONCAT(a.address, ', ', c.city) AS `Store Location`,
  SUM(p.amount) AS `Revenue`
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
GROUP BY `Month`, s.store_id, `Store Location`
ORDER BY `Month`, s.store_id;

-- ------------------------------------------------------------------------------- --
-- Films Performance by revenue + rentals 
SELECT
  f.film_id as `Film ID`,
  f.title as `Title`,
  sum(p.amount) as `Total Film Revenue`,
  COUNT(r.rental_id) as `Total Rentals`
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by f.film_id order by `Total Film Revenue` DESC;

-- films performance rev + rentals, store included comparison ****************************
SELECT
  f.film_id AS `Film ID`,
  f.title AS `Title`,
  s.store_id AS `Store ID`,
  CONCAT(a.address, ', ', c.city) AS `Store Location`,
  SUM(p.amount) AS `Total Film Revenue`,
  COUNT(r.rental_id) AS `Total Rentals`
FROM
  film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
GROUP BY
  f.film_id, s.store_id, `Store Location`
ORDER BY
  `Total Film Revenue` DESC;


-- Top 5 Performing Films by revenue 
SELECT
  f.film_id as `Film ID`,
  f.title as `Title`,
  sum(p.amount) as `Total Film Revenue`,
  COUNT(r.rental_id) as `Total Rentals`
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by f.film_id order by `Total Film Revenue` DESC
limit 5;

-- Bottom 5 Performing Films by revenue
SELECT
  f.film_id as `Film ID`,
  f.title as `Title`,
  sum(p.amount) as `Total Film Revenue`,
  COUNT(r.rental_id) as `Total Rentals`
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by f.film_id order by `Total Film Revenue` asc
limit 5;

-- Top 5 Performing Films by Rental Freq
SELECT
  f.film_id as `Film ID`,
  f.title as `Title`,
  COUNT(r.rental_id) as `Total Rentals`
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by f.film_id order by `Total Rentals` desc
limit 5;

-- Bottom 5 Performing Films by Rental Freq
SELECT
  f.film_id as `Film ID`,
  f.title as `Title`,
  COUNT(r.rental_id) as `Total Rentals`
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by f.film_id order by `Total Rentals` asc
limit 5;

-- ------------------------------------------------------------------------------- --

-- Rentals by genre (All stores)
SELECT
  c.name as `Genre`,
  COUNT(r.rental_id) as `Total Rentals`
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by c.name order by `Total Rentals` desc;

-- Revenue by genre (All stores)
SELECT
  c.name as `Genre`,
  sum(p.amount) as `Total Genre Revenue`
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by c.name order by `Total Genre Revenue` desc;

-- genre rev per set store  *****************************************
SELECT
  s.store_id AS `Store`,
  CONCAT(a.address, ', ', c.city) AS `Store Location`,
  cat.name AS `Genre`,
  SUM(p.amount) AS `Total Genre Revenue`
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
where s.store_id = 2
GROUP BY s.store_id, cat.name
ORDER BY s.store_id, `Total Genre Revenue` DESC;


-- Rentals by Rating (All stores)
SELECT
  f.rating as `Movie Rating`,
  COUNT(r.rental_id) as `Total Rentals`
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.rating order by `Total Rentals` desc;


-- Top 3 Rented Films for a set store
SELECT
  s.store_id as `Store ID`,
  CONCAT(a.address, ', ', c.city) AS `Store Location`,
  f.title as `Film`,
  COUNT(r.rental_id) as `Total Rentals`
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join staff st on r.staff_id = st.staff_id
join store s on st.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
WHERE s.store_id = 1
group by s.store_id, f.title
ORDER BY s.store_id, `Total Rentals` desc LIMIT 3;

-- Top 3 Rented Films Per Store with Store Details
WITH RankedFilms AS (
  SELECT
    s.store_id AS `Store ID`,
    CONCAT(a.address, ', ', c.city) AS `Store Location`,
    f.title AS `Film`,
    COUNT(r.rental_id) AS `Total Rentals`,
    ROW_NUMBER() OVER (PARTITION BY s.store_id ORDER BY COUNT(r.rental_id) DESC) AS `rank`
  FROM film f
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r ON i.inventory_id = r.inventory_id
  JOIN staff st ON r.staff_id = st.staff_id
  JOIN store s ON st.store_id = s.store_id
  JOIN address a ON s.address_id = a.address_id
  JOIN city c ON a.city_id = c.city_id
  GROUP BY s.store_id, f.title
)
SELECT *
FROM RankedFilms
WHERE `rank` <= 3
ORDER BY `Store ID`, `rank`;

-- popular actors via rented movies ***********************************************
SELECT
  CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
  COUNT(r.rental_id) AS rental_count,
  COUNT(DISTINCT f.film_id) AS total_movies
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY a.actor_id
ORDER BY rental_count DESC;


-- ------------------------------------------------------------------------------- --

-- Total revenue by Store
select
  s.store_id as `Store`,
  SUM(p.amount) as `Total Revenue`
from payment p
join staff st on p.staff_id = st.staff_id
join store s on st.store_id = s.store_id
GROUP BY s.store_id ORDER BY `Total Revenue` desc;

-- Rentals by store
SELECT
  s.store_id as `Store`,
  COUNT(r.rental_id) as `Total Rentals`
from rental r
join staff st on r.staff_id = st.staff_id
join store s on st.store_id = s.store_id
group by s.store_id
ORDER BY `Total Rentals` desc;

-- AVG cost of rental per location
SELECT
  s.store_id AS `Store`,
  ROUND(IFNULL(SUM(p.amount) / NULLIF(COUNT(r.rental_id), 0), 0), 2) AS `Average Rental Cost`
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN staff st ON r.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY s.store_id
ORDER BY `Average Rental Cost` DESC;

-- Monthly Revenue per store for comparison

SELECT
  s.store_id AS `Store`,
  DATE_FORMAT(p.payment_date, '%Y-%m') AS `Month`, -- Format date as year-month
  SUM(p.amount) AS `Total Revenue`
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY s.store_id, `Month` -- Group by store and month
ORDER BY s.store_id, `Month`;

-- address included ^^

SELECT
  CONCAT(a.address, ', ', c.city) AS `Store`, -- Combine ID and address
  DATE_FORMAT(p.payment_date, '%Y-%m') AS `Month`, -- Format date as year-month
  SUM(p.amount) AS `Total Revenue`
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
GROUP BY `Store`, `Month` -- Group by store and month
ORDER BY `Store`, `Month`;

-- monthly revenue for a given store id
SELECT
  s.store_id AS `Store ID`,                         
  CONCAT(a.address, ', ', c.city) AS `Store Address`, 
  DATE_FORMAT(p.payment_date, '%Y-%m') AS `Month`,   
  SUM(p.amount) AS `Total Revenue`                   
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
WHERE s.store_id = 1  
GROUP BY s.store_id, `Store Address`, `Month`        
ORDER BY s.store_id, `Month`;                        


-- ------------------------------------------------------------------------------- --
-- Rental History for all customers
SELECT
  c.customer_id as `Customer ID`,
  CONCAT(first_name, ' ' ,last_name) as `Customer`,
  f.title as `Movie`,
  r.rental_date as `RentaL Date`,
  r.return_date as `Return Date`
from customer c 
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
ORDER BY `Customer`;

-- Most active customers
SELECT
  CONCAT(c.first_name, ' ', c.last_name) AS `Customer`,
  COUNT(r.rental_id) AS `Total Rentals`
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY `Total Rentals` DESC
LIMIT 10;

-- Total Revenue per customer (Top 10)
SELECT
  CONCAT(c.first_name, ' ', c.last_name) AS `Customer`,
  SUM(p.amount) AS `Total Revenue`
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY `Total Revenue` DESC
LIMIT 10;

-- ------------------------------------------------------------------------------- --

-- top 3 genres for a given customer, to assess recomendations
WITH GenreRank AS (
  SELECT
    c.customer_id AS `Customer ID`,
    CONCAT(c.first_name, ' ', c.last_name) AS `Customer`,
    cat.name AS `Genre`,
    COUNT(r.rental_id) AS `Total Rentals`,
    RANK() OVER (PARTITION BY c.customer_id ORDER BY COUNT(r.rental_id) DESC) AS `GenreRank`
  FROM customer c
  JOIN rental r ON c.customer_id = r.customer_id
  JOIN inventory i ON r.inventory_id = i.inventory_id
  JOIN film f ON i.film_id = f.film_id
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category cat ON fc.category_id = cat.category_id
  GROUP BY c.customer_id, cat.category_id
)
SELECT 
  `Customer ID`,
  `Customer`,
  `Genre`,
  `Total Rentals`
FROM GenreRank
WHERE `GenreRank` <= 3 and `Customer ID` = 100
ORDER BY `Customer`, `GenreRank`;


-- ---------------------------------------------------------------------------- --
-- Popular Films per Customer ******************
SELECT
    f.title AS Film_Title,
    CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name,
    COUNT(r.rental_id) AS Total_Rentals
FROM
    rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY
    f.title, c.customer_id
ORDER BY
    Total_Rentals DESC;

-- Popular Genres Per Customer ***************************
SELECT
    cat.name AS Genre,
    CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name,
    COUNT(r.rental_id) AS Total_Rentals
FROM
    rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY
    cat.name, c.customer_id
ORDER BY
    Total_Rentals DESC;

-- Total Rentals, monthly per customer *******************************
SELECT
  DATE_FORMAT(r.rental_date, '%Y-%m') AS `Month`, 
  CONCAT(c.first_name, ' ', c.last_name) AS `Customer Name`, 
  COUNT(r.rental_id) AS `Total Rentals` 
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id 
GROUP BY `Month`, c.customer_id 
ORDER BY `Month`, `Total Rentals` DESC; 


-- Customer distribution by # of rentals ******************************
SELECT
  total_rentals,
  COUNT(customer_id) AS customer_count
FROM (
  SELECT
    c.customer_id,
    COUNT(r.rental_id) AS total_rentals
  FROM customer c
  JOIN rental r ON c.customer_id = r.customer_id
  GROUP BY c.customer_id
) AS customer_rentals
GROUP BY total_rentals
ORDER BY total_rentals;

-- Top Customers by profit **********************************
CREATE VIEW top_customers_by_profit AS
SELECT
  RANK() OVER (ORDER BY SUM(p.amount) DESC) AS `rank`,
  CONCAT(c.first_name, ' ', c.last_name) AS `Customers`,
  MAX(r.rental_date) AS last_rental_date,
  SUM(p.amount) AS total_profit,
  COUNT(p.payment_id) AS total_orders
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id
ORDER BY `rank`;

select * from top_customers_by_profit;






