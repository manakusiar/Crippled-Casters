class_name AttackHandler
extends Node

@export_subgroup("Nodes")
@export var father: Node2D
@export var attack_cooldown_timer: Timer

var input_handler: InputHandler
var character_handler: CharacterHandler
var animation_player: AnimationPlayer
var is_attacking: bool = false
var wants_to_attack: bool = false

# Engine Callback
func _ready() -> void:
	animation_player = father.animation_player
	character_handler = father.character_handler
	
	input_handler = father.input_handler
	input_handler.attack_input.connect(_attack_input)
	
	attack_cooldown_timer.timeout.connect(_attack_cooldown_timeout)

func _attack_input(pressed) -> void:
	if pressed and father.is_on_floor(): 
		if !is_attacking and attack_cooldown_timer.is_stopped(): attack()
		else: wants_to_attack = true

func _attack_cooldown_timeout() -> void:
	if wants_to_attack and father.is_on_floor():
		wants_to_attack = false
		attack()

func stop_attacking() -> void:
	is_attacking = false
	attack_cooldown_timer.start()
	animation_player.stop()
	animation_player.play("RESET")

func attack() -> void:
	is_attacking = true
	animation_player.play(character_handler.character+"_attack")
