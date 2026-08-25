SELECT *
FROM engagement_data

SELECT 
	EngagementID,
	ContentID,
	CampaignID,
	ProductID,
	Upper(REPLACE(ContentType,'Socialmedia','Social Media')) AS ContentType,
	LEFT(ViewsClicksCombined,charindex('-',ViewsClicksCombined)-1) AS Views,
	RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - charindex('-',ViewsClicksCombined)) AS Clicks,
	Likes,
	FORMAT(CONVERT(DATE,EngagementDate), 'dd.MM.yyyy') AS EngagementDate
FROM engagement_data
WHERE ContentType != 'Newsletter'