WITH base AS (
    SELECT
        CASE WHEN commodity IN ('Maize','Maize (white)','Maize (white, dry)')
             THEN 'Maize (grain)' ELSE commodity END AS commodity_group,
        year,
        price_per_std
    FROM prices
    WHERE pricetype = 'Retail' AND unit_type = 'kg' AND price_per_std IS NOT NULL
),
yearly AS (
    SELECT commodity_group, year, ROUND(AVG(price_per_std), 2) AS avg_price
    FROM base
    WHERE commodity_group IN ('Maize (grain)','Beans (dry)','Sugar','Wheat flour')
    GROUP BY commodity_group, year
)
SELECT
    commodity_group, year, avg_price,
    LAG(avg_price) OVER (PARTITION BY commodity_group ORDER BY year) AS prev_year_price,
    ROUND(100.0 * (avg_price - LAG(avg_price) OVER (PARTITION BY commodity_group ORDER BY year))
          / LAG(avg_price) OVER (PARTITION BY commodity_group ORDER BY year), 1) AS yoy_pct
FROM yearly
ORDER BY commodity_group, year;