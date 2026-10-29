# Noctalia's official screen_recorder plugin, patched (screen-recorder.patch) to:
#
# - save recordings as .webm. The plugin hardcodes .mp4 and gpu-screen-recorder
#   picks the container from it. WebM needs AV1/VP8/VP9 video; the Noctalia
#   config selects AV1.
# - style its slurp region picker like Noctalia's screenshot selector, using
#   the live primary color and [shell.screenshot] dim/border settings.
#   Noctalia has no command that returns a selected region, so the selector
#   itself cannot be shared.
#
# Installed under ~/.local/share/noctalia/plugins, this copy takes precedence
# over the official git source for the same plugin id, so the plugin's
# settings carry over.
{
  applyPatches,
  src,
}:
applyPatches {
  name = "noctalia-screen-recorder";
  src = "${src}/screen_recorder";
  patches = [./screen-recorder.patch];
}
