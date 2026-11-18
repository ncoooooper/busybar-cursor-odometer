"""Read daily screen travel collected by the local macOS cursor sampler."""
import json
from pathlib import Path
from datetime import date,timedelta
from serve import page
INTERVAL=2
def snapshot(o,m):
    state=json.loads(Path(o["totals_file"]).expanduser().read_text());today=date.today();yesterday=today-timedelta(days=1)
    current=float(state.get(today.isoformat(),0));prior=float(state.get(yesterday.isoformat(),0))
    return dict(state="Calibrated screen travel",key=str(int(current//1000)),pages=[
      page("CURSOR TODAY",f"{current/1000:.1f}m","Accumulated on displays","No cursor positions saved"),
      page("YESTERDAY",f"{prior/1000:.1f}m",f"Difference {(current-prior)/1000:+.1f} m","Local calendar day")])
