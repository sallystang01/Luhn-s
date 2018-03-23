CREATE FUNCTION Sales.fnCreditCardTest
(
@inputCardNumber varchar(20)
)
--       0 = number is not valid 
--       1 = number is valid
RETURNS TINYINT
AS

BEGIN

	DECLARE @testingGrounds TABLE (
	Position INT NOT Null,
	ThisChar CHAR(1) NOT NULL,
	Doubled TinyInt,
	Summed TinyInt
	)
	DECLARE @result TINYINT

	--DECLARE @Doubling nvarchar(50)
	--DECLARE @subtractNine nvarchar(50)
	--DECLARE @addTime nvarchar(50)
	--DECLARE @moduloResult nvarchar(50)

		
	

		SET @inputCardNumber = CAST(@inputCardNumber AS CHAR(20))
INSERT INTO @testingGrounds(Position, ThisChar) 
 SELECT 1, SUBSTRING(@inputCardNumber, 1, 1) UNION ALL 
 SELECT 2, SUBSTRING(@inputCardNumber, 2, 1) UNION ALL 
 SELECT 3, SUBSTRING(@inputCardNumber, 3, 1) UNION ALL 
 SELECT 4, SUBSTRING(@inputCardNumber, 4, 1) UNION ALL 
 SELECT 5, SUBSTRING(@inputCardNumber, 5, 1) UNION ALL 
 SELECT 6, SUBSTRING(@inputCardNumber, 6, 1) UNION ALL 
 SELECT 7, SUBSTRING(@inputCardNumber, 7, 1) UNION ALL 
 SELECT 8, SUBSTRING(@inputCardNumber, 8, 1) UNION ALL 
 SELECT 9, SUBSTRING(@inputCardNumber, 9, 1) UNION ALL 
 SELECT 10, SUBSTRING(@inputCardNumber, 10, 1) UNION ALL 
 SELECT 11, SUBSTRING(@inputCardNumber, 11, 1) UNION ALL 
 SELECT 12, SUBSTRING(@inputCardNumber, 12, 1) UNION ALL 
 SELECT 13, SUBSTRING(@inputCardNumber, 13, 1) UNION ALL 
 SELECT 14, SUBSTRING(@inputCardNumber, 14, 1) UNION ALL 
 SELECT 15, SUBSTRING(@inputCardNumber, 15, 1) UNION ALL 
 SELECT 16, SUBSTRING(@inputCardNumber, 16, 1) UNION ALL 
 SELECT 17, SUBSTRING(@inputCardNumber, 17, 1) UNION ALL 
 SELECT 18, SUBSTRING(@inputCardNumber, 18, 1) UNION ALL 
 SELECT 19, SUBSTRING(@inputCardNumber, 19, 1) UNION ALL 
 SELECT 20, SUBSTRING(@inputCardNumber, 20, 1)
		
if @inputCardNumber NOT LIKE ('%[0-9]%[0-9]%[0-9]%')
		RETURN 2
DELETE FROM @testingGrounds
WHERE ThisChar NOT LIKE ('[0-9]')



DECLARE @tempTable TABLE ( 
 NewPosition INT IDENTITY(1,1), 
 OldPosition INT ) 
INSERT INTO @tempTable (OldPosition)
 SELECT Position 
 FROM @testingGrounds
 ORDER BY Position ASC 

UPDATE  @testingGrounds
SET   Position = t2.NewPosition 
FROM  @testingGrounds t1 
INNER JOIN  @tempTable t2 ON t1.Position = t2.OldPosition 

IF ( SELECT MAX(Position) % 2 FROM @testingGrounds ) = 0 -- evens 
BEGIN 
 UPDATE @testingGrounds
 SET  Doubled = CAST(ThisChar AS TINYINT) * 2 
 WHERE Position % 2 <> 0 
END
ELSE BEGIN -- odds
 UPDATE @testingGrounds
 SET  Doubled = CAST(ThisChar AS TINYINT) * 2 
 WHERE Position % 2 = 0 
END 

UPDATE @testingGrounds
SET  Summed = 
   CASE WHEN Doubled IS NULL 
     THEN CAST(ThisChar AS TINYINT) 
     WHEN Doubled IS NOT NULL AND Doubled <= 9 
     THEN Doubled 
     WHEN Doubled IS NOT NULL AND Doubled >= 10 
     -- sum the digits.  Luckily SQL Server butchers int division...
     THEN (Doubled / 10) + (Doubled - 10) 
   END  
   
   IF ( SELECT SUM(Summed) % 10 FROM @testingGrounds ) = 0
 SET @result = 1
ELSE 
 SET @result = 0

RETURN @result 

END 

ALTER TABLE Sales.CreditCard
ADD ValidCard bit