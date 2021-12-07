extends Node2D

onready var tile_map = $TileMap
onready var player_characters = get_tree().get_nodes_in_group("player_characters")

func _ready():
	for player in player_characters:
		player.set_location(tile_map.world_to_map(player.position), player.position)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var location = tile_map.world_to_map(event.position)
		print(location)
		
		for player in player_characters:
			if player.ready_to_move:
				player.set_location(location, tile_map.map_to_world(location))
				player.unready_to_move()
