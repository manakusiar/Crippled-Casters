# GamepadManager.gd
extends Node

var connected_gamepads: Array[int] = []

func _ready():
	randomize()
	
	_update_gamepads()
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _update_gamepads():
	connected_gamepads = Input.get_connected_joypads()
	print(connected_gamepads)

func _on_joy_connection_changed(device_id: int, connected: bool):
	_update_gamepads()
	# optional: print or emit signal
	if connected:
		print("Gamepad ", device_id, " connected")
	else:
		print("Gamepad ", device_id, " disconnected")
