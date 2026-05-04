extends Control

#Return to game selection screen
func _on_btn_back_pressed() -> void:
	SceneTransition.go_to("res://scenes/game_select/GameSelect.tscn")
