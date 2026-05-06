class_name GameCard
extends PanelContainer

#Content
@export var game_name: String
@export var thumbnail: Texture2D
@export var path: String
@export var is_available: bool = true

#Initialization
func _ready():
	$Ctrl_Content/Txt_Name.text = game_name
	$Ctrl_Content/Thumbnail.texture = thumbnail
	$Ctrl_WIP.visible = !is_available

#Redirect to game
func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if is_available:
				SceneTransition.go_to(path)
