class_name Card
extends TextureRect

#Content 
@export var illust: Texture2D
@export var cover: Texture2D
@export var number: int

#Interactions
func _ready():
	texture = cover

func reveal():
	texture = illust

func conceal():
	texture = cover
