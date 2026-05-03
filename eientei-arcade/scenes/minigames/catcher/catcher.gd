extends MinigameBase

#Game constants
const BAMBOO = preload("res://scenes/minigames/catcher/Bamboo/bamboo.tscn")
const DURATION = 60.0
const LIVES = 5
const INTERVAL = 1.2

#Variables
var score := 0
var misses := 0
var time = DURATION

#Objects
@onready var chara = $Char_Catcher
@onready var spawner = $T_Spawner
@onready var gametime = $T_Game
