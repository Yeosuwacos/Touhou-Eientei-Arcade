extends MinigameBase

#Constants
const START = preload("res://scenes/start/start.tscn")
const CARD = preload("res://scenes/minigames/memory/card/card.tscn")
const CARD_SIZE = Vector2(160, 160)
const T_MULT = 50

#Variables
var tickets = 0
var cards = [1,1,1,2,2,2,3,3,3,4,4,4,5,5,5]
var sel_cards = []
var m_attempts = 3
var tries = 5
var s_matches = 0
var flippable = true

#Objects
@onready var win_lose = $Cnv_Screen/WinLose
@onready var tickets_label = $Cnv_Screen/WinLose/Ctrl_EndScreen/Txt_TicketsWon
@onready var end_image = $Cnv_Screen/WinLose/Ctrl_EndScreen/Img_EndImg
@onready var card_holder = $HUD/Ctrl_CardList
@onready var tries_label = $HUD/Txt_Tries
@onready var cnv_start = $Cnv_Start
@onready var cnv_screen = $Cnv_Screen

func _ready():
	var start = START.instantiate()
	start.start.connect(start_game)
	cnv_start.add_child(start)

#Initialization 
func start_game():
	cnv_start.visible = false
	tries_label.text = "Tries: %d" % tries
	#Adding cards to the board
	randomize()
	cards.shuffle()
	for card_id in cards:
		var addedCard = CARD.instantiate()
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
		s_matches += 1
		for card in sel_cards:
			card.disabled = true
	else:
		tries -= 1
		await get_tree().create_timer(1.0).timeout
		for card in sel_cards:
			card.flip()
	
	tries_label.text = "Tries: %d" % tries
	sel_cards.clear()
	if tries == 0 or s_matches == 5:
		await get_tree().create_timer(1.0).timeout
		for card in card_holder.get_children():
			if card.flipped == false:
				card.flip()
		await get_tree().create_timer(2.0).timeout
		finish_game()

#Game end
func finish_game():
	tickets = s_matches * T_MULT
	cnv_screen.layer = 2
	win_lose.visible = true
	tickets_label.text = "You won %d tickets!" % tickets
	end_image.texture = load("res://assets/sprites/ui/game_covers/placeholder.png")
	end_game(tickets)
