 ## Q3
 SELECT COUNT(t2.CUS_GENDER) as No_Of_Customers, t2.CUS_GENDER FROM 
 (
 	SELECT t1.CUS_ID,t1.CUS_NAME,t1.CUS_GENDER,t1.ORD_AMOUNT FROM
	(
		SELECT  `order`.*, customer.CUS_NAME,customer.CUS_GENDER   from `order` 
		INNER JOIN  customer WHERE  `order`.CUS_ID =customer.CUS_ID HAVING  `order`.ORD_AMOUNT>=3000
	) AS t1 GROUP BY t1.CUS_ID
 ) AS t2 GROUP BY t2.CUS_GENDER;
 
 
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

##=======================================================================================================##
## Q4

SELECT  cus_name, pro_name,ord_id,ord_date
FROM product AS p, supplier_pricing AS sp,
`order` AS ORD, customer AS cus
WHERE 
cus.CUS_ID = 2 AND
cus.CUS_ID = ORD.CUS_ID AND
p.PRO_ID = sp.PRO_ID AND
ORD.PRICING_ID = sp.PRICING_ID;

#Q5

SELECT sup.SUPP_ID, SUPP_NAME,SUPP_CITY,SUPP_PHONE FROM supplier AS sup
INNER JOIN
(SELECT * FROM supplier_pricing GROUP BY SUPP_ID HAVING COUNT(SUPP_ID)>1) AS sp
ON
sup.SUPP_ID = SP.SUPP_ID;

#Q6

SELECT category.CAT_ID,category.CAT_NAME, t3.PRO_NAME, MIN(t3.MIN_PRICE) AS Min_Price FROM category
INNER JOIN
	(
		 SELECT product.CAT_ID,product.PRO_NAME, t2.* FROM product
		 INNER JOIN(SELECT PRO_ID,MIN(SUPP_PRICE) AS MIN_PRICE FROM supplier_pricing GROUP BY PRO_ID) 
 			AS t2  WHERE t2.PRO_ID = product.PRO_ID
	) AS t3	WHERE t3.CAT_ID = category.CAT_ID 
 
group by t3.CAT_ID; 

#Q7

SELECT prod.PRO_ID,prod.PRO_NAME FROM `order` AS ord
INNER JOIN  supplier_pricing AS sp
ON sp.PRICING_ID  = ORD. PRICING_ID
INNER JOIN product AS prod
ON prod.PRO_ID = sp.PRO_ID WHERE ORD.ORD_DATE>'2021-10-05';


#Q8

SELECT * FROM customer AS c WHERE (c.CUS_NAME LIKE  'A%' OR c.CUS_NAME LIKE  '%A');

#Q9

select report.supp_id,report.supp_name,report.Average,
CASE
	WHEN report.Average =5 THEN 'Excellent Service'
    	WHEN report.Average >4 THEN 'Good Service'
    	WHEN report.Average >2 THEN 'Average Service'
    	ELSE 'Poor Service'
END AS Type_of_Service from 

(select final.supp_id, supplier.supp_name, final.Average from 
		(
			select test2.supp_id, sum(test2.rat_ratstars)/count(test2.rat_ratstars) as Average from 
			(	
				select supplier_pricing.supp_id, test.ORD_ID, test.RAT_RATSTARS from supplier_pricing 
				inner join 
					(
						select `order`.pricing_id, rating.ORD_ID, rating.RAT_RATSTARS from `order` 
						inner join rating on rating.`ord_id` = `order`.ord_id 
					) as test on test.pricing_id = supplier_pricing.pricing_id
			) as test2 group by supplier_pricing.supp_id
		) as final 
		inner join 
		supplier where final.supp_id = supplier.supp_id) AS report;
        
        
        call rating_procedure();



