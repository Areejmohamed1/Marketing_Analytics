SELECT
* 
FROM dbo.customers

SELECT 
*
FROM dbo.geography

SELECT 
	C.CustomerID,
	C.CustomerName,
	C.Email,
	C.Gender,
	C.Age,
	G.Country,
	G.City

FROM dbo.customers AS C
LEFT JOIN dbo.geography G
ON C.GeographyID = G.GeographyID
