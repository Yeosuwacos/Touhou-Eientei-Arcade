extends MinigameBase

#Game constants
const SPINTIME = 1.0
const OUTCOME = ["s_win", "m_win", "l_win"]
const PAYOUT = {
	"lose": 0,
	"s_win": 2,
	"m_win": 3,
	"l_win": 6
}

#Variables
var bet = 0
var reel1 = ""
var reel2 = ""
var reel3 = ""
var winnings = 0
var spinning = false
var pity = 0
var max_pity = 4

#Objects
@onready var spin = $T_Spin
@onready var bet_label = $HUD/Ctrl_BetInterface/Ctrl_BetAmount/Txt_Bet
@onready var ticket_label = $HUD/Txt_Tickets
@onready var btn_roll = $HUD/Ctrl_BetInterface/Btn_Roll
@onready var btn_raise = $HUD/Ctrl_BetInterface/Ctrl_BetAmount/Btn_Raise
@onready var btn_lower = $HUD/Ctrl_BetInterface/Ctrl_BetAmount/Btn_Lower
@onready var spin_results = $HUD/Ctrl_Screen/Txt_Outcome
@onready var reel1img = $HUD/Ctrl_Screen/Ctrl_Reels/Img_Reel1
@onready var reel2img = $HUD/Ctrl_Screen/Ctrl_Reels/Img_Reel2
@onready var reel3img = $HUD/Ctrl_Screen/Ctrl_Reels/Img_Reel3

func _ready():
	call_deferred("start_game")
	
#Initialization
func start_game():
	ticket_label.text = "%d" % GameManager.tickets
	reel1img.texture = preload("res://assets/sprites/common/sprite_placeholder.png")
	reel2img.texture = preload("res://assets/sprites/common/sprite_placeholder.png")
	reel3img.texture = preload("res://assets/sprites/common/sprite_placeholder.png")
	update_hud()

#Raise and lower bet
func _on_btn_raise_pressed():
	if bet < 100:
		bet += 10
		update_hud()

func _on_btn_lower_pressed():
	if bet > 0:
		bet -= 10
		update_hud()

#Begin rolling
func _on_btn_roll_pressed():
	reel1img.texture = preload("res://assets/sprites/common/sprite_placeholder.png")
	reel2img.texture = preload("res://assets/sprites/common/sprite_placeholder.png")
	reel3img.texture = preload("res://assets/sprites/common/sprite_placeholder.png")
	spin_results.text = ""
	if bet > 0 and GameManager.tickets >= bet:
		btn_roll.disabled = true
		GameManager.tickets -= bet
		reel1 = OUTCOME.pick_random()
		reel2 = OUTCOME.pick_random()
		reel3 = OUTCOME.pick_random()
		update_hud()
		spin.start()

#Timeout
func _on_t_spin_timeout():
	spin.stop()
	btn_roll.disabled = false
	reel1img.texture = load(get_img(reel1))
	reel2img.texture = load(get_img(reel2))
	reel3img.texture = load(get_img(reel3))
	if pity < max_pity:
		if reel1 == reel2 and reel2 == reel3:
			get_win(reel1)
			pity = 0
		else:
			get_win("lose")
			pity += 1
	else:
		if reel1 == "lose":
			reel1 = "s_win"
		reel1img.texture = load(get_img(reel1))
		reel2img.texture = load(get_img(reel1))
		reel3img.texture = load(get_img(reel1))
		get_win(reel1)
		pity = 0

#Winnings
func get_win(type):
	winnings = PAYOUT[type]*bet
	match type:
		"lose":
			spin_results.text = "Lose! + %d tickets" % winnings
		"s_win":
			spin_results.text = "Win! + %d tickets" % winnings
		"m_win":
			spin_results.text = "Big win! + %d tickets" % winnings
		"l_win":
			spin_results.text = "Jackpot! + %d tickets" % winnings
	max_pity = randi_range(1,4)
	GameManager.tickets += winnings
	update_hud()

#Returns icon
func get_img(type):
	match type:
		"lose":
			return "res://assets/sprites/common/p_red.png"
		"s_win":
			return "res://assets/sprites/common/p_yellow.png"
		"m_win":
			return "res://assets/sprites/common/p_green.png"
		"l_win":
			return "res://assets/sprites/common/p_blue.png"

#Return to games list
func _on_btn_back_pressed():
	end_game(0)
	SceneTransition.go_to("res://scenes/game_select/GameSelect.tscn")

#Display update
func update_hud():
	bet_label.text = "%d" % bet
	ticket_label.text = "%d" % GameManager.tickets
