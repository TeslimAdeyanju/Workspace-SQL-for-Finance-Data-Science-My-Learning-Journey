


SELECT 
   MAX(ratio)
FROM ( SELECT
      customername,
      SUM(amount) AS total_spend,
      COUNT(customername) AS number_of_transaction,
      ROUND(SUM(amount)/COUNT(customername),2) AS ratio
   FROM customers
   JOIN payments
   USING (customerNumber)
   GROUP BY
      customername
   ORDER BY
      number_of_transaction) AS a




