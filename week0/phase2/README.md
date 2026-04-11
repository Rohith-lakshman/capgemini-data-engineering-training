\# Phase 2 – SQL to PySpark Bridge



\## Objective

Bridge SQL concepts with PySpark using real-world datasets and operations like joins, aggregations, and filtering.



\## Project Structure

phase2/

&#x20; samples/

&#x20;   customers.csv

&#x20;   orders.csv

&#x20; outputs/

&#x20; pyspark\_code.py

&#x20; run\_sql.py

&#x20; phase2.sql

&#x20; README.md



\## Datasets

customers: customer\_id, customer\_name, city  

orders: order\_id, customer\_id, amount  



\## Tasks

1\. Total order amount per customer  

2\. Top 3 customers by spend  

3\. Customers with no orders  

4\. City-wise revenue  

5\. Average order amount  

6\. Customers with >1 order  

7\. Sort by total spend  



\## Run



PySpark:

venv\\Scripts\\activate  

python pyspark\_code.py  



SQL:

python run\_sql.py  



\## Learning

\- SQL to PySpark mapping  

\- Joins and aggregations  

\- Real dataset handling  



\## Conclusion

Understood how SQL queries translate into PySpark transformations.

