class_name Card
extends TextureButton

signal card_flipped(card)

#Content 
@export var illust: Texture2D
@export var cover: Texture2D
@export var number: int
@export var flipped: bool = false

#Interactions
func _ready():
	texture_normal = cover
	custom_minimum_size = Vector2(160, 160)
	ignore_texture_size = true
	stretch_mode = TextureButton.STRETCH_SCALE
	pressed.connect(_on_pressed)

func _on_pressed():
	card_flipped.emit(self)

func flip():
	flipped = !flipped
	if flipped:
		texture_normal = illust
	else:
		texture_normal = cover
