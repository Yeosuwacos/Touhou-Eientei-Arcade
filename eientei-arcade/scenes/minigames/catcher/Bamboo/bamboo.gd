extends Area2D

#Signals
signal caught
signal missed

#Constants
const SPEED = 300.0

#Falling dynamic
func _process(delta: float):
	position.y += SPEED * delta
	if position.y > get_window().size.y + 50:
		missed.emit()
		queue_free()

#Caught
func _on_body_entered(body: Node):
	if body.name == "Char_Catcher":
		caught.emit()
		queue_free()
