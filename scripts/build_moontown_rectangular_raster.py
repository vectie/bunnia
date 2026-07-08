#!/usr/bin/env python3
"""Build the Moontown miniapp raster with projected-corner terrain fill.

Moontown's source town is a rectangular grid, but the 2.5D/isometric projection
places that grid in a slanted footprint inside a rectangular PNG canvas. This
script keeps the original baked Moontown raster intact and fills only the empty
screen-space corners with deterministic terrain tiles from Moontown's tilemap
vocabulary.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from PIL import Image


GRID_WIDTH = 256
GRID_HEIGHT = 144
RENDER_TILE_WIDTH = 44
RENDER_TILE_HEIGHT = 33
STEP_X = 18
STEP_Y = 9
ORIGIN_X = 1180
ORIGIN_Y = 18
TILE_LEFT_OFFSET = -22

TILE_FILE_FOR_KIND = {
    "grass": "grass_plain",
    "grass-light": "grass_light",
    "forest": "grass_dark",
    "grass-flower-pink": "grass_flower_pink",
    "grass-flower-yellow": "grass_flower_yellow",
    "farm": "grass_flower_yellow",
    "field": "grass_light",
    "river": "river_straight",
    "lake": "river_straight",
    "wetland": "river_bank",
    "bridge": "wood_bridge",
    "road-major": "dirt_path",
    "road": "dirt_path",
    "urban": "plaza_stone",
    "urban-dense": "plaza_stone",
    "campus": "plaza_stone",
}


def parse_args() -> argparse.Namespace:
    repo = Path(__file__).resolve().parents[1]
    sibling_moontown = repo.parent / "moontown"
    parser = argparse.ArgumentParser(
        description="Fill Moontown projected raster corners with real tiles.",
    )
    parser.add_argument(
        "--source",
        type=Path,
        default=sibling_moontown
        / "src/ui/assets/tilemap/wenyu_reference_tilemap_iso.png",
    )
    parser.add_argument(
        "--tiles",
        type=Path,
        default=sibling_moontown / "src/ui/assets/tilemap/tiles",
    )
    parser.add_argument(
        "--labels",
        type=Path,
        default=sibling_moontown
        / "src/ui/assets/tilemap/wenyu_reference_labels.json",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=repo
        / "examples/moontown_miniapp/assets/wenyu_reference_tilemap_iso_mobile.png",
    )
    parser.add_argument("--colors", type=int, default=24)
    return parser.parse_args()


def load_tile(path: Path) -> Image.Image:
    return Image.open(path).convert("RGBA").resize(
        (RENDER_TILE_WIDTH, RENDER_TILE_HEIGHT),
        Image.Resampling.NEAREST,
    )


def load_tiles(tile_dir: Path) -> dict[str, Image.Image]:
    tiles = {}
    for name in set(TILE_FILE_FOR_KIND.values()):
        tiles[name] = load_tile(tile_dir / f"{name}.png")
    return tiles


def load_label_model(labels_path: Path) -> tuple[list[str], dict[str, str]]:
    data = json.loads(labels_path.read_text())
    legend = {
        symbol: item["kind"]
        for symbol, item in data["legend"].items()
    }
    return data["rows"], legend


def tile_name_for_label(
    grid_x: int,
    grid_y: int,
    rows: list[str],
    legend: dict[str, str],
) -> str:
    y = mirror_index(grid_y, GRID_HEIGHT)
    x = mirror_index(grid_x, GRID_WIDTH)
    symbol = rows[y][x]
    kind = legend.get(symbol, "grass")
    kind = buffered_extension_kind(kind, grid_x, grid_y)
    return TILE_FILE_FOR_KIND.get(kind, "grass_plain")


def mirror_index(value: int, size: int) -> int:
    period = size * 2
    item = value % period
    if item < size:
        return item
    return period - item - 1


def buffered_extension_kind(kind: str, grid_x: int, grid_y: int) -> str:
    distance = max(
        max(0, -grid_x),
        max(0, grid_x - (GRID_WIDTH - 1)),
        max(0, -grid_y),
        max(0, grid_y - (GRID_HEIGHT - 1)),
    )
    if distance <= 28:
        return kind
    if kind in {"river", "lake", "wetland", "bridge"}:
        return "river" if distance <= 72 else "wetland"
    if kind in {"urban", "urban-dense", "campus"}:
        return "field" if distance <= 56 else "grass-light"
    if kind in {"road", "road-major"}:
        return "road" if distance <= 44 else "grass-light"
    if distance > 72 and kind not in {"forest", "grass", "grass-light"}:
        return "grass-light"
    return kind


def alpha_composite_clipped(
    canvas: Image.Image,
    tile: Image.Image,
    left: int,
    top: int,
) -> None:
    right = left + tile.width
    bottom = top + tile.height
    if right <= 0 or bottom <= 0 or left >= canvas.width or top >= canvas.height:
        return
    src_left = max(0, -left)
    src_top = max(0, -top)
    dst_left = max(0, left)
    dst_top = max(0, top)
    src_right = tile.width - max(0, right - canvas.width)
    src_bottom = tile.height - max(0, bottom - canvas.height)
    canvas.alpha_composite(
        tile.crop((src_left, src_top, src_right, src_bottom)),
        (dst_left, dst_top),
    )


def projected_range(width: int, height: int) -> tuple[range, range]:
    min_u = int((-RENDER_TILE_WIDTH - ORIGIN_X - TILE_LEFT_OFFSET) / STEP_X) - 2
    max_u = int((width - ORIGIN_X - TILE_LEFT_OFFSET) / STEP_X) + 2
    min_v = int((-RENDER_TILE_HEIGHT - ORIGIN_Y) / STEP_Y) - 2
    max_v = int((height - ORIGIN_Y) / STEP_Y) + 2
    return range(min_u, max_u + 1), range(min_v, max_v + 1)


def build(
    source: Path,
    tile_dir: Path,
    labels_path: Path,
    output: Path,
    colors: int,
) -> None:
    base = Image.open(source).convert("RGBA")
    tiles = load_tiles(tile_dir)
    rows, legend = load_label_model(labels_path)
    width, height = base.size
    filler = Image.new("RGBA", base.size, (146, 180, 88, 255))
    u_range, v_range = projected_range(width, height)
    for v in v_range:
        for u in u_range:
            if (u + v) % 2 != 0:
                continue
            grid_x = (u + v) // 2
            grid_y = (v - u) // 2
            left = ORIGIN_X + u * STEP_X + TILE_LEFT_OFFSET
            top = ORIGIN_Y + v * STEP_Y
            tile_name = tile_name_for_label(grid_x, grid_y, rows, legend)
            alpha_composite_clipped(filler, tiles[tile_name], left, top)
    output_image = Image.alpha_composite(filler, base).convert("RGB")
    output.parent.mkdir(parents=True, exist_ok=True)
    quantized = output_image.quantize(
        colors=colors,
        method=Image.Quantize.MEDIANCUT,
        dither=Image.Dither.NONE,
    )
    quantized.save(output, optimize=True, compress_level=9)
    print(f"wrote {output}")
    print(f"size={width}x{height} bytes={output.stat().st_size} colors={colors}")


def main() -> None:
    args = parse_args()
    build(
        Path(args.source),
        Path(args.tiles),
        Path(args.labels),
        Path(args.output),
        int(args.colors),
    )


if __name__ == "__main__":
    main()
