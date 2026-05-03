extends Control

func _on_btn_start_pressed() -> void:
	SceneTransition.go_to("res://scenes/game_select/GameSelect.tscn")
