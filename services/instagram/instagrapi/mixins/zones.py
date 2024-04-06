import sys

try:
    import pytz
except ImportError as e:
    print(f"Error importing pytz: {e}", file=sys.stderr)
    sys.exit(1)

try:
    utc_tz = pytz.timezone('UTC')
    cet_tz = pytz.timezone('CET')
except pytz.UnknownTimeZoneError as e:
    print(f"Error: Unknown timezone: {e}", file=sys.stderr)
    sys.exit(1)

# Get the current time in UTC
now_utc = datetime.now(tz=utc_tz)

# Convert the UTC time to CET
now_cet = now_utc.astimezone(cet_tz)

print("Current time in UTC:", now_utc)
print("Current time in CET:", now_cet)
