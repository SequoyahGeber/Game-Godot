# HUD.gd
extends CanvasLayer

@onready var score_label: Label = $scoreLabel

func _ready() -> void:
	# --- Add this line for debugging ---
	print("Registered Autoloads: ", Engine.get_singleton_list())
	# -----------------------------------

	# Check if gameManager exists USING THE CORRECT NAME FROM SETTINGS
	if not Engine.has_singleton("gameManager"):
		push_error("Autoload 'gameManager' not found! Check spelling in Project Settings -> Autoload.")
		return # Stop if gameManager isn't ready

	# ... (rest of the function remains the same) ...
	if not score_label:
		push_error("Child node 'scoreLabel' not found in HUD scene!")
		return

	gameManager.connect("score_updated", Callable(self, "_on_GameManager_score_updated"))
	_on_GameManager_score_updated(gameManager.score)

func _on_GameManager_score_updated(new_score):
	# ... (rest of the function remains the same) ...
	if score_label:
		score_label.text = "Score: " + str(new_score)
	else:
		print("scoreLabel reference lost!")
