-- Staging tables for BTS Jan 2024 sample (CSV load assumed)
-- MySQL / ANSI-friendly

CREATE TABLE IF NOT EXISTS stg_fact_flights (
    FlightKey           INT PRIMARY KEY,
    DateKey             INT,
    AirlineKey          INT,
    OriginAirportKey    INT,
    DestAirportKey      INT,
    RouteKey            INT,
    FlightNumber        INT,
    TailNumber          VARCHAR(10),
    CRSDepTime          INT,
    DepTime             DECIMAL(6,1),
    DepDelay            DECIMAL(8,2),
    DepDelayMinutes     DECIMAL(8,2),
    CRSArrTime          INT,
    ArrTime             DECIMAL(6,1),
    ArrDelay            DECIMAL(8,2),
    ArrDelayMinutes     DECIMAL(8,2),
    Cancelled           TINYINT,
    CancellationCode    CHAR(1),
    Diverted            TINYINT,
    Distance            DECIMAL(10,2),
    AirTime             DECIMAL(8,2),
    CRSElapsedTime      DECIMAL(8,2),
    ActualElapsedTime   DECIMAL(8,2),
    CarrierDelay        DECIMAL(10,2),
    WeatherDelay        DECIMAL(10,2),
    NASDelay            DECIMAL(10,2),
    SecurityDelay       DECIMAL(10,2),
    LateAircraftDelay   DECIMAL(10,2),
    DepTimeBlk          VARCHAR(12),
    IsDelayedDep        TINYINT,
    IsDelayedArr        TINYINT,
    IsOnTimeArr         TINYINT
);

CREATE TABLE IF NOT EXISTS stg_dim_airline (
    AirlineKey   INT PRIMARY KEY,
    AirlineCode  VARCHAR(8),
    IataCode     VARCHAR(8),
    DotId        INT,
    AirlineName  VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS stg_dim_airport (
    AirportKey  INT PRIMARY KEY,
    AirportId   INT,
    AirportCode VARCHAR(8),
    City        VARCHAR(80),
    State       VARCHAR(8),
    StateName   VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS stg_dim_date (
    Date        DATE,
    DateKey     INT PRIMARY KEY,
    Year        INT,
    Month       INT,
    Day         INT,
    DayOfWeek   INT,
    DayName     VARCHAR(12),
    WeekOfYear  INT,
    MonthName   VARCHAR(12),
    IsWeekend   TINYINT
);

CREATE TABLE IF NOT EXISTS stg_dim_route (
    RouteKey           INT PRIMARY KEY,
    Route              VARCHAR(16),
    Origin             VARCHAR(8),
    Dest               VARCHAR(8),
    FlightCountSample  INT
);

-- operable flights view (excludes cancelled / diverted for on-time)
CREATE OR REPLACE VIEW v_operable_flights AS
SELECT *
FROM stg_fact_flights
WHERE Cancelled = 0
  AND Diverted = 0;
