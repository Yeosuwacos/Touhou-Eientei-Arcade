extends MinigameBase

#Constants
const CARD_SIZE = Vector2(160, 160)

#Variables
var tickets = 0
var cards = [1,1,1,2,2,2,3,3,3,4,4,4,5,5,5]
var sel_cards = []
var m_attempts = 3
var tries = 5
var flippable = true

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
		addedCard.custom_minimum_size = CARD_SIZE
		addedCard.size = CARD_SIZE
		addedCard.number = card_id
		addedCard.cover = load("res://assets/sprites/ui/game_covers/placeholder.png")
		match card_id:
			1: addedCard.illust = load("res://assets/sprites/common/sprite_placeholder.png")
			2: addedCard.illust = load("res://assets/sprites/common/p_red.png")
			3: addedCard.illust = load("res://assets/sprites/common/p_yellow.png")
			4: addedCard.illust = load("res://assets/sprites/common/p_green.png")
			5: addedCard.illust = load("res://assets/sprites/common/p_blue.png")
		card_holder.add_child(addedCard)
		addedCard.card_flipped.connect(_on_card_flipped)
		card_holder.add_theme_constant_override("h_separation", 32)
		card_holder.add_theme_constant_override("v_separation", 32)

#Flip detection
func _on_card_flipped(card):
	if not flippable:
		return
	if card.flipped:
		return
	card.flip()
	sel_cards.append(card)
	if sel_cards.size() == 3:
		flippable = false
		await check_match()
		flippable = true
	
#Checking a match
func check_match():
	var matching = true
	var first_id = sel_cards[0].number
	for card in sel_cards:
		if card.number != first_id:
			matching = false
			break
	
	if matching:
		for card in sel_cards:
			card.disabled = true
	else:
		await get_tree().create_timer(1.0).timeout
		for card in sel_cards:
			card.flip()

	sel_cards.clear()

#Game end
func finish_game():
	win_lose.visible = true
	tickets_label.text = "You won %d tickets!" % tickets
	end_image.texture = load("res://assets/sprites/ui/game_covers/placeholder.png")
	end_game(tickets)
