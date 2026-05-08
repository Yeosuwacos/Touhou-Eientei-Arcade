class_name MinigameBase
extends Node

signal game_finished(tickets_won)

func start_game():
	pass

func end_game(tickets_won):
	game_finished.emit(tickets_won)
	GameManager.tickets += tickets_won
