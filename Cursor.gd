# Player-controlled cursor. Navigate game board, select units, and move them.
# Keyboard, mouse, or touch input.
tool
class_name Cursor
extends Node2D

# Left-click on tile or when pressing enter.
signal accept_pressed(tile);
# When cursor moves into new tile.
signal moved(new_tile);

export var Grid: Resource = preload("res://Grid.tres");

# Coordinates of current tile.
var tile := Vector2.ZERO setget set_tile;

# Time before cursor can move again in seconds.
export var ui_cooldown := 0.1;
onready var _timer: Timer = $Timer;


# Snap cursor to center of starting tile.
func _ready() -> void:
	_timer.wait_time = ui_cooldown;
	position = Grid.calculate_map_pos(tile);


func _unhandled_input(event: InputEvent) -> void:
	# Mouse has been moved.
	if event is InputEventMouseMotion:
		self.tile = Grid.calculate_tile_coords(get_global_mouse_position());

	# Left-mouse button clicked or enter key pressed.
	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		# Delegate responsibility to game board.
		emit_signal("accept_pressed", tile);
		get_tree().set_input_as_handled();

	# Check if cursor should move when arrow key is pressed.
	var should_move := event.is_pressed();
	# When key is held down, we only move when 'ui_cooldown' ends.
	if event.is_echo():
		should_move = should_move and _timer.is_stopped();

	# If cursor should not move at the moment.
	if not should_move:
		return;

	# Move cursor based on input.
	if event.is_action("ui_right"):
		self.tile += Vector2.RIGHT;
	elif event.is_action("ui_up"):
		self.tile += Vector2.UP;
	elif event.is_action("ui_left"):
		self.tile += Vector2.LEFT;
	elif event.is_action("ui_down"):
		self.tile += Vector2.DOWN;


# Controls cursor's current position (when arrow keys are used).
func set_tile(val: Vector2) -> void:
	var new_tile: Vector2 = Grid.clamp(val);
	if new_tile.is_equal_approx(tile):
		return;

	tile = new_tile;
	position = Grid.calculate_map_pos(tile);
	emit_signal("moved", tile);
	_timer.start();