extends MinigameBase

#Game constants
const START = preload("res://scenes/start/start.tscn")
const BAMBOO = preload("res://scenes/minigames/catcher/Bamboo/bamboo.tscn")
const LIVES = 5
const INTERVAL = 1.8
const DASH_CD = 1
const PADDING = 250

#Variables
var score := 0
var misses := 0
var playing = true
var dash_rdy = true

#Objects
@onready var chara = $Char_Catcher
@onready var spawner = $T_Spawner
@onready var dashtime = $T_Dash
@onready var hud = $HUD
@onready var i_dash = $HUD/Img_Dash
@onready var container = $BambooContainer
@onready var score_label = $HUD/Txt_Score
@onready var lives_label = $HUD/Txt_Lives
@onready var cnv_start = $Cnv_Start
@onready var cnv_screen = $Cnv_Screen
@onready var win_lose = $Cnv_Screen/WinLose
@onready var tickets_label = $Cnv_Screen/WinLose/Ctrl_EndScreen/Txt_TicketsWon
@onready var end_image = $Cnv_Screen/WinLose/Ctrl_EndScreen/Img_EndImg

func _ready():
	set_physics_process(false)
	var start = START.instantiate()
	start.start.connect(start_game)
	cnv_start.add_child(start)

#Initialization 
func start_game():
	set_physics_process(true)
	cnv_start.visible = false
	chara.visible = true
	hud.visible = true
	i_dash.color = "green"
	score = 0
	misses = 0
	spawner.wait_time = INTERVAL
	spawner.start()
	update_hud()

#Game
func _physics_process(delta: float):
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("left"):
		velocity.x = -400
	elif Input.is_action_pressed("right"):
		velocity.x = 400
	if Input.is_action_just_pressed("jump") and dash_rdy == true:
		if velocity.x == 400:
			velocity.x = 10000
		elif velocity.x == -400:
			velocity.x = -10000
		else:
			return
		dash_rdy = false
		i_dash.color = "red"
		dashtime.start()
	chara.velocity = velocity
	chara.move_and_slide()
	chara.position.x = clamp(chara.position.x, 50, get_window().size.x - 50)

#Bamboo physics
func _on_t_spawner_timeout():
	var bamboo = BAMBOO.instantiate()
	container.add_child(bamboo)
	bamboo.position.x = randf_range(PADDING ,get_window().size.x - PADDING)
	bamboo.position.y = -50
	bamboo.caught.connect(_on_bamboo_caught)
	bamboo.missed.connect(_on_bamboo_missed)

#Dash refresh
func _on_t_dash_timeout() -> void:
	dash_rdy = true
	i_dash.color = "green"
	dashtime.stop()

#Bamboo caught
func _on_bamboo_caught():
	score += 1
	update_hud()
	spawner.wait_time = max(0.4, INTERVAL - score * 0.05)

#Bamboo missed
func _on_bamboo_missed():
	misses += 1
	update_hud()
	if misses >= LIVES:
		finish_game()

#Game end and tickets
func finish_game():
	set_physics_process(false)
	spawner.stop()
	for bamboo in container.get_children():
		bamboo.queue_free()
	var tickets = score * 5
	cnv_screen.layer = 2
	win_lose.visible = true
	tickets_label.text = "You won %d tickets!" % tickets
	end_image.texture = load("res://assets/sprites/ui/game_covers/placeholder.png")
	end_game(tickets)

#Display update
func update_hud():
	score_label.text = "Bamboo caught: %d" % score
	lives_label.text = "Lives: %d" % (5 - misses)
	
