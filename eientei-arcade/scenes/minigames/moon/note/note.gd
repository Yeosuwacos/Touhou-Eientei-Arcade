class_name Note
extends Area2D

#Variables
@export var color: String
@export var illust: Texture2D

#Constants
const SPEED = 300.0

#Initialization
func _ready():
	match color:
		"red":
			$Sprite2D.texture = load("res://assets/sprites/common/p_red.png")
		"blue":
			$Sprite2D.texture = load("res://assets/sprites/common/p_blue.png")
		"green":
			$Sprite2D.texture = load("res://assets/sprites/common/p_green.png")
		"yellow": 
			$Sprite2D.texture = load("res://assets/sprites/common/p_yellow.png")

#Note dynamic
func _process(delta: float):
	position.x -= SPEED * delta
	if position.y > get_window().size.x - 50:
		queue_free()

#If hit
func _on_body_entered(body: Node):
	if body.name == "Area_Target":
		print("blep")
