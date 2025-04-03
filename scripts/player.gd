extends CharacterBody2D

signal jump_charge_started
signal jump_charge_updated(charge_ratio: float)
signal jump_charge_ended

const SPEED = 75.0
const GRAVITY = 980.0

const MAX_JUMP_VELOCITY = -350.0
const MIN_JUMP_VELOCITY = -100.0
const JUMP_CHARGE_DURATION = 0.75

var is_charging_jump = false
var jump_charge_timer = 0.0

func _physics_process(delta: float) -> void:
	var on_floor = is_on_floor()

	# --- 1. Apply Gravity ---
	if not on_floor:
		velocity.y += GRAVITY * delta

	# --- 2. Handle Jump Logic ---
	var jump_pressed = Input.is_action_pressed("jump")
	var jump_just_released = Input.is_action_just_released("jump")

	# Cancel charge if falling
	if not on_floor and is_charging_jump:
		print("Charge cancelled due to falling")
		is_charging_jump = false
		jump_charge_timer = 0.0
		jump_charge_ended.emit()

	# Start or Restart Charging
	if on_floor and jump_pressed and not is_charging_jump:
		is_charging_jump = true
		jump_charge_timer = 0.0
		jump_charge_started.emit()
		print("Started/Restarted charging jump")

	# Continue Charging
	if on_floor and jump_pressed and is_charging_jump:
		jump_charge_timer += delta
		jump_charge_timer = min(jump_charge_timer, JUMP_CHARGE_DURATION)
		var charge_ratio: float = 0.0
		if JUMP_CHARGE_DURATION > 0:
			charge_ratio = clamp(jump_charge_timer / JUMP_CHARGE_DURATION, 0.0, 1.0)
		jump_charge_updated.emit(charge_ratio)

	# Execute Jump on Release
	if jump_just_released and is_charging_jump:
		var charge_ratio: float = 0.0
		if JUMP_CHARGE_DURATION > 0:
			charge_ratio = clamp(jump_charge_timer / JUMP_CHARGE_DURATION, 0.0, 1.0)

		velocity.y = lerp(MIN_JUMP_VELOCITY, MAX_JUMP_VELOCITY, charge_ratio)
		print("Jumped with force: ", velocity.y, " (Charge ratio: ", charge_ratio, ")")

		jump_charge_ended.emit()
		is_charging_jump = false
		jump_charge_timer = 0.0


	# --- 3. Handle Horizontal Movement ---
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# --- 4. Apply Movement and Collision ---
	move_and_slide()
