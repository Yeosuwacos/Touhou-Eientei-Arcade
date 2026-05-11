class_name Shell
extends Node2D

signal selected(shell)

#Content
@export var cup_img: Texture2D
@export var prize_img: Texture2D
@export var has_prize: bool

func _ready():
	$Img_Cup.texture_normal = load("res://assets/sprites/common/sprite_placeholder.png")
	if has_prize:
		$Img_Prize.texture = load("res://assets/sprites/common/p_blue.png")
	$Img_Cup.pressed.connect(_on_pressed)
	
func _on_pressed():
	selected.emit(self)
