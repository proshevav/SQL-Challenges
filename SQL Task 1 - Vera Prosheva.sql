use BrainsterDB

--1. Create query that will contain All possible combinations between Customer First Names and Employee last names.

select * from dbo.Customer
select * from dbo.Employee

select c.FirstName, e.LastName
from dbo.Customer as c
cross join dbo.Employee as e

--2. Put the resultset in new table called MyNames. Table should have only 1 column – MyFullName

create table #MyNames (MyFullName nvarchar(255))

insert into #MyNames (MyFullName)
select concat(c.FirstName, ' ', e.LastName) AS MyFullName
from dbo.Customer as c
cross join dbo.Employee as e

select * from #MyNames

--3. Prepare query that will read the data stored in MyNames table and provide 2 columns as resultset – FirstName and LastName

select *, left(MyFullName, charindex(' ', MyFullName) - 1) as FirstName, 
		  right(MyFullName, len(MyFullName) - charindex(' ', MyFullName)) as LastName
from #MyNames
