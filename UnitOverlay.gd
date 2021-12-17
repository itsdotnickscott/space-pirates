# Draws an overlay over an array of cells.
class_name UnitOverlay
extends TileMap


func draw(tiles: Array) -> void:
	clear();
	for tile in tiles:
		set_cellv(tile, 0);