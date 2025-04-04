extends Area2D


const player_group = "player"


func _ready() -> void:
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

	print(self.name + " (Area2D) is ready to detect collisions.")


func _on_body_entered(body: Node):
	if body.is_in_group(player_group):
		print(self.name + " detected collision with body: " + body.name)
		GameManager.lose_life(1)


func _process(_delta: float) -> void:
	pass
