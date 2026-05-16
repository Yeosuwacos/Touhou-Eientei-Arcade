extends Control

signal start

func _on_btn_start_pressed() -> void:
	start.emit()
