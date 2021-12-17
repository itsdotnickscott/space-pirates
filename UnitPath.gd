# Draws unit's movement path with autotile.
class_name UnitPath
extends TileMap


export var grid: Resource;

var _pathfinder: PathFinder;
var current_path := PoolVector2Array();


func initialize(walkable_tiles: Array) -> void:
	_pathfinder = PathFinder.new(grid, walkable_tiles);


func draw(tile_start: Vector2, tile_end: Vector2) -> void:
	clear();
	current_path = _pathfinder.calculate_point_path(tile_start, tile_end);
	for tile in current_path:
		set_cellv(tile, 0);

	update_bitmask_region();


func stop() -> void:
	_pathfinder = null;
	clear();


