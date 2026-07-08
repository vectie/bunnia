# Moontown Map Projection Notes

This note documents the current Moontown mini-app map decision so the asset work
does not drift back into black fills, arbitrary square maps, or viewport-only
clamps.

## Correct Model

Moontown starts from a rectangular semantic town grid. The desktop tilemap uses
the isometric projection:

```text
screen_x = origin_x + (grid_x - grid_y) * step_x
screen_y = origin_y + (grid_x + grid_y) * step_y
```

With the current Moontown constants:

- `grid_width = 256`
- `grid_height = 144`
- `step_x = 18`
- `step_y = 9`
- `origin_x = 1180`
- `origin_y = 18`
- displayed tile size is `44px x 33px`

That means the original town grid is rectangular in world space, but it is not
rectangular after projection. It becomes a slanted screen-space footprint inside
a rectangular PNG canvas. The empty bottom-left and top-right areas are the
unused parts of that canvas, not valid town content.

## Mini-App Fix

The mini-app should still present a rectangular phone viewport. The fix is not
to crop blindly, draw a black backfill, or invent a square map. The fix is to
generate enough surrounding valley terrain that the projected screen-space
raster is rectangular too.

The rule is:

- keep the Moontown raster path for mini-app performance
- keep the original Moontown baked town pixels intact
- fill the projected empty corners from Moontown's semantic terrain label rows,
  so water, roads, fields, forest, urban blocks, bridges, and grass extend as
  terrain classes instead of unrelated decoration
- mirror terrain labels past the original grid edge instead of clamping one
  edge row forever; this keeps edge connections while avoiding unnatural
  infinite road, river, or field stripes
- keep civic buildings, labels, and product state out of the filler
- clamp pan/zoom against the rectangular filled raster, because the asset now
  contains meaningful map content across the full rectangle

This preserves the 2.5D camera while making the visible rectangle safe for
mobile panning.

## Rebuild Command

From the Bunnia repository root:

```bash
python3 scripts/build_moontown_rectangular_raster.py
```

The script reads the sibling Moontown asset pipeline files:

- `../moontown/src/ui/assets/tilemap/wenyu_reference_tilemap_iso.png`
- `../moontown/src/ui/assets/tilemap/wenyu_reference_labels.json`
- `../moontown/src/ui/assets/tilemap/tiles/*.png`

It writes:

- `examples/moontown_miniapp/assets/wenyu_reference_tilemap_iso_mobile.png`

The generated PNG remains a single packaged raster so WeChat pan/zoom does not
move tens of thousands of tile nodes. The default palette is intentionally
bounded to keep the local WeChat package under the current scene asset budget.
