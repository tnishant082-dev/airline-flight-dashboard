-- portfolio KPIs (matches dashboard: on-time among operable flights)
SELECT
    COUNT(*) AS flights,
    ROUND(100.0 * AVG(CASE WHEN Cancelled = 0 AND Diverted = 0 THEN IsOnTimeArr END), 1) AS on_time_pct,
    ROUND(AVG(CASE WHEN ArrDelay < 0 THEN 0 ELSE ArrDelay END), 1) AS avg_arr_delay_min,
    ROUND(100.0 * AVG(Cancelled), 1) AS cancel_pct,
    SUM(IsDelayedArr) AS delayed_arr_15,
    ROUND(SUM(Distance) / 1000000.0, 1) AS distance_m_mi
FROM stg_fact_flights;

-- airline scorecard
SELECT
    a.AirlineCode,
    a.AirlineName,
    COUNT(*) AS flights,
    ROUND(100.0 * AVG(CASE WHEN f.Cancelled = 0 AND f.Diverted = 0 THEN f.IsOnTimeArr END), 1) AS on_time_pct,
    ROUND(AVG(CASE WHEN f.ArrDelay < 0 THEN 0 ELSE f.ArrDelay END), 1) AS avg_arr_delay,
    ROUND(100.0 * AVG(f.Cancelled), 1) AS cancel_pct,
    SUM(f.IsDelayedArr) AS delayed_arr
FROM stg_fact_flights f
JOIN stg_dim_airline a ON f.AirlineKey = a.AirlineKey
GROUP BY a.AirlineCode, a.AirlineName
ORDER BY flights DESC;

-- delay minute mix
SELECT 'LateAircraft' AS cause, SUM(LateAircraftDelay) AS delay_min FROM stg_fact_flights
UNION ALL SELECT 'Carrier', SUM(CarrierDelay) FROM stg_fact_flights
UNION ALL SELECT 'NAS', SUM(NASDelay) FROM stg_fact_flights
UNION ALL SELECT 'Weather', SUM(WeatherDelay) FROM stg_fact_flights
UNION ALL SELECT 'Security', SUM(SecurityDelay) FROM stg_fact_flights
ORDER BY delay_min DESC;

-- daily on-time trend
SELECT
    d.Date,
    COUNT(*) AS flights,
    ROUND(100.0 * AVG(CASE WHEN f.Cancelled = 0 AND f.Diverted = 0 THEN f.IsOnTimeArr END), 1) AS on_time_pct,
    SUM(f.Cancelled) AS cancellations
FROM stg_fact_flights f
JOIN stg_dim_date d ON f.DateKey = d.DateKey
GROUP BY d.Date
ORDER BY d.Date;

-- top origin airports by volume + dep delay rate
SELECT
    a.AirportCode,
    a.City,
    COUNT(*) AS departures,
    ROUND(100.0 * AVG(f.IsDelayedDep), 1) AS dep_delay_pct,
    ROUND(AVG(CASE WHEN f.DepDelay < 0 THEN 0 ELSE f.DepDelay END), 1) AS avg_dep_delay
FROM stg_fact_flights f
JOIN stg_dim_airport a ON f.OriginAirportKey = a.AirportKey
GROUP BY a.AirportCode, a.City
ORDER BY departures DESC
LIMIT 15;

-- dep delay share by time block
SELECT
    DepTimeBlk,
    COUNT(*) AS flights,
    ROUND(100.0 * AVG(IsDelayedDep), 1) AS dep_delay_pct
FROM stg_fact_flights
WHERE DepTimeBlk IS NOT NULL
GROUP BY DepTimeBlk
ORDER BY DepTimeBlk;
