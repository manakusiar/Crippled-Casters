class_name CharacterHandler
extends Node

@export var father: Node2D
@export var character: String = ["knight","thief","anomaly"].pick_random()
@export var character_names: Dictionary = {
	"knight": 0,
	"thief": 1,
	"anomaly": 2
}
@export var character_array: Array[SpriteFrames]

var sprite: AnimatedSprite2D

func _ready() -> void:
	sprite = father.sprite
	set_chracter(character)

func set_chracter(new_character) -> void:
	character = new_character
	sprite.sprite_frames = character_array[character_names[character]]
	
