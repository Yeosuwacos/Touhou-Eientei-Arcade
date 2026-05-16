extends CanvasLayer

@onready var anim = $Slide

var playing := false
var target := ""

func go_to(path):
	if playing:
		return

	playing = true
	target = path
	anim.play("slide_in")
	await anim.animation_finished
	await get_tree().create_timer(0.4).timeout
	
	get_tree().change_scene_to_file(target)
	
	anim.play("slide_out")
	await anim.animation_finished
	playing = false
