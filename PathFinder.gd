# Finds the path between two points among walkable tiles using A*.
class_name PathFinder
extends Reference


const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN];

var _grid: Resource;
var _astar := AStar2D.new();


func _init(grid: Grid, walkable_tiles: Array) -> void:
	_grid = grid;

	var tile_mappings := {}
	for tile in walkable_tiles:
		tile_mappings[tile] = _grid.as_index(tile);

	_add_and_connect_points(tile_mappings);


func calculate_point_path(start: Vector2, end: Vector2) -> PoolVector2Array:
	var start_idx: int = _grid.as_index(start);
	var end_idx: int = _grid.as_index(end);

	# Ensure both start and end are walkable.
	if _astar.has_point(start_idx) and _astar.has_point(end_idx):
		return _astar.get_point_path(start_idx, end_idx);
	else:
		return PoolVector2Array();


func _add_and_connect_points(tile_mappings: Dictionary) -> void:
	# Register all points into A* graph.
	for point in tile_mappings:
		_astar.add_point(tile_mappings[point], point);

	# Connect points to their neighbors.
	for point in tile_mappings:
		for neighbor_idx in _find_neighbor_indeces(point, tile_mappings):
			_astar.connect_points(tile_mappings[point], neighbor_idx);


func _find_neighbor_indeces(tile: Vector2, tile_mappings: Dictionary) -> Array:
	var out := [];
	for direction in DIRECTIONS:
		var neighbor: Vector2 = tile + direction;
		# Ensure neighbor is a walkable tile.
		if not tile_mappings.has(neighbor):
			continue;

		# Ensure neighbor isn't already connected to tile.
		if not _astar.are_points_connected(tile_mappings[tile], tile_mappings[neighbor]):
			out.push_back(tile_mappings[neighbor]);

	return out;