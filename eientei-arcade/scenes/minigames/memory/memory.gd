extends MinigameBase

#Constants

#Variables
var tickets = 0
var cards = [1,1,1,2,2,2,3,3,3,4,4,4,5,5,5]

#Objects
@onready var win_lose = $Cnv_Screen/WinLose
@onready var tickets_label = $Cnv_Screen/WinLose/Ctrl_EndScreen/Txt_TicketsWon
@onready var end_image = $Cnv_Screen/WinLose/Ctrl_EndScreen/Img_EndImg
@onready var card_holder = $HUD/Ctrl_CardList

func _ready():
	call_deferred("start_game")

#Initialization 
func start_game():
	#Adding cards to the board
	randomize()
	cards.shuffle()
	for card_id in cards:
		var addedCard = Card.new()
		addedCard.number = card_id
		addedCard.cover = load("res://assets/sprites/ui/game_covers/placeholder.png")
		match card_id:
			1: addedCard.illust = load("res://assets/sprites/common/sprite_placeholder.png")
			2: addedCard.illust = load("res://assets/sprites/common/p_red.png")
			3: addedCard.illust = load("res://assets/sprites/common/p_yellow.png")
			4: addedCard.illust = load("res://assets/sprites/common/p_green.png")
			5: addedCard.illust = load("res://assets/sprites/common/p_blue.png")
		card_holder.add_child(addedCard)

#Game end
func finish_game():
	win_lose.visible = true
	tickets_label.text = "You won %d tickets!" % tickets
	end_image.texture = load("res://assets/sprites/ui/game_covers/placeholder.png")
	end_game(tickets)
