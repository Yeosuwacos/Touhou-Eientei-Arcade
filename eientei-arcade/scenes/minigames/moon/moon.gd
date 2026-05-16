extends MinigameBase

#Constants
const START = preload("res://scenes/start/start.tscn")
const NOTE = preload("res://scenes/minigames/moon/note/note.tscn")
const COLORS = ["red","blue","yellow","green"]
const BPM = 120.0
const BEAT = 60.0/BPM

#Variables
var tickets = 0
var n_length = {"whole": BEAT * 4.0, "half": BEAT * 2.0, "quarter": BEAT, "eighth": BEAT * 0.5}
var n_next = 0.0
var p_current = []
var p_index = 0
var score = 0
var p_rem = 10

#Objects
@onready var win_lose = $Cnv_Screen/WinLose
@onready var tickets_label = $Cnv_Screen/WinLose/Ctrl_EndScreen/Txt_TicketsWon
@onready var end_image = $Cnv_Screen/WinLose/Ctrl_EndScreen/Img_EndImg
@onready var n_spawn = $Ctrl_Layout/Ctrl_Spawn_Pos/Img_Spawner
@onready var n_input = $Ctrl_Layout/Area_Target
@onready var container = $NoteContainer
@onready var hit_indicator = $HUD/Txt_Hit
@onready var score_label = $HUD/Txt_Score
@onready var layout = $Ctrl_Layout
@onready var cnv_start = $Cnv_Start
@onready var cnv_screen = $Cnv_Screen

func _ready():
	set_physics_process(false)
	var start = START.instantiate()
	start.start.connect(start_game)
	cnv_start.add_child(start)

#Initialization
func start_game():
	set_physics_process(true)
	cnv_start.visible = false
	n_spawn.global_position.x = get_viewport().size.x/2 + get_viewport().size.x/4
	n_input.global_position.x = n_spawn.global_position.x - 600
	hit_indicator.position = Vector2(n_input.global_position.x, n_input.global_position.y - 60)
	score_label.text = "Score: 0"
	p_current = p_random()
	p_rem -= 1

#Game
func _physics_process(delta: float):
	if p_rem <= 0:
		await get_tree().create_timer(3.0).timeout
		finish_game()
		return
	n_next -= delta
	if n_next <= 0:
		if p_index >= p_current.size():
			p_current = p_random()
			p_index = 0
			p_rem -= 1
			
		var n_type = p_current[p_index]
		p_index += 1
		spawn_note()
		n_next = n_length[n_type]

#Note spawner
func spawn_note():
	var note = NOTE.instantiate()
	note.color = COLORS.pick_random()
	note.position = n_spawn.global_position
	note.hit.connect(_on_note_hit)
	note.miss.connect(_on_note_missed)
	container.add_child(note)
	
#Random note
func p_random():
	var patterns = [
		["quarter", "quarter", "quarter", "quarter"],
		["half", "quarter", "quarter"],
		["eighth", "eighth", "quarter", "half"],
		["quarter", "eighth", "eighth", "quarter"]
	]
	return patterns.pick_random()

#Hitting a note
func _on_note_hit():
	hit_indicator.text = "O"
	score += 5
	score_label.text = "Score: %d" % score

#Missing a note
func _on_note_missed():
	hit_indicator.text = "X"

#End game
func finish_game():
	set_physics_process(false)
	tickets = score
	cnv_screen.layer = 2
	win_lose.visible = true
	tickets_label.text = "You won %d tickets!" % tickets
	end_image.texture = load("res://assets/sprites/ui/game_covers/placeholder.png")
	end_game(tickets)
