extends Control

@onready var label = $MC/Label

func _ready():
	SignalManager.on_score_updated.connect(on_score_updated)



func _process(delta):
	pass

func on_score_updated() -> void:
	label.text = str(ScoreManager.get_score())
