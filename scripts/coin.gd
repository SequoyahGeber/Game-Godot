extends Area2D

func _ready() -> void:
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

	print(self.name + " (Area2D) is ready to detect collisions.")

func _on_body_entered(body: Node):
	print(self.name + " detected collision with body: " + body.name)
	GameManager.add_score(1)
	self.queue_free()


func _process(_delta: float) -> void:
	pass
