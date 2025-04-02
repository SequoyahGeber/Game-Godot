extends AnimatableBody2D


@export var speed: float = 25.0
@export var point_a: Marker2D
@export var point_b: Marker2D
@export var start_a_point_a: bool = true


var target_position: Vector2
var point_a_pos: Vector2
var point_b_pos: Vector2


func _ready() -> void:
	if not point_a:
		push_error("MovingPlatform: Point A marker is not assigned")
		set_physics_process(false)
		return
	if not point_b:
		push_error("MovingPlatform: Point A marker is not assigned")
		set_physics_process(false)
		return
	point_a_pos = point_a.global_position
	point_b_pos = point_b.global_position

	if start_a_point_a:
		global_position = point_a_pos
		target_position = point_b_pos
	else:
		global_position = point_b_pos
		target_position = point_a_pos

	point_a.visible = false
	point_b.visible = false


func _physics_process(delta: float) -> void:
	var direction: Vector2 = (target_position - global_position).normalized()
	var distance_to_target: float = global_position.distance_to(target_position)
	var move_distance: float = speed * delta

	if move_distance >= distance_to_target:
		global_position = target_position

		if target_position == point_a_pos:
			target_position = point_b_pos
		else:
			target_position = point_a_pos
	else:
		global_position += direction * move_distance
