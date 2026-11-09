"""Switch Noctalia's wallpaper between day and night images in step with
linux-wallpaperengine's day/night cycle.

linux-wallpaperengine resolves `daystarttime=sunrise<offset>` and
`nightstarttime=sunset<offset>` to local hours (NOAA solar equations, see
src/WallpaperEngine/Application/SolarTime.cpp). The scene's scripts show
night while `hour >= nightstarttime || hour <= daystarttime`, comparing
whole hours. This mirrors both so Noctalia changes at the same moment.

Since the result can only change on the hour, this checks once and exits;
a systemd timer runs it at login and at the start of every hour.
"""

import argparse
import calendar
import math
import struct
import subprocess
import sys
import time


def lround(value):
    return int(math.copysign(math.floor(abs(value) + 0.5), value))


def event_minutes(sunrise, lat, lon, julian_day, minutes):
    t = (julian_day + minutes / 1440.0 - 2451545.0) / 36525.0
    rad = math.radians

    mean_long = math.fmod(280.46646 + t * (36000.76983 + t * 0.0003032), 360.0)
    mean_anom = 357.52911 + t * (35999.05029 - 0.0001537 * t)
    ecc = 0.016708634 - t * (0.000042037 + 0.0000001267 * t)
    center = (
        math.sin(rad(mean_anom)) * (1.914602 - t * (0.004817 + 0.000014 * t))
        + math.sin(rad(2.0 * mean_anom)) * (0.019993 - 0.000101 * t)
        + math.sin(rad(3.0 * mean_anom)) * 0.000289
    )
    omega = 125.04 - 1934.136 * t
    app_long = mean_long + center - 0.00569 - 0.00478 * math.sin(rad(omega))
    mean_obliq = 23.0 + (26.0 + (21.448 - t * (46.815 + t * (0.00059 - t * 0.001813))) / 60.0) / 60.0
    obliq = mean_obliq + 0.00256 * math.cos(rad(omega))
    decl = math.asin(math.sin(rad(obliq)) * math.sin(rad(app_long)))

    y = math.tan(rad(obliq / 2.0)) ** 2
    l0 = rad(mean_long)
    m = rad(mean_anom)
    eq_time = 4.0 * math.degrees(
        y * math.sin(2.0 * l0)
        - 2.0 * ecc * math.sin(m)
        + 4.0 * ecc * y * math.sin(m) * math.cos(2.0 * l0)
        - 0.5 * y * y * math.sin(4.0 * l0)
        - 1.25 * ecc * ecc * math.sin(2.0 * m)
    )

    latr = rad(lat)
    cos_ha = math.cos(rad(90.833)) / (math.cos(latr) * math.cos(decl)) - math.tan(latr) * math.tan(decl)
    if cos_ha < -1.0 or cos_ha > 1.0:
        return None

    hour_angle = math.degrees(math.acos(cos_ha))
    solar_noon = 720.0 - 4.0 * lon - eq_time
    return solar_noon - 4.0 * hour_angle if sunrise else solar_noon + 4.0 * hour_angle


def event_time(sunrise, lat, lon, year, month, day):
    midnight = calendar.timegm((year, month, day, 0, 0, 0))
    julian_day = midnight / 86400.0 + 2440587.5

    minutes = event_minutes(sunrise, lat, lon, julian_day, 720.0 - 4.0 * lon)
    for _ in range(2):
        if minutes is None:
            break
        minutes = event_minutes(sunrise, lat, lon, julian_day, minutes)

    return None if minutes is None else midnight + lround(minutes * 60.0)


def local_hours(sunrise, offset_minutes, lat, lon, now):
    today = time.localtime(now)
    event = event_time(sunrise, lat, lon, today.tm_year, today.tm_mon, today.tm_mday)
    if event is None:
        return None

    local = time.localtime(event + lround(offset_minutes * 60.0))
    hours = local.tm_hour + local.tm_min / 60.0 + local.tm_sec / 3600.0
    # slider properties are stored as 32-bit floats
    return struct.unpack("f", struct.pack("f", hours))[0]


def is_night(args, now):
    day_start = local_hours(True, args.day_offset, args.latitude, args.longitude, now)
    night_start = local_hours(False, args.night_offset, args.latitude, args.longitude, now)
    # the wallpaper keeps its defaults when the sun doesn't rise or set
    day_start = args.default_day if day_start is None else day_start
    night_start = args.default_night if night_start is None else night_start

    hour = time.localtime(now).tm_hour
    return hour >= night_start or hour <= day_start


def noctalia(*command):
    return subprocess.run(["noctalia", "msg", *command], capture_output=True, text=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--latitude", type=float, required=True)
    parser.add_argument("--longitude", type=float, required=True)
    parser.add_argument("--day-offset", type=float, default=0.0, help="minutes added to sunrise")
    parser.add_argument("--night-offset", type=float, default=0.0, help="minutes added to sunset")
    parser.add_argument("--default-day", type=float, default=7.0)
    parser.add_argument("--default-night", type=float, default=18.0)
    parser.add_argument("--day", required=True, help="wallpaper shown during the day")
    parser.add_argument("--night", required=True, help="wallpaper shown at night")
    parser.add_argument("--print", action="store_true", help="print today's switch times and exit")
    args = parser.parse_args()

    if args.print:
        now = time.time()
        day = local_hours(True, args.day_offset, args.latitude, args.longitude, now)
        night = local_hours(False, args.night_offset, args.latitude, args.longitude, now)
        print(f"daystarttime={day} nightstarttime={night} night={is_night(args, now)}")
        return 0

    wanted = args.night if is_night(args, time.time()) else args.day
    current = noctalia("wallpaper-get")

    if current.returncode == 0 and current.stdout.strip() == wanted:
        return 0

    result = noctalia("wallpaper-set", wanted)

    if result.returncode != 0:
        # Noctalia isn't up yet (e.g. right after login), systemd retries
        print(f"noctalia msg wallpaper-set failed: {result.stderr.strip()}", file=sys.stderr)
        return 1

    print(f"wallpaper set to {wanted}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
