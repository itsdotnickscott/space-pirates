# Represents the game board.
# Base code derived from https://www.gdquest.com/tutorial/godot/2d/tactical-rpg-movement/
class_name Grid
extends Resource


# Grid's size in rows/cols.
export var grid_size := Vector2(10, 10);
# Size of tile in pixels.
export var tile_size := Vector2(32, 16);

var _tile_size_half := tile_size / 2;


# Returns the center of a tile.
func calculate_map_pos(tile_coords: Vector2) -> Vector2:
	# Math grabbed from http://clintbellanger.net/articles/isometric_math/
	var map_x = (tile_coords.x - tile_coords.y) * _tile_size_half.x; 
	var map_y = (tile_coords.x + tile_coords.y) * _tile_size_half.y;

	return Vector2(map_x, map_y);


# Returns the coordinates of the tile based off of map position.
func calculate_tile_coords(map_pos: Vector2) -> Vector2:
	# Math grabbed from http://clintbellanger.net/articles/isometric_math/
	var grid_x = (map_pos.x / _tile_size_half.x + (map_pos.y / _tile_size_half.y)) / 2;
	var grid_y = (map_pos.y / _tile_size_half.y - (map_pos.x / _tile_size_half.x)) / 2;

	return Vector2(int(grid_x), int(grid_y));


# Returns true if 'tile_coords' are in grid.
func is_within_bounds(tile_coords: Vector2) -> bool:
	var out := tile_coords.x >= 0 and tile_coords.x < grid_size.x;
	return out and tile_coords.y >= 0 and tile_coords.y < grid_size.y;


# Makes 'tile_coords' fit within grid's bounds.
func clamp(tile_coords: Vector2) -> Vector2:
	var out := tile_coords;
	out.x = clamp(out.x, 0, grid_size.x - 1.0);
	out.y = clamp(out.y, 0, grid_size.y - 1.0);
	return out;


# Converts 2D coords into 1D array index.
func as_index(tile: Vector2) -> int:
	return int(tile.x + grid_size.x * tile.y);
