extends Control

func _on_btn_start_pressed() -> void:
	SceneTransition.go_to("res://scenes/game_select/GameSelect.tscn")

func _on_btn_options_pressed() -> void:
	SceneTransition.go_to("res://scenes/options/Options.tscn")

func _on_btn_extras_pressed() -> void:
	SceneTransition.go_to("res://scenes/extras/Extras.tscn")
