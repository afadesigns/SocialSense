pip install pytz


from datetime import datetime, timezone
import pytz

cet = pytz.timezone('CET')
utc = pytz.timezone('UTC')

# Example usage:
dt_utc = datetime.now(timezone.utc)
dt_cet = dt_utc.astimezone(cet)
print(dt_utc, "UTC")
print(dt_cet, "CET")
