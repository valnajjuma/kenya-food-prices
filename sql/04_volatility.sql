WITH monthly AS (
    SELECT commodity, year, month, AVG(price_per_std) AS p
    FROM prices
    WHERE pricetype = 'Retail' AND unit_type = 'kg' AND price_per_std IS NOT NULL
    GROUP BY commodity, year, month
)
SELECT commodity,
       COUNT(*) AS months,
       ROUND(AVG(p), 1) AS mean_price,
       ROUND(SQRT(AVG(p*p) - AVG(p)*AVG(p)), 1) AS std_dev,
       ROUND(100.0 * SQRT(AVG(p*p) - AVG(p)*AVG(p)) / AVG(p), 1) AS cv_pct
FROM monthly
GROUP BY commodity
HAVING COUNT(*) >= 36
ORDER BY cv_pct DESC
LIMIT 10;