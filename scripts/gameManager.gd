extends Node

signal score_updated(new_score: int)

signal lives_updated(new_lives: int)

signal player_died

@export var initial_lives: int = 3
@export var reset_score_on_death: bool = true

var score: int = 0:
	set(value):
		score = value
		emit_signal("score_updated", score)
var lives: int = 3:
	set(value):
		lives = max(0, value)
		emit_signal("lives_updated", lives)
		if lives <= 0: _handle_player_death()


func _ready():
	print("GameManager Autoload Ready!")
	lives = initial_lives
	score = 0
	
func add_score(amount: int):
	self.score += amount
	emit_signal("score_updated", score)
	
func lose_life(amount: int):
	self.lives -= amount
	emit_signal("lives_updated", lives)

var player_start_position: Vector2 = Vector2.ZERO


func register_player_start_position(position: Vector2):
	print("GameManager: Player registered start position:", position)
	player_start_position = position

func get_player_start_position() -> Vector2:
	return player_start_position

func _handle_player_death():
	print("GameManager: Player has run out of lives!")
	emit_signal("player_died")


	call_deferred("_reset_state")


func _reset_state():
	print("GameManager: Resetting state (Lives and Score).")

	self.lives = initial_lives

	if reset_score_on_death:
		self.score = 0
