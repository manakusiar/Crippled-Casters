extends HBoxContainer

var color_ready: Color = Color.LIME_GREEN
var color_not_ready: Color = Color.CRIMSON

@export var gamepad_num: int = 0
@export var is_keyboard: bool = false

@export_subgroup("Nodes")
@export var button_manager: ButtonManager
@export var label_name: Label
@export var ready_button: CustomButton

signal ready_update(is_ready)
var player_ready: bool = false

func _ready() -> void:
	ready_button.pressed.connect(_ready_pressed)
	button_manager.is_keyboard = is_keyboard
	button_manager.gamepad_num = gamepad_num
	
	if is_keyboard:
		label_name.text = "Player 1"
	else:
		label_name.text = "Player " + str(gamepad_num + 2)
	
	ready_button.add_theme_color_override("font_color",color_not_ready)

func _ready_pressed() -> void:
	player_ready = player_ready == false
	var _color = color_ready if player_ready else color_not_ready
	ready_button.add_theme_color_override("font_color",_color)
	
	ready_update.emit(player_ready)
