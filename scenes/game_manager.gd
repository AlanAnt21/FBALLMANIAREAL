extends Node

var game_scene: PackedScene = preload("res://scenes/game/game.tscn")
var replay_scene: PackedScene = preload("res://scenes/rplay/replay.tscn")
var score_messi : int = 0
var score_ronaldo : int = 0

var score_last = ""

var time = 100
var ronaldo_ghost = []
var messi_ghost = []
var football_ghost = []
var ball_vel = 0

func load_replay_scene():
	get_tree().change_scene_to_packed(replay_scene)
	
func load_game_scene():
	ball_vel = football_ghost.back()[2].length() / 6
	ronaldo_ghost = []
	messi_ghost = []
	football_ghost = []
	get_tree().change_scene_to_packed(game_scene)
	
