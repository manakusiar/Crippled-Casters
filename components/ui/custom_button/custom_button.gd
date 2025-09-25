class_name CustomButton
extends Button

# General Variables
var is_selected: bool = false
var mouse_selected: bool = false

# Transformation Variables
var rotation_speed: float = 0
var dest_rotation: float = 0
var scale_speed: Vector2 = Vector2(0,0)
var dest_scale: Vector2 = Vector2(1,1)

# Engine Callback
func _ready() -> void:
	resized.connect(update_pivot)
	update_pivot()

func _process(delta: float) -> void:
	var _scale_speed: float = 6
	
	scale_speed += (dest_scale - scale)*delta*6
	scale_speed *= 0.9*delta*60
	scale += scale_speed*delta*60
	
	rotation_speed += angle_difference(rotation,dest_rotation)*delta*6
	rotation_speed *= 0.8*delta*60
	rotation += rotation_speed*delta*60

# Main functions
func select() -> void:
	is_selected = true
	rand_rot_dest()
	dest_scale = ButtonValues.scale_large

func deselect() -> void:
	if mouse_selected == false:
		is_selected = false
		dest_rotation = 0.0
		dest_scale = ButtonValues.scale_normal

# Helper Functions
func rand_rot_dest() -> void:
	dest_rotation = PI*randf_range(1,2)/100*[-1,1].pick_random()

func change_scale_speed(change: Vector2) -> void:
	scale_speed += change

func update_pivot() -> void: # Center the pivot
	pivot_offset = size/2
