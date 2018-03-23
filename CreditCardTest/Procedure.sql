CREATE PROC spCreditCardTest
AS


BEGIN

UPDATE Sales.CreditCard
set ValidCard = Sales.fnCreditCardTest(CardNumber)
where ValidCard is null

END
Go

select * from sales.CreditCard