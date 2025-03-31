extends Node

signal score_updated(new_score: int)

var score: int = 0

func _ready():
	print("GameManager Autoload Ready!") # Add this to see if it even runs

func add_score(amount: int):
	score += amount
	emit_signal("score_updated", score)

# Add any other essential functions/variables your game needs from here
# var lives: int = 3
