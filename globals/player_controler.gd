extends Node

var players: Dictionary

func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)

func _on_scene_changed() -> void:
	var new_scene = get_tree().current_scene
	
	if new_scene is GameMap:
		print("Moved to game map: " + new_scene.name)
		if !players.is_empty():
			# Keyboard
			if players.keyboard.is == true:
				print("keyboard connected")
			for i in players.gamepads:
				print("Gamepad connected: " + str(i.num))
