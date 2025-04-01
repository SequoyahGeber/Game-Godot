# HUD.gd
extends CanvasLayer

# Get references to the labels in the scene tree
# Ensure you have nodes named "scoreLabel" and "livesLabel" as children of HUD
@onready var score_label: Label = $scoreLabel
@onready var lives_label: Label = $livesLabel 
func _ready() -> void:
	# --- Node Checks ---
	var nodes_ok = true
	if not score_label:
		push_error("Child node 'scoreLabel' not found in HUD scene!")
		nodes_ok = false
	if not lives_label:
		push_error("Child node 'livesLabel' not found in HUD scene!") 
		nodes_ok = false

	if not nodes_ok:
		printerr("HUD: Required Label nodes missing. Aborting setup.")
		return 


	print("HUD: Setting up Score display...")
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


	print("HUD: _ready finished.") 



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
