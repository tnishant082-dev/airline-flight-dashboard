# Airline Flight On-Time Performance Dashboard

End-to-end data analyst project: US airline on-time performance for January 2024 — Excel data dictionary & cleaning log, Python EDA, SQL KPI queries, and a Power BI executive dashboard.

**Open in Power BI Desktop:** [`dashboard/Airline-Flight-Dashboard.pbip`](./dashboard/Airline-Flight-Dashboard.pbip)

---

## Project Overview

Built on US Department of Transportation Bureau of Transportation Statistics (BTS) Airline On-Time Performance data. Operations and planning stakeholders get a single view of network reliability across reporting airlines, hubs, and origin–destination routes.

**Period:** January 2024  
**Model size:** 100,000 flights (stratified sample of 547,271 reporting-carrier rows)  
**Demo video:** [`artifacts/airline-flight-dashboard-demo.mp4`](./artifacts/airline-flight-dashboard-demo.mp4)

---

## Business Problem

Airline and network leaders need fast answers on on-time arrivals, cancellations, and delay drivers across carriers and airports. Raw BTS extracts are large and hard to compare side by side, so decision-makers often lack a shared, filterable view of operational performance.

Without a consolidated workflow it is difficult to:

- Benchmark airlines on reliability and delay
- Spot high-delay hubs and routes
- Separate delay causes (carrier, weather, NAS, late aircraft, security)
- Monitor day-to-day swings in on-time performance

---

## End-to-End Workflow

```text
BTS extract (CSV)
        │
        ▼
   Excel  ──►  data dictionary, cleaning log, summary pivots
        │
        ▼
   Python ──►  null profile, carrier EDA, delay-cause charts
        │
        ▼
   SQL    ──►  staging views, quality checks, KPI queries
        │
        ▼
   Power BI ──► star schema + DAX + multi-page report
```

| Layer | What it does |
|---|---|
| **Excel** | Field dictionary, cleaning decisions, carrier / delay summary tables |
| **Python** | Shape/nulls checks, on-time reconciliation, exploratory charts |
| **SQL** | Staging DDL, orphan/null checks, dashboard KPI reproduction |
| **Power BI** | Star schema model, slicers, five report pages |

---

## Key Metrics

Figures from the included sample.

| Metric | Value |
|---|---|
| Flights | 100,000 |
| On-Time Arrival % | 75.8% |
| Average Arrival Delay | 19.2 min |
| Cancellation Rate | 3.7% (3,718 flights) |
| Delayed Flights (arr ≥15 min) | 23,279 |
| Distance Flown | 83.6M mi |
| Top Delay Cause | Late aircraft (39% of delay minutes) |

---

## Dashboard Pages

| Page | Analytical focus |
|---|---|
| **Executive Overview** | Portfolio KPIs, airline on-time ranking, daily reliability, network snapshot |
| **Airline Scorecard** | Carrier volume, on-time %, delays, and cancellations |
| **Airports & Routes** | Top origins, OD routes, and departure delay rates |
| **Delay Root Cause** | BTS delay-minute mix and time-of-day delay patterns |
| **Daily Trends** | Day-level on-time %, volume, and cancellations |

### Executive Overview
Portfolio KPIs, top airlines by on-time arrival, daily reliability trend, top origin airports, and delay-cause mix.

### Airline Scorecard
Carrier-level scorecard with flight volume, on-time %, average delays, cancellation %, and delayed flight counts.

### Airports & Routes
Top origin airports by volume, busiest OD routes, and departure delay rates by hub.

### Delay Root Cause
Composition of BTS delay minutes (carrier, weather, NAS, security, late aircraft) and departure delay share by time block.

### Daily Trends
Day-by-day on-time arrival %, average arrival delay, flight volume, and cancellations for January 2024.

---

## Key Insights

From the Power BI report (January 2024 sample):

- **Network baseline:** About **76%** of arrivals are on time; average arrival delay is **~19 minutes**; **3.7%** of flights are cancelled.
- **Carrier gaps:** Republic (YX) and Delta (DL) lead on-time %; American (AA) shows the highest average arrival delay; Alaska (AS) has the widest cancellation rate in the sample.
- **Hub & route risk:** ATL leads volume; DEN / ORD / CLT show ~**30%** departure delay rates; LAX–SFO is among the weakest busy routes on on-time %.
- **Delay drivers:** Late aircraft (~**39%**) and carrier (~**32%**) dominate delay minutes; evening blocks (19:00–21:59) carry the highest departure-delay share.
- **Mid-month shock:** Jan **15–16** is the softest window (~**48%** on-time, high cancellations and delay), while Jan **31** is the strongest day (~**91%** on-time).

---

## Business Impact

- Shared view of operational performance across airlines and hubs
- Faster identification of delay drivers and time-of-day risk
- Clearer airline and airport benchmarking for ops and planning reviews
- Evidence base for reliability and schedule discussions
- Repeatable Excel → Python → SQL → Power BI path for monthly BTS refreshes

---

## Data Model / Tools

Star schema:

| Table | Role |
|---|---|
| **FactFlights** | One row per flight; delay flags; BTS delay-cause minutes |
| **DimDate** | Calendar (date table) |
| **DimAirline** | Reporting airline / IATA |
| **DimAirport** | Origin and destination airports (role-playing) |
| **DimRoute** | Origin–destination route keys |

**Source:** [US DOT BTS — Airline On-Time Performance](https://www.transtats.bts.gov/)

**Tools:** Power BI · Power Query · DAX · Python (pandas) · SQL · Excel

---

## Repository Structure

```text
excel/         # data dictionary, cleaning log, summary tables
sql/           # staging DDL, quality checks, KPI queries
notebooks/     # cleaning + EDA notebook
python/        # short KPI helper + optional chart outputs
data/          # star-schema CSV files
dashboard/     # Power BI project (.pbip), SemanticModel, Report
screenshots/   # report page captures
artifacts/     # silent walkthrough video
requirements.txt
README.md
```

---

## How to open / reproduce

1. Clone the repo
2. `pip install -r requirements.txt`
3. Run `notebooks/01_cleaning_eda.ipynb` (or `python python/run_eda_summary.py`)
4. Load CSVs from `data/` into staging tables and run `sql/01_create_staging.sql` → `02_quality_checks.sql` → `03_kpi_queries.sql`
5. Open `dashboard/Airline-Flight-Dashboard.pbip` in Power BI Desktop
6. Set the `pDataFolder` parameter to this repo’s `data/` folder, then refresh

---

## Screenshots

### Executive Overview

![Executive Overview](screenshots/executive-overview.png)

**Insights**

- Portfolio sample shows **100,000** flights with **75.8%** on-time arrivals and **19.2 min** average arrival delay.
- **3.7%** cancellation rate (**3,718** flights) and **23,279** delayed arrivals (≥15 min).
- Daily reliability dips sharply mid-month (around Jan **13–17**), when on-time % falls toward ~**50%** as average delay approaches ~**50 min**.
- Among top-volume origins, **ATL** leads departures (**4,825**) with a relatively better dep-delay profile; **ORD** shows higher average departure delay (**24.7 min**).
- Delay minutes are led by **late aircraft (39%)**, then **carrier (32%)**, **NAS (18%)**, and **weather (10%)**.

### Airline Scorecard

![Airline Scorecard](screenshots/airline-scorecard.png)

**Insights**

- **15** reporting carriers; best on-time is **YX – Republic Airways (82.0%)**; highest volume is **WN – Southwest (21,085 flights)**.
- **DL – Delta** combines strong on-time (**80.9%**) with the lowest cancellation rate in the list (**0.8%**).
- **AA – American** underperforms on reliability (**70.0%** on-time) and posts the highest average arrival delay (**26.2 min**).
- **WN** pairs scale with a competitive delay profile (**12.5 min** avg arrival delay; **76.4%** on-time).
- Cancellation rates vary widely (**0.8%–17.4%**); **AS – Alaska** sits at the high end (**17.4%**), flagging carrier-specific disruption risk.

### Airports & Routes

![Airports & Routes](screenshots/airports-routes.png)

**Insights**

- Network covers **334** airports and **5,412** OD routes; top hub by volume is **ATL (4,825)**.
- Busiest sample route is **OGG–HNL (186 flights, 76.0% on-time, 12.6 min** avg arrival delay).
- Among high-volume routes, **PHX–DEN** is relatively strong (**82.9%** on-time); **LAX–SFO** is weaker (**64.6%** on-time).
- **MCO–ATL** shows elevated average arrival delay (**29.1 min**) among busy routes.
- Departure delay ≥15m rates near **~30%** at **DEN, ORD, and CLT**; **LAX** is lower (~**17%**) among top origins, while **ATL** stays near ~**20%** despite leading volume.

### Delay Root Cause

![Delay Root Cause](screenshots/delay-root-cause.png)

**Insights**

- About **1.7M** delay minutes in the sample; top cause is **late aircraft (39.1% / 682,103 min)**.
- **Carrier** is second (**31.9% / 557,793 min**), then **NAS (18.4%)**, **weather (10.3%)**, and **security (0.3%)**.
- Departure delay share rises through the day — early morning near ~**10%**, peaking above **30%** in the **19:00–21:59** blocks (cascading / late-aircraft effect).
- Controllable and cascading factors (late aircraft + carrier) explain roughly **70%** of delay minutes, prioritizing turnaround and schedule buffering over weather-only narratives.

### Daily Trends

![Daily Trends](screenshots/daily-trends.png)

**Insights**

- Coverage spans **31** days; average **~3,226** flights/day with peak **3,519** on Jan **2**.
- Best day: **Jan 31 (91.3% on-time)**; softest day: **Jan 16 (47.9% on-time)**.
- On-time % and average arrival delay move inversely; mid-January delay spikes approach ~**50 min**.
- Daily flight volume stays relatively stable (~3,000–3,500), so the mid-month reliability drop is not explained by a sudden volume surge.
- Cancellations spike around Jan **10–16** (peaking above **~500**/day near Jan 15–16), aligning with the worst on-time window, then fall back near zero.

---

## Author

[Nishant Tyagi](https://github.com/tnishant082-dev)
