# HUD.gd
extends CanvasLayer

@onready var score_label: Label = $scoreLabel

func _ready() -> void:
	# --- Add this line for debugging ---
	# print("Registered Autoloads: ", Engine.get_singleton_list()) # Can comment out if needed
	# -----------------------------------

	if not Engine.has_singleton("GameManager"):
		push_error("Autoload 'GameManager' not found! Check spelling in Project Settings -> Autoload.")
		return

	if not score_label:
		push_error("Child node 'scoreLabel' not found in HUD scene!")
		return

	print("HUD: Connecting signal...") # DEBUG
	GameManager.connect("score_updated", Callable(self, "_on_GameManager_score_updated"))

	print("HUD: Calling initial score update. GameManager.score = ", GameManager.score) # DEBUG
	_on_GameManager_score_updated(GameManager.score) # Call initial update

	print("HUD: _ready finished.") # DEBUG


func _on_GameManager_score_updated(new_score):
	# ADD THESE DEBUG LINES:
	print("HUD: _on_GameManager_score_updated called. new_score = ", new_score)

	if score_label:
		print("HUD: score_label exists. Current text = '", score_label.text, "'") # See current text
		var text_to_set = "Score: " + str(new_score)
		print("HUD: Attempting to set text to = '", text_to_set, "'")
		score_label.text = text_to_set
		# Check text IMMEDIATELY after setting it
		print("HUD: Text set. score_label.text is now = '", score_label.text, "'")
	else:
		print("HUD: scoreLabel reference lost!")
