class_name Note
extends Area2D

#Variables
@export var type: String
@export var illust: Texture2D

#Initialization
func _ready():
	match type:
		"blue":
			$Sprite2D.texture = load("res://assets/sprites/common/p_blue.png")
		"red":
			$Sprite2D.texture = load("res://assets/sprites/common/p_red.png")
