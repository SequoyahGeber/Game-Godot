extends CharacterBody2D


signal jump_charge_started
signal jump_charge_updated(charge_ratio: float)
signal jump_charge_ended


const SPEED = 100
const GRAVITY = 980.0

const MAX_JUMP_VELOCITY = -350.0
const MIN_JUMP_VELOCITY = -100.0
const JUMP_CHARGE_DURATION = 0.75

var is_charging_jump = false
var jump_charge_timer = 0.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

		if is_charging_jump:
			is_charging_jump = false
			jump_charge_timer = 0.0
			print("Charge cancelled due to falling")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_charging_jump = true
		jump_charge_timer = 0.0
		print("Started charging jump")


	# Check if charging AND if the button is *still held down*
	if is_charging_jump and Input.is_action_pressed("jump"):
		if is_on_floor():
			jump_charge_timer += delta
			jump_charge_timer = min(jump_charge_timer, JUMP_CHARGE_DURATION)
			print("Charging: ", jump_charge_timer / JUMP_CHARGE_DURATION)
		else:
			is_charging_jump = false
			jump_charge_timer = 0.0
			print("Charge cancelled immediately (left floor after press)")


	if Input.is_action_just_released("jump") and is_charging_jump:
		var charge_ratio: float = 0.0
		
		if JUMP_CHARGE_DURATION > 0:
			charge_ratio = clamp(jump_charge_timer / JUMP_CHARGE_DURATION, 0.0, 1.0)

		# Calculate the actual jump velocity using lerp
		velocity.y = lerp(MIN_JUMP_VELOCITY, MAX_JUMP_VELOCITY, charge_ratio)

		print("Jumped with force: ", velocity.y, " (Charge ratio: ", charge_ratio, ")")

		# Reset the charging state AFTER applying velocity
		is_charging_jump = false
		jump_charge_timer = 0.0


	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()
