extends Node2D

@export_subgroup("Nodes")
@export var buttons: Array[Control]

var selected_button: int = 0
func _init() -> void:
	if buttons.size() > 0 and buttons[0] is Button:
		buttons[0].grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		next_button(-1)
	if event.is_action_pressed("ui_down"):
		next_button(1)

func next_button(updown: int, leftright: int = 0):
	selected_button += updown
	wrap_selected()

	buttons[selected_button].grab_focus()

func wrap_selected() -> void:
	selected_button %= buttons.size()
