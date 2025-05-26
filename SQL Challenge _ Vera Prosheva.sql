use BrainsterDB

--Change existing procedure (NewMbankTransaction) to check if the
--new transaction will satisfy the allowed overdraft for that account (outcome transaction)
--• Example: current balance 1000 , allowed overdraft 10.000
--• Test case 1:
--• Ok test: -5.000 , +5000
--• Not ok: -15.000
--• Test case 2:
--• Ok test: -11.000 , +200000
--• Not ok: -11.001

CREATE OR ALTER PROCEDURE dbo.NewMbankTransaction (@CustomerId int, @CurrencyCode int, @TransactionDate date, @Amount int, @PurposeCode int)
AS
BEGIN

-- external
--declare @CustomerId int = 1
--declare @CurrencyCode int = 807
--declare @TransactionDate date = '2000.01.01'
--declare @Amount int = 43750.00
--declare @PurposeCode int = 101

-- internal ariables
declare @AccountId int
declare @MBankLocationId int
declare @AllowedOverdraft decimal(18,2)
declare @CurrentBalance decimal(18,2)

select @MBankLocationId = ID
from dbo.Location
where Name like 'M-bank'

select @AccountId = a.ID
from dbo.Account as a
inner join dbo.Currency as c on c.ID = a.CurrencyId
where a.CustomerId = @CustomerId and c.Code = @CurrencyCode

select @AccountId as AccountId

select @AllowedOverdraft = a.AllowedOverdraft, @CurrentBalance = a.CurrentBalance
from dbo.Account as a
where a.CustomerId = @CustomerId and a.ID = @AccountId

select @AllowedOverdraft as AllowedOverdraft
select @CurrentBalance as CurrentBalance

IF abs(@CurrentBalance + @Amount) > (@AllowedOverdraft)
BEGIN
	select 'Transaction is not ok' as Message
END
ELSE 
BEGIN
	Insert into dbo.AccountDetails (AccountId, LocationId, TransactionDate, Amount, PurposeCode)
	values (@AccountId, @MBankLocationId, @TransactionDate, @Amount, @PurposeCode)

	declare @NewBalance decimal(18,2)

	select @NewBalance = sum(Amount)
	from dbo.AccountDetails
	where AccountId = @AccountId

	select @NewBalance as NewBalance
END
END

-- how to call the procedure
EXEC dbo.NewMbankTransaction @CustomerId = 1, @CurrencyCode = 807, @TransactionDate = '2000.01.01', @Amount = 50000.00, @PurposeCode = 101

