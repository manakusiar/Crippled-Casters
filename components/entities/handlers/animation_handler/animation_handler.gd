class_name AnimationHandler
extends Node

@export_subgroup("Settings")
@export var run_delta: float = 10
@export var air_delta: float = 0.5

@export_subgroup("Nodes")
@export var father: Node2D

var character_handler: CharacterHandler
var movement_handler: MovementHandler
var attack_handler: AttackHandler
var hitbox_container: Node2D
var sprite: AnimatedSprite2D

func _ready() -> void:
	character_handler = father.character_handler
	movement_handler = father.movement_handler
	attack_handler = father.attack_handler
	hitbox_container = father.hitboxes
	sprite = father.sprite
	sprite.animation_finished.connect(_animation_finished)

func handle_animations() -> void:
	var vel = father.velocity
	var anim = sprite.animation
	
	if sign(vel.x) != 0:
		var flip = sign(vel.x) == -1
		sprite.flip_h = flip
		hitbox_container.scale.x = 1 - 2*int(flip)
	
	if attack_handler.is_attacking == false:
		if abs(vel.y) > air_delta:
			if sign(vel.y) > 0:
				sprite.play("fall")
			else:
				sprite.play("rise")
		else:
			if abs(vel.x) > run_delta:
				sprite.play("run")
			else:
				sprite.play("idle")

func _animation_finished() -> void:
	if attack_handler.is_attacking: 
		attack_handler.stop_attacking()
