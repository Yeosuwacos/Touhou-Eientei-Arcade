extends MinigameBase

#Constants
const C_DIST = 200
const SHUFFLES = 25
const S_SPEED = 0.4

#Variables
var tickets = 0
@onready var pos_x = get_viewport().size.x
@onready var pos_y = get_viewport().size.y/2

#Objects
@onready var win_lose = $Cnv_Screen/WinLose
@onready var hud = $HUD
@onready var prize_cup = $HUD/Cup_Prize
@onready var empty_cup_1 = $HUD/Cup_Empty1
@onready var empty_cup_2 = $HUD/Cup_Empty2

func _ready():
	call_deferred("start_game")

#Initialization 
func start_game():
	randomize()
	prize_cup.position = Vector2(pos_x/2, pos_y)
	empty_cup_1.position = Vector2(prize_cup.position.x - C_DIST, pos_y)
	empty_cup_2.position = Vector2(prize_cup.position.x + C_DIST, pos_y)
	
	#Cup array
	var cup_list = [prize_cup,empty_cup_1,empty_cup_2]
	
	#Shuffling sequence
	for n in range(1,SHUFFLES):
		cup_list.shuffle()
		await shuffle_cups(cup_list[0],cup_list[1],n)

#Cup shuffling
func shuffle_cups(c1,c2,reps):
	var p1 = c1.global_position
	var p2 = c2.global_position
	var anim = create_tween()
	anim.set_parallel(true)
	anim.tween_property(c1, "global_position", p2, S_SPEED)
	anim.tween_property(c2, "global_position", p1, S_SPEED)
	await anim.finished

func finish_game():
	win_lose.visible = true
	end_game(tickets)
