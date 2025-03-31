extends Area2D

func _ready() -> void:
	# on the target object (in this case, 'self' refers to this Area2D node).
	var body_entered_callable = Callable(self, "_on_body_entered")

	if not is_connected("body_entered", body_entered_callable):
		connect("body_entered", body_entered_callable)

	
	print(self.name + " (Area2D) is ready to detect collisions.")


func _on_body_entered(body: PhysicsBody2D):
	print(self.name + " detected collision with body: " + body.name)
	GameManager.add_score(1)


func _process(_delta: float) -> void:
	pass
