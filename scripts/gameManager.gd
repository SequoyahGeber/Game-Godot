extends Node

signal score_updated(new_score: int)

signal lives_updated(new_lives: int)


var score: int = 0
var lives: int = 3

var spawnX: int = 0
var spawnY: int = 5

func _ready():
	print("GameManager Autoload Ready!")
	
func add_score(amount: int):
	score += amount
	emit_signal("score_updated", score)
	
func lose_life(amount: int):
	lives -= amount
	emit_signal("lives_updated", lives)
