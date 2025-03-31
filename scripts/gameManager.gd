extends Node

signal score_updated(new_score: int)

var score: int = 0

func _ready():
	print("GameManager Autoload Ready!") 
	
func add_score(amount: int):
	score += amount
	emit_signal("score_updated", score)
