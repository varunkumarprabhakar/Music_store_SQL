/* Q1: Who is the senior most employee based on job title? */
select first_name, levels from employee
order by levels desc
limit 1;

/* Q2: Which countries have the most Invoices? */

select billing_country,count(billing_country) from invoice
group by billing_country
order by count(billing_country) desc;

/* Q3: What are top 3 values of total invoice? */

select total from invoice
order by total desc
limit 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city,sum(total) from invoice
group by billing_city
order by sum(total) desc;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select cu.first_name,cu.last_name,sum(inv.total) from customer as cu
join invoice as inv on inv.customer_id=cu.customer_id
group by cu.customer_id
order by sum(total) desc
limit 1;

/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select distinct cu.email,cu.first_name,cu.last_name,genre.name from customer as cu
join invoice on cu.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on invoice_line.track_id=track.track_id
join genre on track.genre_id=genre.genre_id
where genre.name='Rock'
order by cu.email asc;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select tr.name,milliseconds from track as tr
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds desc;

/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

select cu.customer_id,cu.first_name,sum(invl.unit_price*invl.quantity) as total,ar.name,ar.artist_id from customer as cu
join invoice as inv on cu.customer_id=inv.customer_id
join invoice_line as invl on inv.invoice_id=invl.invoice_id
join track on invl.track_id=track.track_id
join album as al on track.album_id=al.album_id
join artist as ar on al.artist_id=ar.artist_id
group by cu.customer_id,total,ar.artist_id
order by total desc;

-- By using CTE:-

with art as (
	select ar.artist_id,ar.name,sum(invl.unit_price*invl.quantity) as sold from invoice_line as invl
	join track on invl.track_id=track.track_id
	join album on track.album_id=album.album_id
	join artist as ar on album.artist_id=ar.artist_id
	group by 1
	order by 3 desc
	limit 1
)

select cu.customer_id,cu.first_name,art.name as artist_name,sum(invl.unit_price*invl.quantity) from customer as cu
join invoice as inv on cu.customer_id=inv.customer_id
join invoice_line as invl on inv.invoice_id=invl.invoice_id
join track on invl.track_id=track.track_id
join album as al on track.album_id=al.album_id
join art on al.artist_id=art.artist_id
group by 1,3
order by 4 desc


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

with sorted as(
	select c.country,ge.name,
	max(ge.name) over(partition by c.country order by c.country) as "popular"
	from customer as c
	join invoice as inv on c.customer_id=inv.customer_id
	join invoice_line as invl on inv.invoice_id=invl.invoice_id
	join track as tr on invl.track_id=tr.track_id
	join genre as ge on tr.genre_id=ge.genre_id
)

select s.country,s.popular from sorted as s
group by 1,2
order by 1

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

select c.first_name,inv.billing_country,sum(inv.total)from customer as c
join invoice as inv on c.customer_id=inv.customer_id
group by 1,2
order by 2






