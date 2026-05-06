extends MinigameBase

#Game constants
const GRAVITY = 800.0
const MAX_JUMP = 600.0
const CHARGE = 300.0
const X_SPEED = 300.0

#Variables
var tickets = 0
var jump_pwr = 0.0
var is_charging = false

#Objects
@onready var chara = $Char_Hop
@onready var win_lose = $Cnv_Screen/WinLose
@onready var tickets_label = $Cnv_Screen/WinLose/Ctrl_EndScreen/Txt_TicketsWon
@onready var end_image = $Cnv_Screen/WinLose/Ctrl_EndScreen/Img_EndImg

#Initialization 

func _ready():
	chara.up_direction = Vector2.UP
	chara.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED

func start_game():
	pass

#Game
func _physics_process(delta: float):

	if Input.is_action_pressed("jump") and chara.is_on_floor():
		jump_pwr = min(jump_pwr + CHARGE * delta, MAX_JUMP)
		is_charging = true

	if is_charging and not Input.is_action_pressed("jump"):
		chara.velocity.y = -jump_pwr
		chara.velocity.x = X_SPEED
		jump_pwr = 0.0
		is_charging = false

	chara.velocity.y += GRAVITY * delta
	chara.move_and_slide()

	if chara.is_on_floor():
		chara.velocity.y = 0.0
		chara.velocity.x = 0.0

	chara.position.x = clamp(chara.position.x, 50, get_window().size.x - 50)
	if chara.position.x <= 50:
		finish_game()

func finish_game():
	win_lose.visible = true
	tickets_label.text = "You won %d tickets!" % tickets
	end_image.texture = load("res://assets/sprites/ui/game_covers/placeholder.png")
	end_game(tickets)
