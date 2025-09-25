# GamepadManager.gd
extends Node

var connected_gamepads: Array[int] = []

func _ready():
	randomize()
	
	update_gamepads()
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func update_gamepads():
	connected_gamepads = Input.get_connected_joypads()
	print(connected_gamepads)

func _on_joy_connection_changed(device_id: int, connected: bool):
	update_gamepads()
	
	if connected:
		print("Gamepad ", device_id, " connected")
	else:
		print("Gamepad ", device_id, " disconnected")
