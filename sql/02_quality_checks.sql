-- Row counts vs expected sample
SELECT 'fact_flights' AS tbl, COUNT(*) AS row_ct FROM stg_fact_flights
UNION ALL
SELECT 'dim_airline', COUNT(*) FROM stg_dim_airline
UNION ALL
SELECT 'dim_airport', COUNT(*) FROM stg_dim_airport
UNION ALL
SELECT 'dim_date', COUNT(*) FROM stg_dim_date
UNION ALL
SELECT 'dim_route', COUNT(*) FROM stg_dim_route;

-- orphan keys
SELECT COUNT(*) AS orphan_airline
FROM stg_fact_flights f
LEFT JOIN stg_dim_airline a ON f.AirlineKey = a.AirlineKey
WHERE a.AirlineKey IS NULL;

SELECT COUNT(*) AS orphan_origin
FROM stg_fact_flights f
LEFT JOIN stg_dim_airport a ON f.OriginAirportKey = a.AirportKey
WHERE a.AirportKey IS NULL;

-- nulls that matter for delay KPIs
SELECT
    SUM(CASE WHEN DepTime IS NULL THEN 1 ELSE 0 END) AS null_dep_time,
    SUM(CASE WHEN ArrDelay IS NULL THEN 1 ELSE 0 END) AS null_arr_delay,
    SUM(CASE WHEN TailNumber IS NULL OR TailNumber = '' THEN 1 ELSE 0 END) AS blank_tail,
    SUM(Cancelled) AS cancelled_flights,
    SUM(Diverted) AS diverted_flights
FROM stg_fact_flights;

-- check cancelled share by carrier
SELECT
    a.AirlineCode,
    COUNT(*) AS flights,
    ROUND(100.0 * SUM(f.Cancelled) / COUNT(*), 1) AS cancel_pct
FROM stg_fact_flights f
JOIN stg_dim_airline a ON f.AirlineKey = a.AirlineKey
GROUP BY a.AirlineCode
ORDER BY cancel_pct DESC;

-- extreme delay outliers
SELECT COUNT(*) AS dep_delay_over_300
FROM stg_fact_flights
WHERE DepDelay > 300;
