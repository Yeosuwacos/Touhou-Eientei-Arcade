extends MinigameBase

#Constants
const C_DIST = 200
const P_DIST = 100
const SHUFFLES = 25
const S_SPEED = 0.4

#Variables
var tickets = 0
@onready var pos_x = get_viewport().size.x
@onready var pos_y = get_viewport().size.y/2

#Objects
@onready var hud = $HUD
@onready var win_lose = $Cnv_Screen/WinLose
@onready var tickets_label = $Cnv_Screen/WinLose/Ctrl_EndScreen/Txt_TicketsWon
@onready var end_image = $Cnv_Screen/WinLose/Ctrl_EndScreen/Img_EndImg
@onready var cup_array = $HUD/Ctrl_Cups
@onready var prize_cup = $HUD/Ctrl_Cups/Cup_Prize
@onready var empty_cup_1 = $HUD/Ctrl_Cups/Cup_Empty1
@onready var empty_cup_2 = $HUD/Ctrl_Cups/Cup_Empty2
@onready var prize_img = $HUD/Img_Prize

func _ready():
	call_deferred("start_game")

#Initialization 
func start_game():
	randomize()
	prize_cup.selected.connect(_on_selected)
	empty_cup_1.selected.connect(_on_selected)
	empty_cup_2.selected.connect(_on_selected)
	
	prize_cup.position = Vector2(pos_x/2, pos_y)
	prize_img.position = Vector2(prize_cup.position.x, prize_cup.position.y + P_DIST)
	empty_cup_1.position = Vector2(prize_cup.position.x - C_DIST, pos_y)
	empty_cup_2.position = Vector2(prize_cup.position.x + C_DIST, pos_y)
	
	#Cup array
	var cup_list = [prize_cup,empty_cup_1,empty_cup_2]
	await move_cups("down")
	
	#Shuffling sequence
	for n in range(1,SHUFFLES):
		cup_list.shuffle()
		await shuffle_cups(cup_list[0],cup_list[1])
	prize_img.position = Vector2(prize_cup.position.x, prize_cup.position.y + P_DIST)
	prize_img.visible = true
	for cup in cup_list:
		cup.clickable = true

#Hiding sequence
func move_cups(direction):
	var p_dist
	match direction:
		"down": p_dist = P_DIST
		"up": p_dist = -P_DIST
	var anim = create_tween()
	anim.set_parallel(true)
	anim.tween_property(cup_array, "position:y", cup_array.position.y + p_dist, 1.0)
	await anim.finished
	if direction == "down":
		prize_img.visible = false

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
		tickets += 100
	await move_cups("up")
	await get_tree().create_timer(1.0).timeout
	finish_game()

func finish_game():
	tickets_label.text = "You won %d tickets!" % tickets
	end_image.texture = load("res://assets/sprites/ui/game_covers/placeholder.png")
	hud.visible = false
	win_lose.visible = true
	end_game(tickets)
