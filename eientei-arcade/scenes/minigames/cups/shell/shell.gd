class_name Shell
extends Node2D

#Content
@export var cup_img: Texture2D
@export var prize_img: Texture2D
@export var has_prize: bool

func _ready():
	$Img_Cup.texture = load("res://assets/sprites/common/sprite_placeholder.png")
	if has_prize:
		$Img_Prize.texture = load("res://assets/sprites/common/p_blue.png")
		$Img_Cup.texture = load("res://assets/sprites/common/p_blue.png")
