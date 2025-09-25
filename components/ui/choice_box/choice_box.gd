class_name ChoiceBox
extends BoxContainer

# Signals
signal pressed

# Exported variables
@export_subgroup("Settings")
@export var options: Array[String]
var current_option: int = 0

@export_subgroup("Nodes")
@export var left_button: Button
@export var right_button: Button
@export var text_button: Button
@export var input_parent: Control = null

# Main Variables
var is_selected: bool = false
var mouse_selected: bool = false

# Transformation Variables
var rotation_speed: float = 0
var dest_rotation: float = 0

# Engine Callbacks
func _init() -> void:
	if options.size() > 0:
		text_button.text = options[current_option]

func _input(event: InputEvent) -> void:
	if is_selected:
		if event.is_action_pressed("ui_left"):
			move_option(-1)
		elif event.is_action_pressed("ui_right"):
			move_option(1)

# Main Functions
func select() -> void:
	is_selected = true
	rand_rot_dest()
	text_button.dest_scale = ButtonValues.scale_large_choice

func deselect() -> void:
	if mouse_selected == false:
		is_selected = false
		text_button.dest_rotation = 0.0
		text_button.dest_scale = ButtonValues.scale_normal

func move_option(_next: int) -> void:
	# Change current_option and update button
	current_option += _next
	current_option %= options.size()
	text_button.text = str(options[current_option])
	
	# Rotation animations
	var _rot_power = 50
	rand_rot_dest([sign(_next)])
	if _next > 0: right_button.rotation_speed += PI/_rot_power
	else: left_button.rotation_speed -= PI/_rot_power

# Helper Functions
func change_scale_speed(change: Vector2) -> void:
	text_button.scale_speed += change

func rand_rot_dest(random_dir: Array = [-1,1]) -> void:
	text_button.dest_rotation = PI*randf_range(1,2)/200*random_dir.pick_random()

# Signal Handlers
func _on_left_pressed() -> void:
	move_option(-1)
	
func _on_right_pressed() -> void:
	move_option(1)
