extends MinigameBase

#Constants
const C_DIST = 200
const P_DIST = 200
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
@onready var prize_img = $HUD/Cup_Prize/Img_Prize
@onready var p_cup_img = $HUD/Cup_Prize/Img_Cup
@onready var empty_cup_1 = $HUD/Cup_Empty1
@onready var empty_cup_2 = $HUD/Cup_Empty2
@onready var a_1 = $Cnv_Anchors/Anchor1
@onready var a_2 = $Cnv_Anchors/Anchor2
@onready var a_3 = $Cnv_Anchors/Anchor3
@onready var a_4 = $Cnv_Anchors/Anchor_Prize

func _ready():
	call_deferred("start_game")

#Initialization 
func start_game():
	randomize()
	prize_cup.selected.connect(_on_selected)
	empty_cup_1.selected.connect(_on_selected)
	empty_cup_2.selected.connect(_on_selected)
	
	prize_cup.position = Vector2(pos_x/2, pos_y)
	prize_img.position = Vector2(p_cup_img.size.x/2, P_DIST)
	empty_cup_1.position = Vector2(prize_cup.position.x - C_DIST, pos_y)
	empty_cup_2.position = Vector2(prize_cup.position.x + C_DIST, pos_y)
	
	a_1.position = Vector2(empty_cup_1.position.x, empty_cup_1.position.y + P_DIST)
	a_2.position = Vector2(prize_cup.position.x, prize_cup.position.y + P_DIST)
	a_3.position = Vector2(empty_cup_2.position.x, empty_cup_2.position.y + P_DIST)
	a_4.position = prize_img.position
	
	#Cup array
	var cup_list = [prize_cup,empty_cup_1,empty_cup_2]
	await lower_cups()
	
	#Shuffling sequence
	for n in range(1,SHUFFLES):
		cup_list.shuffle()
		await shuffle_cups(cup_list[0],cup_list[1])

#Cup lowering
func lower_cups():
	var c1 = empty_cup_1
	var c2 = prize_cup
	var c3 = empty_cup_2
	var p_img = prize_img
	
	var a1 = a_1.global_position
	var a2 = a_2.global_position
	var a3 = a_3.global_position
	var a4 = a_4.global_position
	
	var anim = create_tween()
	anim.set_parallel(true)
	anim.tween_property(c1, "global_position", a1, 1)
	anim.tween_property(c2, "global_position", a2, 1)
	anim.tween_property(c3, "global_position", a3, 1)
	anim.tween_property(p_img, "global_position", a4, 1)
	await anim.finished

#Cup shuffling
func shuffle_cups(c1,c2):
	var p1 = c1.global_position
	var p2 = c2.global_position
	var anim = create_tween()
	anim.set_parallel(true)
	anim.tween_property(c1, "global_position", p2, S_SPEED)
	anim.tween_property(c2, "global_position", p1, S_SPEED)
	await anim.finished

#Selection
func _on_selected(shell):
	if shell.has_prize:
		pass
	else:
		pass

func finish_game():
	win_lose.visible = true
	end_game(tickets)
