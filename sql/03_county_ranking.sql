WITH base AS (
    SELECT admin2 AS county, year, price_per_std
    FROM prices
    WHERE pricetype = 'Retail' AND unit_type = 'kg' AND price_per_std IS NOT NULL
      AND commodity IN ('Maize','Maize (white)','Maize (white, dry)')
      AND admin2 IS NOT NULL
      AND year IN (2021, 2025)
),
by_county AS (
    SELECT county,
           AVG(CASE WHEN year = 2021 THEN price_per_std END) AS p2021,
           AVG(CASE WHEN year = 2025 THEN price_per_std END) AS p2025
    FROM base
    GROUP BY county
)
SELECT county, ROUND(p2021,1) AS p2021, ROUND(p2025,1) AS p2025,
       ROUND(100.0 * (p2025 - p2021) / p2021, 1) AS pct_change
FROM by_county
WHERE p2021 IS NOT NULL AND p2025 IS NOT NULL
ORDER BY pct_change DESC
LIMIT 10;