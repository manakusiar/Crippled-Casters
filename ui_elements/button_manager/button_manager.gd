class_name ButtonManager
extends VBoxContainer

@export_subgroup("Settings")
@export var any_input: bool = true
@export var gamepad_num: int
@export var is_keyboard: bool = false

@export_subgroup("Nodes")
@export var buttons: Array[Control]

@export_subgroup("Styleboxes")
@export var sb_main: StyleBoxFlat
@export var sb_main_selected: StyleBoxFlat

var old_selected: int = 0
var selected_button: int = 0

var current_button: Button:
	get:
		if selected_button >= 0 and selected_button < buttons.size():
			return buttons[selected_button]
		else: return null

func _init() -> void:
	focus_mode = Control.FOCUS_NONE
	if buttons.size() > 0 and buttons[0] is Button:
		buttons[0].grab_focus()

func _ready() -> void:
	if !buttons.is_empty():
		disable_auto_focus_nav()
		for i in buttons:
			i.mouse_entered.connect(_on_mouse_entered.bind(i))
		current_button.select()

func _input(event: InputEvent) -> void:
	var _is_keybaord = is_keyboard and event is InputEventKey
	var _is_gamepad = gamepad_num != -4 and (event is InputEventJoypadButton or event is InputEventJoypadMotion)
	
	if any_input or _is_keybaord or _is_gamepad:
		if event.is_action_pressed("ui_up"): next_button(-1)
		elif event.is_action_pressed("ui_down"): next_button(1)
		
		elif event.is_action_pressed("ui_accept"):
			current_button.emit_signal("pressed")
			current_button.change_scale_speed(ButtonValues.scale_press_change)

func next_button(updown: int):
	current_button.deselect()
	selected_button += updown
	wrap_selected()
	current_button.select()

func set_button(num: int):
	current_button.deselect()
	selected_button = num
	wrap_selected()
	current_button.select()

func wrap_selected() -> void:
	if selected_button < 0:
		selected_button = buttons.size()-1
	if selected_button > buttons.size()-1:
		selected_button = 0

func disable_auto_focus_nav() -> void:
	for i in buttons:
		i.focus_mode = Control.FOCUS_NONE

func _on_mouse_entered(button: Control):
	set_button(buttons.find(button))
	
