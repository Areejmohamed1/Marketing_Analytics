SELECT * FROM customer_journey

WITH DuplicateRecords AS(
	SELECT
		JourneyID,
		CustomerID,
		ProductID,
		VisitDate,
		Stage,
		Action,
		Duration,
		ROW_NUMBER() OVER(
			PARTITION BY CustomerID,ProductID,VisitDate,Stage,Action
			ORDER BY JourneyID
		) AS row_num
	FROM customer_journey
)

SELECT * FROM DuplicateRecords
WHERE row_num > 1
ORDER BY JourneyID


-- final cleaned data
SELECT 
    JourneyID,  
    CustomerID, 
    ProductID,  
    VisitDate, 
    Stage,  
    Action, 
    COALESCE(Duration, avg_duration) AS Duration 
FROM 
    (
        -- Subquery to process and clean the data
        SELECT 
            JourneyID,  
            CustomerID, 
            ProductID,  
            VisitDate, 
            UPPER(Stage) AS Stage,
            Action,  
            Duration,  
            AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,  -- Calculates the average duration for each date, using only numeric values
            ROW_NUMBER() OVER (
                PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action  -- Groups by these columns to identify duplicate records
                ORDER BY JourneyID  -- Orders by JourneyID to keep the first occurrence of each duplicate
            ) AS row_num  -- Assigns a row number to each row within the partition to identify duplicates
        FROM 
            dbo.customer_journey 
    ) AS subquery  
WHERE 
    row_num = 1;  