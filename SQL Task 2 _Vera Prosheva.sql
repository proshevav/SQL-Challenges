use BrainsterDB

--Prepare query with 2 most often used locations for transactions for the male customer and for the female customers
--Columns: Gender, Location, Total Transactions in This Year
select * from dbo.Location

with cte_totalTransactions as (
	select c.Gender as Gender, 
		   l.Name as Location, 
		   count(ad.ID) as TotalTransactionsInThisYear,
	       ROW_NUMBER() over (partition by c.Gender order by count(ad.ID) DESC) as rn
	from dbo.AccountDetails as ad
	inner join dbo.Account as a on a.ID = ad.AccountId
	inner join dbo.Customer as c on c.ID = a.CustomerId
	inner join dbo.Location as l on l.ID = ad.LocationId
	group by c.Gender, l.Names
) select Gender, Location, TotalTransactionsInThisYear
from cte_totalTransactions
where rn < 3
order by Gender, TotalTransactionsInThisYear desc