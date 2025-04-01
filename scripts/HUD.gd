# HUD.gd
extends CanvasLayer

# Get references to the labels in the scene tree
# Ensure you have nodes named "scoreLabel" and "livesLabel" as children of HUD
@onready var score_label: Label = $scoreLabel
@onready var lives_label: Label = $livesLabel
@onready var charge_bar: TextureProgressBar = $jumpChargeBar

var player_node: CharacterBody2D = null

@export var charge_bar_offset: Vector2 = Vector2(0, -40)

func _ready() -> void:
	# --- Node Checks ---
	var nodes_ok = true
	if not score_label:
		push_error("HUD: Child node 'scoreLabel' not found!")
		nodes_ok = false
	if not lives_label:
		push_error("HUD: Child node 'livesLabel' not found!")
		nodes_ok = false
	# Add check for the charge bar
	if not charge_bar:
		push_error("HUD: Child node 'jumpChargeBar' not found!")
		nodes_ok = false
	else:
		charge_bar.visible = false
		charge_bar.value = 0.0

	if not nodes_ok:
		printerr("HUD: Required Label nodes missing. Aborting setup.")
		return


	print("HUD: Setting up GameManager connections...")
	if GameManager.has_signal("score_updated"):
		GameManager.connect("score_updated", Callable(self, "_on_GameManager_score_updated"))
		print("HUD: Calling initial score update. GameManager.score = ", GameManager.score)
		_on_GameManager_score_updated(GameManager.score)
	else:
		printerr("HUD: GameManager is missing the 'score_updated' signal!")


	print("HUD: Setting up Lives display...")
	
	if GameManager.has_signal("lives_updated"):
		GameManager.connect("lives_updated", Callable(self, "_on_GameManager_lives_updated"))

		print("HUD: Calling initial lives update. GameManager.lives = ", GameManager.lives)
		_on_GameManager_lives_updated(GameManager.lives)
	else:
		printerr("HUD: GameManager is missing the 'lives_updated' signal!")

	print("HUD: Attempting to connect to Player signals...")
	call_deferred("find_player_and_connect")
	print("HUD: _ready finished.")

func find_player_and_connect():
	var players = get_tree().get_node_in_group("player")
	if not players.is_empty():
		player_node = players[0] as CharacterBody2D
		if player_node and player_node.has_signal("jump_chage_started"):
			player_node.jump_charge_started.connect()
		


func _on_GameManager_score_updated(new_score):
	print("HUD: _on_GameManager_score_updated called. new_score = ", new_score) # DEBUG

	if score_label:
		print("HUD: score_label exists. Current text = '", score_label.text, "'") # See current text
		var text_to_set = "Score: " + str(new_score)
		print("HUD: Attempting to set text to = '", text_to_set, "'")
		score_label.text = text_to_set
		print("HUD: Text set. score_label.text is now = '", score_label.text, "'") # DEBUG
	else:
		print("HUD: scoreLabel reference lost!")


func _on_GameManager_lives_updated(new_lives):
	print("HUD: _on_GameManager_lives_updated called. new_lives = ", new_lives) # DEBUG

	if lives_label:
		print("HUD: lives_label exists. Current text = '", lives_label.text, "'") # See current text
		var text_to_set = "Lives: " + str(new_lives)
		print("HUD: Attempting to set text to = '", text_to_set, "'")
		lives_label.text = text_to_set
		print("HUD: Text set. lives_label.text is now = '", lives_label.text, "'") # DEBUG
	else:
		print("HUD: livesLabel reference lost!")
