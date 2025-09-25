class_name MovementHandler
extends Node

@export_subgroup("Settings")
@export var movement_speed: float = 2000
@export var gravity: float = 1000
@export var jump_power: float = -350.0
@export var fall_gravity_multiplier: float = 1.1
@export var attack_movement_reduc: float = 1.0
@export var air_movement_reduc: float = 0.6

@export_subgroup("Nodes")
@export var father: Node2D
@export var timer_jump_cancel: Timer
@export var timer_jump_delay: Timer
@export var timer_cayote: Timer
@export var timer_attack: Timer
var input_handler: InputHandler
var attack_handler: AttackHandler

# Extra Variables
var motion_data: Dictionary
var was_on_floor: bool = false
var can_cayote_jump: bool = true


# Engine Callback
func _ready() -> void:
	input_handler = father.input_handler
	input_handler.update_input_type(father.is_keyboard,father.gamepad_num)
	input_handler.jump_input.connect(_jump_input)
	input_handler.move_down_input.connect(_move_down_input)
	
	attack_handler = father.attack_handler


# Handler Functions
func handle_movement(delta): 
	# Adjusted Variables
	motion_data = get_motion_data(delta)
	
	# Timers
	update_jump_timers()
	update_cayote_timer()
	
	# Horizontal Movement
	handle_horizontal_movement()
	handle_gravity()
	
	handle_motion()

func handle_horizontal_movement() -> void:
	var air_reduc = motion_data.h_air_reduction
	var attack_reduc = motion_data.h_attack_reduction
	var general_reduc = motion_data.delta * air_reduc * attack_reduc
	
	motion_data.velocity.x += movement_speed * general_reduc * get_horizontal_movement_direction()

func handle_motion() -> void:
	var vel = motion_data.velocity
	var acc = motion_data.acceleration
	var delta = motion_data.delta
	
	vel += acc
	acc = acc.lerp(Vector2(0,0),delta*10)
	# Velocity
	vel.x = lerp(vel.x, 0.0,delta*10*motion_data.h_air_reduction)
	vel.y = lerp(vel.y, 0.0,delta)
	
	# Apply changes
	father.velocity = vel
	father.acceleration = acc
	father.move_and_slide()

func handle_gravity() -> void:
	var on_floor = motion_data.on_floor
	var current_gravity = 0
	if not on_floor:
		current_gravity += gravity
		if motion_data.velocity.y > 0:
			current_gravity *= fall_gravity_multiplier
	motion_data.velocity.y += current_gravity * motion_data.delta

func jump():
	father.velocity.y = jump_power
	timer_jump_cancel.start()
	timer_cayote.stop()
	can_cayote_jump = false

# Timer Functions
func update_jump_timers() -> void:
	var on_floor = motion_data.on_floor
	var velocity = motion_data.velocity
	if !timer_jump_delay.is_stopped() and on_floor:
		timer_jump_delay.stop()
		jump()
	if !timer_jump_cancel.is_stopped() and velocity.y > 0:
		timer_jump_cancel.stop()

func update_cayote_timer() -> void:
	var on_floor = motion_data.on_floor
	if was_on_floor and !on_floor and can_cayote_jump: 
		timer_cayote.start()
		was_on_floor = false
		if attack_handler.is_attacking: attack_handler.is_attacking = false
	elif was_on_floor == false and on_floor: 
		was_on_floor = true
		can_cayote_jump = true


# Getter functions
func get_motion_data(delta: float) -> Dictionary:
	return {
		"delta": delta,
		"velocity": father.velocity,
		"acceleration": father.acceleration,
		"on_floor": father.is_on_floor(),
		"h_air_reduction": 1 - air_movement_reduc*float(not father.is_on_floor()),
		"h_attack_reduction": 1 - attack_movement_reduc*float(attack_handler.is_attacking)
	}

func get_horizontal_movement_direction() -> float:
	return float(input_handler.get_input("move_right")) - float(input_handler.get_input("move_left"))


# Signal Callback
func _jump_input(pressed: bool) -> void:
	if pressed:
		if father.is_on_floor() or !timer_cayote.is_stopped():
			jump()
		else:
			timer_jump_delay.start()
	elif not timer_jump_cancel.is_stopped():
		father.velocity.y *= 0.5
		timer_jump_cancel.stop()

func _move_down_input(pressed) -> void:
	if pressed:
		father.position.y += 1
