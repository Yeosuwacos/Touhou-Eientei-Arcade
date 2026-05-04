extends Control

func _on_btn_back_pressed() -> void:
	SceneTransition.go_to("res://scenes/main_menu/MainMenu.tscn")
