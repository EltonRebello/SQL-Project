-------- SQL PROJECT (Elton Rebello, JAN22A) --------


--- 1. Write a query to display customer full name with their title (Mr/Ms), both first name and last name are in upper case, 
--- customer email id, customer creation date and display customer’s category after applying below categorization rules:
--- i) IF customer creation date Year <2005 Then Category A 
--- ii) IF customer creation date Year >=2005 and <2011 Then Category B 
--- iii)IF customer creation date Year>= 2011 Then Category C Hint: Use CASE statement, no permanent change in table required.

Use orders;
show tables;

Select concat(CUSTOMER_FNAME,'',CUSTOMER_LNAME) as Customer_Full_name, CUSTOMER_EMAIL, CUSTOMER_CREATION_DATE,
case 
WHEN 'CUSTOMER_CREATION_DATE'  < '2005-01-01' THEN 'A'
WHEN 'CUSTOMER_CREATION_DATE'  >= '2005-01-01' THEN 'B'  
WHEN 'CUSTOMER_CREATION_DATE' < '2011-01-01' THEN 'B'
WHEN 'CUSTOMER_CREATION_DATE'  >= '2011-01-01' THEN 'C'
END as Customers_Category
From orders.online_customer;



--- 2. Write a query to display the following information for the products, which have not been sold: product_id, product_desc,
--- product_quantity_avail, product_price, inventory values (product_quantity_avail*product_price), New_Price after applying discount as per below criteria. 
--- Sort the output with respect to decreasing value of Inventory_Value. 
--- i) IF Product Price > 200,000 then 'apply 20% discount' 
--- ii) IF Product Price > 100,000 then 'apply 15% discount' 
--- iii) IF Product Price =< 100,000 then 'apply 10% discount' 

select PRODUCT_ID, PRODUCT_DESC, PRODUCT_QUANTITY_AVAIL, PRODUCT_PRICE, PRODUCT_QUANTITY_AVAIL*PRODUCT_PRICE as Inventory_Values,
case WHEN PRODUCT_PRICE  > 200000 then PRODUCT_PRICE - PRODUCT_PRICE *20/100
    WHEN PRODUCT_PRICE  > 100000 then PRODUCT_PRICE - PRODUCT_PRICE *15/100
    WHEN PRODUCT_PRICE  <= 100000 then PRODUCT_PRICE - PRODUCT_PRICE *10/100 
END as New_price
from orders.product
order by Inventory_values desc;



--- 3. Write a query to display Product_class_code, Product_class_description, Count of Product type in each productclass,
--- Inventory Value (p.product_quantity_avail*p.product_price). Information should be displayed for only those product_class_code which 
--- have more than 1,00,000 Inventory Value. Sort the output with respect to decreasing value of Inventory_Value.

select pc.PRODUCT_CLASS_CODE, pc.PRODUCT_CLASS_DESC, p.PRODUCT_QUANTITY_AVAIL * p.PRODUCT_PRICE as Inventory_Value
from product_class pc 
join product p 
ON
pc.PRODUCT_CLASS_CODE = p.PRODUCT_CLASS_CODE
where p.PRODUCT_QUANTITY_AVAIL * p.PRODUCT_PRICE > 100000
order by Inventory_value desc;



--- 4. Write a query to display customer_id, full name, customer_email, customer_phone and country of customers who have cancelled all the orders placed by them. 

Select oc.CUSTOMER_ID,concat(CUSTOMER_FNAME,'',CUSTOMER_LNAME) as Customer_Full_name, oc.CUSTOMER_EMAIL, oc.CUSTOMER_PHONE, a.COUNTRY
from online_customer oc
join address a
on
oc.ADDRESS_ID = a.ADDRESS_ID
join order_header oh
on
oh.CUSTOMER_ID = oc.CUSTOMER_ID
where ORDER_STATUS = 'Cancelled';



--- 5. Write a query to display Shipper name, City to which it is catering, num of customer catered by the shipper in the city and number of 
--- consignments delivered to that city for Shipper DHL 

select s.SHIPPER_NAME, a.CITY, oc.CUSTOMER_ID, oh.ORDER_STATUS
from shipper s
join order_header oh
on
s.SHIPPER_ID = oh.SHIPPER_ID
join online_customer oc
on
oh.CUSTOMER_ID = oc.CUSTOMER_ID
join address a
on
oc.ADDRESS_ID = a.ADDRESS_ID
where s.SHIPPER_NAME like "DHL";



--- 6. Write a query to display product_id, product_desc, product_quantity_avail, quantity sold, quantity available and show inventory Status of products as below as per below condition: 
--- a. For Electronics and Computer categories, if sales till date is Zero then show 'No Sales in past, give discount to reduce inventory', 
--- if inventory quantity is less than 10% of quantity sold,show 'Low inventory, need to add inventory', 
--- if inventory quantity is less than 50% of quantity sold, show 'Medium inventory, need to add some inventory', 
--- if inventory quantity is more or equal to 50% of quantity sold, show 'Sufficient inventory' 
--- b. For Mobiles and Watches categories, if sales till date is Zero then show 'No Sales in past, give discount to reduce inventory', 
--- if inventory quantity is less than 20% of quantity sold, show 'Low inventory, need to add inventory', 
--- if inventory quantity is less than 60% of quantity sold, show 'Medium inventory, need to add some inventory', 
--- if inventory quantity is more or equal to 60% of quantity sold, show 'Sufficient inventory' 
--- c. Rest of the categories, if sales till date is Zero then show 'No Sales in past, give discount to reduce inventory', 
--- if inventory quantity is less than 30% of quantity sold, show 'Low inventory, need to add inventory', 
--- if inventory quantity is less than 70% of quantity sold, show 'Medium inventory, need to add some inventory', 
--- if inventory quantity is more or equal to 70% of quantity sold, show 'Sufficient inventory' 

select  p.PRODUCT_ID, p.PRODUCT_DESC, p.PRODUCT_QUANTITY_AVAIL,
case when p.PRODUCT_QUANTITY_AVAIL = 0 THEN 'No Sales in past, give discount to reduce inventory'
when pc.PRODUCT_CLASS_DESC in ('Electronics','Computer') then
case when p.PRODUCT_QUANTITY_AVAIL <= 10 then 'Low inventory, need to add inventory'
when p.PRODUCT_QUANTITY_AVAIL < 50 then 'Medium inventory, need to add some inventory'
when p.PRODUCT_QUANTITY_AVAIL >= 50 then 'Sufficient inventory'
end 
when pc.PRODUCT_CLASS_DESC in ('Mobiles','Watches') then
case when p.PRODUCT_QUANTITY_AVAIL <= 20 then 'Low inventory, need to add inventory'
when p.PRODUCT_QUANTITY_AVAIL < 60 then 'Medium inventory, need to add some inventory'
when p.PRODUCT_QUANTITY_AVAIL >= 60 then 'Sufficient inventory'
end
when pc.PRODUCT_CLASS_DESC not in ('Mobiles','Watches', 'Electronics','Computer') THEN
case when p.PRODUCT_QUANTITY_AVAIL < 30 then 'Low inventory, need to add inventory'
when p.PRODUCT_QUANTITY_AVAIL < 70 then 'Medium inventory, need to add some inventory'
when p.PRODUCT_QUANTITY_AVAIL >= 70 then 'Sufficient inventory'
end
end as Inventory_status from PRODUCT p inner join PRODUCT_CLASS pc on PRODUCT_ID = PRODUCT_ID;



--- 7. Write a query to display order_id and volume of the biggest order (in terms of volume) that can fit in carton id 10

select * from orders.carton;  

SELECT C.CARTON_ID AS Carton_ID,
 (C.LEN*C.WIDTH*C.HEIGHT) as Carton_Volume
FROM ORDERS.CARTON C
WHERE (C.LEN*C.WIDTH*C.HEIGHT) >=
 (SELECT SUM(P.LEN*P.WIDTH*P.HEIGHT*OI.PRODUCT_QUANTITY) 
 AS VOL 
 FROM
ORDERS.ORDER_ITEMS OI
JOIN ORDERS.PRODUCT P 
ON OI.PRODUCT_ID = P.PRODUCT_ID
WHERE OI.ORDER_ID = 10070
ORDER BY (C.LEN*C.WIDTH*C.HEIGHT))
LIMIT 1;



--- 8. Write a query to display customer id, customer full name, total quantity and total value (quantity*price) 
--- shipped where mode of payment is Cash and customer last name starts with 'G'

select oc.CUSTOMER_ID, concat(CUSTOMER_FNAME,'',CUSTOMER_LNAME) as Customer_Full_Name, oi.PRODUCT_QUANTITY, (oi.PRODUCT_QUANTITY * p.PRODUCT_PRICE) as Total_Value
From online_customer oc
join order_header oh
on
oc.CUSTOMER_ID = oh.CUSTOMER_ID
join order_items oi
on
oh.ORDER_ID = oi.ORDER_ID
join product p
on
oi.PRODUCT_ID = p.PRODUCT_ID
where oh.PAYMENT_MODE ='Cash' and oc.CUSTOMER_LNAME like 'G%'
group by CUSTOMER_ID;


--- 9. Write a query to display product_id, product_desc and total quantity of products which are sold together
--- with product id 201 and are not shipped to city Bangalore and New Delhi. Display the output in descending order with respect to the tot_qty.

select p.PRODUCT_ID, p.PRODUCT_DESC, oi.PRODUCT_QUANTITY as Total_Quantity
From product p
Join order_items oi
on
p.PRODUCT_ID = oi.PRODUCT_ID
join order_header oh
on
oi.ORDER_ID = oh.ORDER_ID
join online_customer oc
on 
oh.CUSTOMER_ID = oc.CUSTOMER_ID
join address a 
on 
oc.ADDRESS_ID = a.ADDRESS_ID
WHERE p.PRODUCT_ID = 201 and a.CITY NOT IN('Bangalore','New Delhi');



--- 10. Write a query to display the order_id,customer_id and customer fullname, total quantity of products shipped
---  for order ids which are even and shipped to address where pincode is not starting with "5"

select oi.ORDER_ID, oh.CUSTOMER_ID, concat(CUSTOMER_FNAME,'',CUSTOMER_LNAME) as Customer_Full_Name, oi.PRODUCT_QUANTITY
from Order_items oi
join order_header oh
on
oi.ORDER_ID = oh.ORDER_ID
join online_customer oc
on
oh.CUSTOMER_ID = oc.CUSTOMER_ID
join address a 
on
oc.ADDRESS_ID = a.ADDRESS_ID
where oi.ORDER_ID % 2 = 0 and a.PINCODE Not like '5%';



------- END --------