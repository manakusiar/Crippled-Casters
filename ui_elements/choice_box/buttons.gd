extends Button

@export_subgroup("Nodes")
@export var father: ChoiceBox

var rotation_speed: float = 0
var dest_rotation: float = 0
var mouse_selected: bool = false
var scale_speed: Vector2 = Vector2(0,0)
var dest_scale: Vector2 = Vector2(1,1)

var save_scale: Vector2
var save_rotation: float

func _ready() -> void:
	focus_mode = Control.FOCUS_NONE
	resized.connect(_update_pivot)
	_update_pivot()

func _update_pivot() -> void:
	pivot_offset = size/2

func _process(delta: float) -> void:
	var _scale_speed: float = 6
	scale_speed += (dest_scale - scale)*delta*6
	scale_speed *= delta*60*0.9
	scale += scale_speed*delta*60
	
	rotation_speed += angle_difference(rotation,dest_rotation)*delta*6
	rotation_speed *= delta*60*0.9
	rotation += rotation_speed*delta*60
