CREATE TABLE books (
    book_id         INT PRIMARY KEY,
    title           VARCHAR(100) NOT NULL,
    author          VARCHAR(100) NOT NULL,
    genre           VARCHAR(50),
    published_year  INT,
    price           NUMERIC(8,2) CHECK (price >= 0),
    stock           INT CHECK (stock >= 0)
);

CREATE TABLE customers (
    customer_id  INT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    email        VARCHAR(150) UNIQUE,
    phone        VARCHAR(20),
    city         VARCHAR(100),
    country      VARCHAR(100)
);

CREATE TABLE orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT NOT NULL REFERENCES customers(customer_id),
    book_id       INT NOT NULL REFERENCES books(book_id),
    order_date    DATE NOT NULL,
    quantity      INT CHECK (quantity > 0),
    total_amount  NUMERIC(10,2)
);

--Books Table
select * from books;
--Customers Table
select * from customers;
--Orders Table
select * from orders;


--Project: Online Book Store Analysis Project Using SQL
--Business Analysis Using SQL

---Q1. Retrieve all books in "Fiction" genre
select title as Books, genre as Genre from books where genre='Fiction';

--Q2.Find Books published after year 1950.
select book_id, title as Books 
from books 
where published_year>1950;

--Q3. List all Customers from Canada
select name, email, phone from customers where country='Canada';

--Q4. Show orders placed in November 2023
select count(order_id) as Total_Orders
from orders 
where extract(month from order_date) = 11 and
extract(year from order_date) = 2023;

--Or Another way to extract total order 
select count(order_id) as Total_Orders
from orders 
where order_date>='2023-11-01' and 
order_date<'2023-12-01';

--Q5. Retrieve total stock of books available 
select sum(stock) as Total_Stock from books;

--Q6. Find details of most expensive book
select book_id,author,title, max(price) as Expensive_book 
from books
group by title,book_id,author
order by Expensive_book desc limit 1;


--Q7. Show all customers who ordered more than 1 quantity of a book
select customer_id, order_id, quantity 
from orders 
where quantity>1;


---using Joins
select c.customer_id, c.name, c.email, o.order_id, o.quantity
from customers c
join orders o on c.customer_id=o.order_id
where o.quantity>1
order by o.quantity desc;

--Q8. Retrieve all orders where total amount exceeds $20
select * from orders
where total_amount>20;


--Q9. List all genres available in book store
select distinct genre as "Genres"
from books;

--Count all total no of books available in different genre
select count(book_id) as "Total_Books", genre as "Genres"
from books
group by genre
order by count(book_id) asc;

---Most Purchased Genre Books
select sum(o.quantity) as "Total_Books_Sold", sum(total_amount) as "Total Amount",b.genre 
from orders o
join books b on o.book_id=b.book_id
group by b.genre
order by sum(total_amount) desc;


-- Q10. Find the Books which has lowest stock
select book_id, title, stock from books
where stock=(select min(stock) from books);

