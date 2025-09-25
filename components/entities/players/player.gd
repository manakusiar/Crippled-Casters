extends CharacterBody2D

@export var gamepad_num: int = 0
@export var is_keyboard: bool = true

@export_subgroup("Components")
@export var input_handler: InputHandler
@export var movement_handler: MovementHandler
@export var animation_handler: AnimationHandler
@export var character_handler: CharacterHandler
@export var attack_handler: AttackHandler
@export var animation_player: AnimationPlayer
@export var sprite: AnimatedSprite2D
@export var hitboxes: Node2D

var acceleration: Vector2 = Vector2.ZERO

# Engine Callback
func _process(delta: float) -> void:
	movement_handler.handle_movement(delta)
	animation_handler.handle_animations()
