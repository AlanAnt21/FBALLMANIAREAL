extends Node

var game_scene: PackedScene = preload("res://scenes/game/game.tscn")

var score_messi : int = 0
var score_ronaldo : int = 0

var score_last = ""

func load_game_scene():
	get_tree().change_scene_to_packed(game_scene)
