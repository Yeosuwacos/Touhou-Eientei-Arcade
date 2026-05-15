class_name Note
extends Area2D

signal hit
signal miss

#Variables
@export var color: String
@export var illust: Texture2D
@export var hittable: bool = false
@export var hit_s: bool = false

#Constants
const SPEED = 300.0
const DIRS = {
	"red": "up",
	"blue": "down",
	"green": "left",
	"yellow": "right"
}

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
	if position.x > get_window().size.x - 50:
		queue_free()

#Hit system
func _input(event):
	if !hittable:
		return
	if event.is_action_pressed(DIRS[color]):
		hit.emit()
		hit_s = true
		queue_free()

#If in range
func _on_area_entered(area: Area2D):
	if area.name == "Area_Target":
		hittable = true

#If out of range
func _on_area_exited(area: Area2D):
	if area.name == "Area_Target" and hit_s != true:
		hittable = false
		miss.emit()
		queue_free()
