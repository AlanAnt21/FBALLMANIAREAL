extends Node

var game_scene: PackedScene = preload("res://scenes/game/game.tscn")
var replay_scene: PackedScene = preload("res://scenes/rplay/replay.tscn")
var score_messi : int = 0
var score_ronaldo : int = 0

var score_last = ""

var time = 0
var ronaldo_ghost = []
var messi_ghost = []
var football_ghost = []

func load_game_scene():
	get_tree().change_scene_to_packed(replay_scene)
