select * from dbo.products

select 
	ProductID,
	ProductName,
	Price,

	CASE 
		WHEN Price < 50 then 'Low'
		WHEN Price BETWEEN 50 AND 200 THEN 'Medium'
		ELSE 'High'
	END AS PriceCategory
FROM dbo.products
