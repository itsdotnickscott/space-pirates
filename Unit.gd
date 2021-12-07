# Represents a unit on the game board.
# Base code derived from https://www.gdquest.com/tutorial/godot/2d/tactical-rpg-movement/
tool
class_name Unit
extends Path2D


signal walk_finished;

export var Grid: Resource = preload("res://Grid.tres");
export var move_range := 6;
export var skin: Texture setget set_skin;
export var skin_offset := Vector2.ZERO setget set_skin_offset;
export var move_speed := 600.0;

var tile := Vector2.ZERO setget set_tile;
var is_selected := false setget set_is_selected;

var _is_walking := false setget _set_is_walking;

onready var _sprite: Sprite = $PathFollow2D/Sprite;
onready var _anim_player: AnimationPlayer = $AnimationPlayer;
onready var _path_follow: PathFollow2D = $PathFollow2D;


func _ready() -> void:
	# Unless unit needs to walk, we do not need it to update every frame.
	set_process(false);

	# Snap unit to tile.
	self.tile = Grid.calculate_grid_coords(position);
	position = Grid.calculate_map_pos(tile);

	if not Engine.editor_hint:
		# Create curve resource here because creating it in the editor prevents movement.
		curve = Curve2D.new();

	var points := [
		Vector2(2, 2),
		Vector2(2, 5),
		Vector2(8, 5),
		Vector2(8, 7),
	]
	walk_along(PoolVector2Array(points))


# When active, moves unit along a "curve".
func _process(delta: float) -> void:
	# Every frame, this property moves the sprite along the "curve".
	_path_follow.offset += move_speed * delta;

	# 'unit_offset' measures how far along the sprite is in terms of percent.
	if _path_follow.unit_offset >= 1.0:
		# This will also end the process.
		self._is_walking = false;

		# Snaps sprite back to Unit node's psosition and clear the curve.
		_path_follow.offset = 0.0;
		position = Grid.calculate_map_pos(tile);
		curve.clear_points();

		emit_signal("walk_finished");


# Starts walking along a given 'path'.
func walk_along(path: PoolVector2Array) -> void:
	if path.empty():
		return;

	# Converts 'path' to points on the 'curve'.
	curve.add_point(Vector2.ZERO);
	for point in path:
		curve.add_point(Grid.calculate_map_pos(point) - position);

	# Change Unit's tile to target position.
	tile = path[-1]

	self._is_walking = true;


func set_tile(val: Vector2) -> void:
	tile = Grid.clamp(val);


func set_is_selected(val: bool) -> void:
	is_selected = val;

	if is_selected:
		_anim_player.play("selected");
	else:
		_anim_player.play("idle");


func set_skin(val: Texture) -> void:
	skin = val;

	# Wait until Sprite has actually entered the tree.
	if not _sprite:
		yield(self, "ready");
	_sprite.texture = val;


func set_skin_offset(val: Vector2) -> void:
	skin_offset = val;

	if not _sprite:
		yield(self, "ready");
	_sprite.position = val;


func _set_is_walking(val: bool) -> void:
	_is_walking = val;
	set_process(_is_walking);
