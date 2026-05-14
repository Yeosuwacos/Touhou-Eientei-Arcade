extends MinigameBase

#Constants

#Variables
var tickets = 0

#Objects
@onready var win_lose = $Cnv_Screen/WinLose
@onready var tickets_label = $Cnv_Screen/WinLose/Ctrl_EndScreen/Txt_TicketsWon
@onready var end_image = $Cnv_Screen/WinLose/Ctrl_EndScreen/Img_EndImg
@onready var slider = $Ctrl_Layout/Ctrl_Slider

func _ready():
	call_deferred("start_game")

func start_game():
	slider.add_theme_constant_override("separation", 400)

func finish_game():
	tickets = 0
	win_lose.visible = true
	tickets_label.text = "You won %d tickets!" % tickets
	end_image.texture = load("res://assets/sprites/ui/game_covers/placeholder.png")
	end_game(tickets)
