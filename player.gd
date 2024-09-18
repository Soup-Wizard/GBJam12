extends CharacterBody2D

## Worm Dash - Player dashes forward quickly with a slight upward arc
## Worm Jump - Player launches upward, can be done in the air

const SPEED = 100.0
const DASH_SPEED = 175
const JUMP_VELOCITY = -225.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var worms = 0
var bones = 0
var canTele = false
var teleCoords: Vector2
var canDash = false
var canJump = false
var dashing = false
var jumping = false

func playerTele():
	if canTele == true:
		position = teleCoords
		canTele = false
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle wells
	if Input.is_action_just_pressed("down"):
		playerTele()
	
	if Input.is_action_just_pressed("Pow1"):
		if canJump:
			if !jumping:
				jumping = true
				$jumpTimer.start()
				velocity.y = JUMP_VELOCITY * 1.5
	
	if Input.is_action_just_pressed("Pow2"):
		if canDash:
			canDash = false
			dashing = true
			$dashTimer.start()
			$dashCooldown.start()
			if $AnimatedSprite2D.flip_h:
				velocity.y = JUMP_VELOCITY * 0.6
				velocity.x = DASH_SPEED * -4
			else:
				velocity.y = JUMP_VELOCITY * 0.6
				velocity.x = DASH_SPEED * 4
	
	var direction = Input.get_axis("left", "right")
	if direction:
		if !dashing:
			velocity.x = direction * SPEED
			if direction < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	move_and_slide()


func _on_dash_timer_timeout():
	dashing = false


func _on_jump_timer_timeout():
	jumping = false


func _on_dash_cooldown_timeout():
	canDash = true
