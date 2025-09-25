extends Camera2D

@export var player_nodes: Node

func _ready() -> void:
	var _pos = Vector2.ZERO
	var _child_num = 0
	for child in player_nodes.get_children():
		_pos += child.position
		_child_num += 1
	
	position = _pos / _child_num
	reset_smoothing()

func _process(delta: float) -> void:
	var _pos = Vector2.ZERO
	var _child_num = 0
	for child in player_nodes.get_children():
		_pos += child.position
		_child_num += 1
	position = _pos / _child_num
