extends Control

signal start

func _on_btn_start_pressed() -> void:
	start.emit()

func _on_btn_back_pressed() -> void:
	SceneTransition.go_to("res://scenes/game_select/GameSelect.tscn")
