extends MinigameBase

#Game constants
const SPINTIME = 1.0
const REELTIME = 0.2

#Variables
var bet = 0
var winnings = 0
var spinning = false

#Objects
@onready var spin = $T_Spin
@onready var reel = $T_Reel
@onready var bet_label = $HUD/Ctrl_BetAmount/Txt_Bet
@onready var win_label = $HUD/Txt_Winnings

func _ready():
	call_deferred("start_game")
	
#Initialization
func start_game():
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

#Return to games list
func _on_btn_back_pressed():
	end_game(winnings)
	SceneTransition.go_to("res://scenes/game_select/GameSelect.tscn")

#Display update
func update_hud():
	bet_label.text = "%d" % bet
