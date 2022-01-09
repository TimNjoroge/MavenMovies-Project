/*
QUESTION 1 - My partner and I want to come by each of the stores in person and meet the managers. Please send over 
the managers’ names at each store, with the full address of each property (street address, district, city, and 
country please).

*/ 
select
staff.store_id as 'Store Number',
staff.first_name as 'First Name',
staff.last_name as 'Last Name',
address.address,
address.district,
city.city_id as 'City',
country.country
from staff
inner join store
on staff.store_id = store.store_id
inner join address
on staff.address_id = address.address_id
inner join city
on address.city_id = city.city_id
inner join country
on city.country_id = country.country_id;

/*
QUESTION 2 - I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost.
*/

select
inventory.store_id,
inventory.inventory_id,
(film.title) ,
film.rating,
film.rental_rate,
film.replacement_cost
from inventory
inner join film
on inventory.film_id = film.film_id;

/*
QUESTION 3 From the same list of films you just pulled, please roll that data up and provide a summary level overview of 
your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

select
inventory.store_id as 'store ID',
count(inventory.inventory_id) as 'no of inventory items',
film.rating
from inventory
inner join film
on inventory.film_id = film.film_id
group by film.rating, inventory.store_id
order by inventory.store_id desc;

/*
QUESTION 4 - Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement 
cost, sliced by store and film category. 
*/

select
inventory.store_id,
category.name as 'film category',
count(inventory.inventory_id) as 'no of inventory items',
avg(film.replacement_cost) as 'average replacement cost',
sum(film.replacement_cost) as 'total replacement cost'
from inventory
inner join film
on inventory.film_id = film.film_id
inner join film_category
on film.film_id = film_category.film_id
inner join category
on film_category.category_id = category.category_id
group by inventory.store_id, category.name
order by inventory.store_id desc;

/*
QUESTION 5 - We want to make sure you folks have a good handle on who your customers are. 
Please provide a list of all customer names, which store they go to, whether or not they are currently active, and their full addresses – street address, city, and country. 
*/
select
customer.store_id as 'Store ID',
customer.first_name as 'First Name',
customer.last_name as 'Last Name',
Case
    when customer.active = 1 then 'active'
    when customer.active = 0 then 'Inactive'
else 'unknown status'
end as 'customer status',
address.address,
city.city,
country.country
from customer
inner join address
on customer.address_id = address.address_id
inner join city
on address.city_id = city.city_id
inner join country
on city.country_id = country.country_id
order by customer.last_name ;

/*
QUESTION 6 - We would like to understand how much your customers are spending with you, and also to know who your most valuable customers are. 
Please pull together a list of customer names, their total lifetime rentals, and the sum of all payments you have collected from them. 
It would be great to see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

select
customer.customer_id,
customer.first_name,
customer.last_name,
count(payment.rental_id) as 'Total rented',
sum(payment.amount) as 'total amount'
from customer
inner join payment
on customer.customer_id = payment.customer_id
group by
customer.customer_id
order by sum(payment.amount) desc;

/*
QUESTION 7 - My partner and I would like to get to know your board of advisors and any current investors. 
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, it would be good to include which company they work with.

*/

select 'investor' as title, investor.first_name, investor.last_name, investor.company_name as 'company'from investor
union
select 'advisor' as title, advisor.first_name, advisor.last_name, 'N/A' as company from advisor;

/*
QUESTION 8 - We're interested in how well you have covered the most-awarded actors. Of all the actors with three types of awards, for what % of them do we carry a film?
 And how about for actors with two types of awards? 
 Same questions. Finally, how about actors with just one award? 
 */
 select
 count(actor_id)/count(actor_award_id) as "perct%",
 case
	when actor_award.awards = 'Emmy, Oscar, Tony ' then '3 award'
    when actor_award.awards in ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') then '2 awards'
    else '1 award'
end as number_of_awards
from actor_award
group by case 
		when actor_award.awards = 'Emmy, Oscar, Tony ' then '3 award'
		when actor_award.awards in ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') then '2 awards'
    else '1 award'
end



