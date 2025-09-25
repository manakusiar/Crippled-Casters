extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
func _on_start_game_pressed() -> void:
	SceneManager.switch_to_scene("player_join")
func _on_exit_pressed() -> void:
	get_tree().quit()
