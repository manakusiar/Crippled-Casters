extends CanvasLayer

@export_subgroup("Nodes")
@export var anim_player: AnimationPlayer

var current_scene_path: String
const scenes = {
	"main": "res://world/maps/title_screen/title_screen.tscn",
	"player_join": "res://world/maps/player_join/player_join.tscn",
	"01": "res://world/maps/game/world_0_1/world_0_1.tscn"
}

func _ready() -> void:
	fade_in()

func fade_in() -> void:
	anim_player.play("fade_in")
func fade_out() -> void:
	anim_player.play("fade_out")


# This is the main function to call from anywhere in the game.
func switch_to_scene(scene_name: String):
	var scene_path = scenes[scene_name]
	current_scene_path = scene_path
	
	anim_player.play("fade_out")
	
	await anim_player.animation_finished
	
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		print("Error changing scene to: ", scene_name)
		return
	anim_player.play("fade_in")
