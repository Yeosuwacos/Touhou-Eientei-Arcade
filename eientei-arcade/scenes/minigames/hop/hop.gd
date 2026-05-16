extends MinigameBase

#Game constants
const START = preload("res://scenes/start/start.tscn")
const GRAVITY = 800.0
const MAX_JUMP = 600.0
const CHARGE = 300.0
const X_SPEED = 300.0
const PLATFORM = preload("res://scenes/minigames/hop/Platform/platform.tscn")
const P_MIN_GAP = 20.0
const P_MAX_GAP = 60.0
const Y_GAME_OVER = 91.0

#Variables
var p_speed = 100
var tickets = 0
var jump_pwr = 0.0
var is_charging = false
var platform_spawn = 3
var timer = 0.0
var scaling = 0.0
var is_playing = false

#Objects
@onready var chara = $Char_Hop
@onready var win_lose = $Cnv_Screen/WinLose
@onready var tickets_label = $Cnv_Screen/WinLose/Ctrl_EndScreen/Txt_TicketsWon
@onready var end_image = $Cnv_Screen/WinLose/Ctrl_EndScreen/Img_EndImg
@onready var jump_indicator = $Char_Hop/Jump_Power
@onready var cnv_start = $Cnv_Start

#Initialization 
func _ready():
	set_physics_process(false)
	var start = START.instantiate()
	start.start.connect(start_game)
	cnv_start.add_child(start)

func start_game():
	set_physics_process(true)
	cnv_start.visible = false
	chara.up_direction = Vector2.UP
	chara.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	jump_indicator.max_value = MAX_JUMP
	is_playing = true

#Game
func _physics_process(delta: float):
	#Platform system
	var plat = _current_platform()
	if plat != null and chara.is_on_floor():
		chara.position.x -= p_speed * delta * (1 + scaling)
		
		if plat.is_in_group("floor"):
			finish_game()
	
	#Jump system
	if Input.is_action_pressed("jump") and chara.is_on_floor():
		jump_pwr = min(jump_pwr + CHARGE * delta, MAX_JUMP)
		jump_indicator.value = jump_pwr
		is_charging = true

	if is_charging and not Input.is_action_pressed("jump"):
		chara.velocity.y = -jump_pwr*1.5
		chara.velocity.x = X_SPEED/1.5
		jump_pwr = 0.0
		jump_indicator.value = 0.0
		is_charging = false

	chara.velocity.y += GRAVITY * delta
	chara.move_and_slide()

	#Flooring
	if chara.is_on_floor():
		chara.velocity.x = 0
		chara.velocity.y = 0

	#Lose conditions
	chara.position.x = clamp(chara.position.x, 50, get_window().size.x - 50)
	if chara.position.x <= 50:
		finish_game()
		
	if chara.position.y > get_window().size.y - Y_GAME_OVER:
		finish_game()
		
	#Platform spawner
	_move_platforms(delta)
	
	timer -= delta
	if timer <= 0.0:
		timer = platform_spawn
		platform_spawn = randf_range(2,4)
		tickets += 10
		scaling += 0.1
		_add_platform()

#Platforms
func _add_platform():
	var w = get_window().size.x
	var h = get_window().size.y
	
	var platform = PLATFORM.instantiate()
	platform.position = Vector2(w + 60, 
	randf_range(h * 0.8, h * 0.9))
	add_child(platform)

#Platform movement
func _move_platforms(delta):
	for platform in get_tree().get_nodes_in_group("platforms"):
		platform.position.x -= p_speed * delta * (1 + scaling)
		if platform.position.x < -100:
			platform.queue_free()
			
func _current_platform():
	for i in chara.get_slide_collision_count():
		var collision = chara.get_slide_collision(i)
		var c_plat = collision.get_collider()
		if c_plat != null and c_plat.is_in_group("platforms"):
			return c_plat
	return null

func finish_game():
	is_playing = false
	set_physics_process(false)
	win_lose.visible = true
	tickets_label.text = "You won %d tickets!" % tickets
	end_image.texture = load("res://assets/sprites/ui/game_covers/placeholder.png")
	end_game(tickets)
