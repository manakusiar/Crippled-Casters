class_name InputHandler
extends Node

signal jump_input(pressed: bool)
signal attack_input
signal move_down_input

@export_subgroup("Settings")
@export var gamepad_num: int = 0
@export var is_keyboard: bool = false

# Engine Callback
func _input(event: InputEvent) -> void:
	if not event.is_echo():
		var _keyboard_check = is_keyboard and event is InputEventKey
		var _gamepad_check = not is_keyboard and (event is InputEventJoypadButton or event is InputEventJoypadMotion) and event.device == gamepad_num
		if _keyboard_check or _gamepad_check:
			if event.is_action("jump"):
				jump_input.emit(event.is_pressed())
			if event.is_action("attack"):
				attack_input.emit(event.is_pressed())
			if event.is_action("move_down"):
				move_down_input.emit(event.is_pressed())


# General function
func get_input(action: StringName) -> bool:
	if is_keyboard:
		return is_action_held_by_keyboard(action)
	else:
		return is_action_held_by_device(action, gamepad_num)

# Get action for specific devices
func is_action_held_by_keyboard(action: StringName) -> bool:
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey and Input.is_key_pressed(event.physical_keycode):
			return true
		elif event is InputEventMouseButton and Input.is_mouse_button_pressed(event.button_index):
			return true
	return false

func is_action_held_by_device(action: StringName, device_id: int) -> bool:
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventJoypadButton:
			if Input.is_joy_button_pressed(device_id, event.button_index):
				return true
		elif event is InputEventJoypadMotion:
			var axis_value = Input.get_joy_axis(device_id, event.axis)
			if abs(axis_value) > 0.5 and sign(axis_value) == sign(event.axis_value):
				return true
	return false


# Helper Function
func update_input_type(_is_keyboard: bool, _gamepad_num: int = 0) -> void:
	is_keyboard = _is_keyboard
	gamepad_num = _gamepad_num
