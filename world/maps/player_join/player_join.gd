extends Node2D

const player_manager: PackedScene = preload("res://ui_elements/player_manager/player_manager.tscn")

@export_subgroup("Nodes")
@export var box_container: BoxContainer

var ready_ammount: int = 0
var players = {
	"keyboard": {
		"id": null,
		"is": false
	},
	"gamepads": []
}
var players_ready_ammount:
	get():
		return int(players["keyboard"]["is"]) + players["gamepads"].size()

func _input(event: InputEvent) -> void:
	var _is_keyboard = event is InputEventKey
	var _is_gamepad_key = event is InputEventJoypadButton
	var _is_keyboard_input = event.is_action_pressed("ui_accept") and _is_keyboard
	var _is_gamepad_input = _is_gamepad_key and event.is_pressed()
	var _has_keyboard = players["keyboard"]["is"] == true
	var _has_gamepad = players["gamepads"].any(
		func(item): return item.get("num") == event.device
	)
	
	if _is_keyboard_input and !_has_keyboard:
		create_player_manager(true)
	elif _is_gamepad_input and !_has_gamepad:
		create_player_manager(false,event.device)
	
	if event.is_action_pressed("ui_cancel"):
		if _is_keyboard and _has_keyboard:
			players["keyboard"]["id"].queue_free()
			players["keyboard"]["id"] = null
			players["keyboard"]["is"] = false
		elif _is_gamepad_key and _has_gamepad:
			var found_dict = players["gamepads"].find(
				func(item): return item.get("num") == event.device
			)["id"].queue_free()
			
			players["gamepads"] = players["gamepads"].filter(
				func(item): return item.get("num") != event.device
			)

func create_player_manager(is_keyboard: bool, gamepad_num: int = -4) -> void:
	var player_instance = player_manager.instantiate()
	player_instance.is_keyboard = is_keyboard
	player_instance.gamepad_num = gamepad_num
	box_container.add_child(player_instance)
	
	if is_keyboard == true: players["keyboard"] = {
		"id": player_instance,
		"is": true
	}
	else: 
		players["gamepads"].append({
			"id": player_instance,
			"num": gamepad_num
		})
	print(players["gamepads"])
	
	player_instance.ready_update.connect(ready_update)

func ready_update(is_ready):
	ready_ammount += 1 if is_ready else -1
	$Label.text = " " + str(ready_ammount)+" - "+str(ready_ammount == players_ready_ammount)
