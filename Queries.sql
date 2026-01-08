
-- 1. Full table selection scan with mutliway joins. 
select fs.SaleID,fs.QuantitySold,fs.TotalSaleAmount,dp.ProductName,dp.ProductCategory,dp.ProductPrice,dd.Date,dd.DayOfWeek,dc.CustomerID,dc.CustomerName,dc.CustomerSegment,dc.Country,dc.City from FactSales fs
  join DimProduct dp on dp.ProductID = fs.ProductID
  join DimDate dd on dd.DateID = fs.DateID
  join DimCustomer dc on dc.CustomerID = fs.CustomerID;



-- 2. Aggregation + multiway join and group by and sort by query:

-- this selects the best-performing sold categories and what which day it is mostly sold by grouping the data by ProductCategory and DayOfWeek at which an items is sold.

  select dp.ProductCategory as "Category",dd.DayOfWeek,count(fs.SaleID) as "number of sales", round(sum(fs.TotalSaleAmount),2) as "total sales", count(dc.CustomerID) as "number of customers",from FactSales as fs
· join DimProduct dp on dp.ProductID = fs.ProductID
· join DimCustomer dc on dc.CustomerID = fs.CustomerID
· join DimDate dd on dd.DateID = fs.DateID
· group by dp.ProductCategory,dd.DayOfWeek
· order by "total sales" desc;



-- 3. multiway join with a nested aggregation to filter and sort sales records that exceed the average total sale amount

select fs.SaleID,fs.QuantitySold,fs.TotalSaleAmount,dp.ProductName,dp.ProductCategory,dp.ProductPrice,dd.Date,dd.DayOfWeek,dc.CustomerID,dc.CustomerName,dc.CustomerSegment,dc.Country,dc.City from FactSales fs
join DimProduct dp on dp.ProductID = fs.ProductID
join DimDate dd on dd.DateID = fs.DateID
join DimCustomer dc on dc.CustomerID = fs.CustomerID
where (select avg(fs_2.TotalSaleAmount) from FactSales fs_2) < fs.TotalSaleAmount
order by QuantitySold desc, TotalSaleAmount desc;



-- This query uses a window function to rank days of the week based on total sales, aggregating sales data and customer interactions within a specified period.
WITH SalesSummary AS (
      SELECT
        dd.DayOfWeek,
        COUNT(DISTINCT fs.ProductID) AS NumberOfProducts, -- count total unique products sold
        COUNT(DISTINCT fs.CustomerID) AS NumberOfCustomers, -- count total unique customers
        SUM(fs.QuantitySold) AS TotalProductsSold, -- get the total Quantity Sold
        SUM(fs.TotalSaleAmount) AS TotalSales -- get the total Sales amount
      FROM FactSales fs
      JOIN DimDate dd ON dd.DateID = fs.DateID
      GROUP BY dd.DayOfWeek -- group by day of week 
    ),
    -- now lets rank the Days of the week over Total Amount of sales so that we get the first two ranks
    RankedSales AS (
      SELECT
        *,
        RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
      FROM SalesSummary
    )
    SELECT
      DayOfWeek,
      NumberOfProducts,
      NumberOfCustomers,
      TotalProductsSold,
      TotalSales,
      SalesRank
    FROM RankedSales
    WHERE SalesRank IN (1, 2); -- get the first two best performed days of week. 