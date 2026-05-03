extends MinigameBase

#Game constants
const BAMBOO = preload("res://scenes/minigames/catcher/Bamboo/bamboo.tscn")
const DURATION = 60.0
const LIVES = 5
const INTERVAL = 1.2

#Variables
var score := 0
var misses := 0
var time = DURATION

#Objects
@onready var chara = $Char_Catcher
@onready var spawner = $T_Spawner
@onready var gametime = $T_Game
@onready var container = $BambooContainer
@onready var score_label = $HUD/Txt_Score
@onready var lives_label = $HUD/Txt_Lives
@onready var time_label = $HUD/Ctrl_Display/Txt_Time


func _ready():
	call_deferred("start_game")

#Initialization 
func start_game():
	score = 0
	misses = 0
	time = DURATION
	spawner.wait_time = INTERVAL
	spawner.start()
	gametime.wait_time = DURATION
	gametime.start()
	update_hud()

#Game
func _process(delta: float):
	time -= delta
	time_label.text = "Time: %d" % ceil(time)
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("left"):
		velocity.x = -400
	elif Input.is_action_pressed("right"):
		velocity.x = 400
	chara.velocity = velocity
	chara.move_and_slide()
	chara.position.x = clamp(chara.position.x, 50, get_window().size.x - 50)

#Bamboo physics
func _on_t_spawner_timeout():
	var bamboo = BAMBOO.instantiate()
	container.add_child(bamboo)
	bamboo.position.x = randf_range(50,get_window().size.x - 50)
	bamboo.position.y = -50
	bamboo.caught.connect(_on_bamboo_caught)
	bamboo.missed.connect(_on_bamboo_missed)

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
	spawner.stop()
	gametime.stop()
	for bamboo in container.get_children():
		bamboo.queue_free()
	var tickets = score * 5
	end_game(tickets)

#Display update
func update_hud():
	score_label.text = "Bamboo caught: %d" % score
	lives_label.text = "Lives: %d" % (5 - misses)
	
