COPY DimCustomer FROM '../back_ups/dimcustomer.csv' (FORMAT 'csv', quote '"', delimiter ',', header 1);
COPY DimDate FROM '../back_ups/dimdate.csv' (FORMAT 'csv', quote '"', delimiter ',', header 1);
COPY DimProduct FROM '../back_ups/dimproduct.csv' (FORMAT 'csv', quote '"', delimiter ',', header 1);
COPY FactSales FROM '../back_ups/factsales.csv' (FORMAT 'csv', quote '"', delimiter ',', header 1);
