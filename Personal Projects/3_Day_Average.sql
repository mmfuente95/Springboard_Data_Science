/* Using this dataset, show the SQL query to find the rolling 3 day average transaction amount for each day in January 2021. */
  
WITH data AS (
SELECT DATE(transaction_time) as date, transaction_amount as value
	FROM transactions
ORDER BY 
	transaction_time),
    
averages AS (
select date, AVG(value) AS transvalue, COUNT(*) as transcount from data
GROUP BY date
ORDER BY date),

averagesP1 AS (SELECT date+1 AS dateP1, transvalue AS tval1, transcount AS tcnt1 from averages),

averagesP2 AS (SELECT date+2 AS dateP2, transvalue AS tval2, transcount AS tcnt2 from averages),

totals AS (SELECT * FROM averages AS AP0
LEFT JOIN averagesP1 AS AP1 ON AP0.date = AP1.dateP1
LEFT JOIN averagesP2 AS AP2 ON AP0.date = AP2.dateP2)

SELECT date, ((transvalue*transcount)+(tval1*tcnt1)+(tval2*tcnt2))/(transcount+tcnt1+tcnt2) AS threedayroling FROM totals

-- SELECT * FROM DATA
-- # I WANTED TO USE THE FOLLOWING FORM BELOW BUT THIS SQL DIALECTED WAS NOT WORKING WITH RANGE 
 -- AVG(value) OVER (ORDER BY date RANGE BETWEEN INTERVAL '2' DAY PRECEDING AND CURRENT ROW) 
