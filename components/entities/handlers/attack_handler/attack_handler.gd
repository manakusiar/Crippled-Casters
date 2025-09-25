class_name AttackHandler
extends Node

@export_subgroup("Nodes")
@export var father: Node2D

var input_handler: InputHandler
var character_handler: CharacterHandler
var animation_player: AnimationPlayer
var is_attacking: bool = false

# Engine Callback
func _ready() -> void:
	animation_player = father.animation_player
	character_handler = father.character_handler
	input_handler = father.input_handler
	input_handler.attack_input.connect(_attack_input)

func _attack_input(pressed) -> void:
	if pressed and father.is_on_floor() and !is_attacking: is_attacking = true

func attack() -> void:
	animation_player.play(character_handler.character+"_attack")
