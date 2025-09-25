extends Node2D

@export_subgroup("PackedScenes")
@export var player_em: PackedScene

@export_subgroup("Nodes")
@export var box_container: BoxContainer
@export var ready_label: Label
@export var ready_timer_all: Timer
@export var ready_timer: Timer

# Variables
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

# Engine Callbacks
func _process(delta: float) -> void:
	if ready_timer_all.time_left > 0:
		update_ready_label(" - "+str(int(ceil(ready_timer_all.time_left))))
	elif ready_timer.time_left > 0:
		update_ready_label(" - "+str(int(ceil(ready_timer.time_left))))

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
		create_player_em(true)
	elif _is_gamepad_input and !_has_gamepad:
		create_player_em(false,event.device)
	
	if event.is_action_pressed("ui_cancel"):
		if _is_keyboard and _has_keyboard:
			remove_player_em(true)
		elif _is_gamepad_key and _has_gamepad:
			remove_player_em(false,event.device)

# Modify Player Edit Menus
func create_player_em(is_keyboard: bool, gamepad_num: int = -4) -> void:
	var player_instance = player_em.instantiate()
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
func remove_player_em(is_keyboard: bool, gamepad_num: int = -4) -> void:
	if is_keyboard:
		var pm_item = players.keyboard
		if pm_item["id"] != null:
			if pm_item.id.player_ready == true: ready_update(0)
			pm_item["id"].queue_free()
			pm_item["id"] = null
		pm_item["is"] = false
	else:
		var found_dict = players["gamepads"].find(
			func(item): return item.get("num") == gamepad_num
		)["id"]
		
		if found_dict.player_ready == true: ready_update(0)
		
		 
		found_dict.queue_free()
		
		players["gamepads"] = players["gamepads"].filter(
			func(item): return item.get("num") != gamepad_num
		)

# Ready players functions
func ready_update(is_ready) -> void:
	ready_ammount += 1 if is_ready else -1
	update_ready_label()
	if ready_ammount >= players_ready_ammount:
		ready_timer_all.start()
	elif ready_ammount >= 0:
		ready_timer.start()
		ready_timer_all.stop()
	else:
		ready_timer_all.stop()
		ready_timer.stop()

func update_ready_label(extra_text: String = "") -> void: # Helper function to set the ready_label text
	ready_label.text = str(ready_ammount)+"/"+str(players_ready_ammount) + extra_text

func finalize_joined_players() -> void: # Export the players to the Player Controler
	PlayerControler.players = players.duplicate(true)
	print(players)

func _on_timer_ready_timeout() -> void: # Both timers timeout
	finalize_joined_players()
	SceneManager.switch_to_scene("01")
