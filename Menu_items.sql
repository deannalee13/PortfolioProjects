-- 1. View the menu_items table.

use restaurant_db;

select * from menu_items;

-- 2. Find the number of items on the menu.

select count(*) from menu_items;

-- 3. What are the least and most expensive items on the menu?

select * from menu_items
order by price;

select * from menu_items
order by price desc;

-- 4. How many Italian dishes are on the menu?

select count(*) from menu_items
where category='Italian';

-- 5. What are the least and most expensive Italian dishes on the menu?

select *
from menu_items
where category='Italian'
order by price;


select *
from menu_items
where category='Italian'
order by price desc;

-- 6. How many dishes are in each category?

select category,count(menu_item_id) as num_dishes
from menu_items
group by category;

-- 7. What is the average dish price within each category?

select category, avg(price) as avg_price
from menu_items
group by category;




 