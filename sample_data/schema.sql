


CREATE TABLE DimCustomer(CustomerID INTEGER, CustomerName VARCHAR, CustomerSegment VARCHAR, Country VARCHAR, City VARCHAR);
CREATE TABLE DimDate(DateID INTEGER, Date VARCHAR, DayOfWeek VARCHAR, "Month" INTEGER, "Year" INTEGER, Quarter INTEGER);
CREATE TABLE DimProduct(ProductID INTEGER, ProductName VARCHAR, ProductCategory VARCHAR, ProductPrice FLOAT);
CREATE TABLE FactSales(SaleID INTEGER, ProductID INTEGER, DateID INTEGER, CustomerID INTEGER, QuantitySold INTEGER, TotalSaleAmount FLOAT);


create index fact_ids_index on FactSales (SaleID);


