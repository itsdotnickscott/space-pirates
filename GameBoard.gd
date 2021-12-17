# Represents and manages the game board. Stores information about unit locations,
# obstacles, and other important info.
class_name GameBoard
extends YSort


const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN];

export var Grid: Resource = preload("res://Grid.tres");

onready var _unit_overlay: UnitOverlay = $UnitOverlay

# A dictionary will keep track of the units on the board.
# Key is position as tile coordinates and value is reference to the unit.
var _units := {};


func _ready() -> void:
	_reinitialize();


func is_occupied(tile: Vector2) -> bool:
	return true if _units.has(tile) else false;


func _reinitialize() -> void:
	_units.clear();

	for child in get_children():
		var unit := child as Unit;
		if not unit:
			continue;

		_units[unit.tile] = unit;


func get_walkable_cells(unit: Unit) -> Array:
	return _flood_fill(unit.tile, unit.move_range);


# Returns an array containing the coordinates of all walkable tiles.
func _flood_fill(tile: Vector2, max_distance: int) -> Array:
	var walkable_tiles := [];
	var stack := [tile];

	while not stack.empty():
		var current = stack.pop_back();

		# Ensure that tile is within the grid.
		if not Grid.is_within_bounds(current):
			continue;
		# Ensure that tile isn't already visited.
		if current in walkable_tiles:
			continue

		# Check for distance between starting tile and current one.
		var difference: Vector2 = (current - tile).abs();
		var distance := int(difference.x + difference.y);
		# Ensure tile is not farther than the max walking distance.
		if distance > max_distance:
			continue;

		# If we hit here, conditions are met.
		walkable_tiles.append(current);
		# Check current tile's neighbors and add them to the stack.
		for direction in DIRECTIONS:
			var coords: Vector2 = current + direction;

			if is_occupied(coords):
				continue;
			if coords in walkable_tiles:
				continue;

			stack.append(coords);
		
	return walkable_tiles;
