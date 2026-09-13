"""Print portfolio KPIs from curated CSVs (no notebook needed)."""
from pathlib import Path
import pandas as pd

data = Path(__file__).resolve().parents[1] / "data"
flights = pd.read_csv(data / "fact_flights.csv")
op = flights[(flights["Cancelled"] == 0) & (flights["Diverted"] == 0)]
print("flights", len(flights))
print("on_time_pct", round(op["IsOnTimeArr"].mean() * 100, 1))
print("avg_arr_delay", round(flights["ArrDelay"].clip(lower=0).mean(), 1))
print("cancel_pct", round(flights["Cancelled"].mean() * 100, 1))
