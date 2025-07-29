

--create a table 
drop table if exists books;

create table books(
Book_ID serial primary key,
Title varchar(100),
Author varchar(100),
Genre varchar(50),
Published_Year int,
Price numeric(10,2),
Stock int 
);
 select *from books;

--create table of customers

create table customers(
customer_id serial primary key,
name varchar(100),
email varchar(100),
phone varchar(15),
city varchar(100),
country varchar(100)

);

-- create table for orders
drop table if exists orders;

create table orders(
order_id serial primary key,
customer_id serial references customers(customer_id),
book_id int references books(book_id),
order_date date ,
quantity int,
total_amount numeric(10,2)
);


select *from books;
select *from customers;
select *from orders;



-- import data into books table 
copy books FROM 'E:/pgadmin/All Excel Practice Files/Books.csv' WITH (FORMAT csv, HEADER);

-- import data from customers table 
copy customers FROM 'E:/pgadmin/All Excel Practice Files/customers.csv' WITH (FORMAT csv, HEADER);

--import data from orders
copy orders FROM 'E:/pgadmin/All Excel Practice Files/orders.csv' WITH (FORMAT csv, HEADER);

--questions
--1. retrive all books in the 'friction'genre:

select *
from books 
where Genre='Fiction';

--2. find books published after the year 1950
select * from books
where published_year>1950;

--3. list all the customers from canada; 

select*from customers
where country ='Canada'
;

--4. show orders palced in november 2023

select*from orders
where order_date between '2023-11-01' and '2023-11-30';

--5. retrieve the total stock of books available 
select sum(stock)
as total_stock 
from books;

--6. find the details of the most expensive book
select* from books order by price desc
limit 1;

--7. show all customers who ordered more than 1 quantity of a book;
select *from orders 
where quantity>1;

--8.retrive all orders where the total amount exceeds $20;
select *from orders
where total_amount>20;

--9.list all the genre available in the book store

select distinct genre from books;

-- find the books with the lowest stock

select *from books
order by stock asc limit 2;

--11 calculate the total revenue genrated by all orders\
select sum(total_amount)
as total_revenue
from orders;

-- advance quaries

--12 retrive the total no of books sold for each genre:

select *from books;
select * from orders;

select g.genre ,sum(o.quantity) as total_booksold from books g
join
orders o
on o.book_id= g.book_id
group by g.genre;


--13. find the average price of books in the 'fantasey' genre;

select avg(price) as avg_price
from books
where genre = 'Fantasy';

--14. list the customers who have placed at least 2 orders
select customer_id , count(customer_id) as order_count from orders
group by customer_id
having count(order_id)>=2; 

--15. find the most frequently orderd book
select book_id, count(order_id) as order_Count
from orders
group by book_id
order by order_count desc
limit 1;

--15. show the top 3 most expensice books of 'fantasay genre'

select * from books
where genre ='Fantasy'
order by price desc limit 3;

--17. retrive the total quantity of books sold by each author 
select p.author,sum(o.quantity) as total_books
from orders o
join books p
on o.book_id = p.book_id
group by p.author ;

--18. list the customers who spent over $30 are loacted 
select distinct c.city
from orders o
join customers c
on o.customer_id= c.customer_id
where o.total_amount>30;

--19. find the customers who spent the most on orders 
select * from orders;
select c.customer_id ,c.name , sum(o.total_amount)
as total_spend 
from orders o 
join customers c 
on  o.customer_id = c.customer_id
group by c.customer_id,c.name
order by total_spend desc
limit 10;

--20 calcualte the stock remaining after fulfilling all orders:

select b.book_id,b.title,b.stock, coalesce(sum(quantity),0) as order_quantity
from books b 
left join
orders o
on b.book_id=o.book_id
group by b.book_id;

