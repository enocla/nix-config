"""Ask gnome-keyring to unlock the login keyring and show its prompt.

The Unlock and Prompt calls must share one D-Bus connection that stays open
until the prompt completes: gnome-keyring drops a prompt as soon as the client
that requested it disconnects.
"""

import sys

from gi.repository import Gio, GLib

SERVICE = "org.freedesktop.secrets"
ROOT = "/org/freedesktop/secrets"
LOGIN = "/org/freedesktop/secrets/collection/login"

bus = Gio.bus_get_sync(Gio.BusType.SESSION)


def call(path, iface, method, args, reply):
    return bus.call_sync(
        SERVICE, path, iface, method, args, GLib.VariantType(reply),
        Gio.DBusCallFlags.NONE, -1, None,
    ).unpack()


try:
    (locked,) = call(
        LOGIN, "org.freedesktop.DBus.Properties", "Get",
        GLib.Variant("(ss)", ("org.freedesktop.Secret.Collection", "Locked")), "(v)",
    )
except GLib.Error as e:
    print(f"no login keyring to unlock: {e.message}")
    sys.exit(0)

if not locked:
    print("login keyring already unlocked")
    sys.exit(0)

unlocked, prompt = call(
    ROOT, "org.freedesktop.Secret.Service", "Unlock",
    GLib.Variant("(ao)", ([LOGIN],)), "(aoo)",
)
if prompt == "/":
    print("login keyring unlocked without a prompt")
    sys.exit(0)

loop = GLib.MainLoop()
result = {}


def on_completed(_conn, _sender, _path, _iface, _signal, params):
    result["dismissed"] = params.unpack()[0]
    loop.quit()


bus.signal_subscribe(
    SERVICE, "org.freedesktop.Secret.Prompt", "Completed", prompt,
    None, Gio.DBusSignalFlags.NONE, on_completed,
)
call(prompt, "org.freedesktop.Secret.Prompt", "Prompt", GLib.Variant("(s)", ("",)), "()")
loop.run()

if result.get("dismissed"):
    print("unlock prompt dismissed; login keyring is still locked")
    sys.exit(1)
print("login keyring unlocked")
