extends Area2D

var ready_to_move = false
var location

func _ready():
	add_to_group("player_characters")

func _on_SampleCharacter_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if !ready_to_move:
			ready_to_move = true
			print("ready to move")
		
func set_location(vec, pos):
	location = vec
	position = pos

func unready_to_move():
	ready_to_move = false
