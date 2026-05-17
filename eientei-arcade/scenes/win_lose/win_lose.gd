extends Control

@export var current_scene: String

#Return to game selection screen
func _on_btn_back_pressed() -> void:
	SceneTransition.go_to("res://scenes/game_select/GameSelect.tscn")

#Play again
func _on_btn_again_pressed() -> void:
	SceneTransition.go_to(current_scene)
