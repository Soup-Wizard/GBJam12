extends CharacterBody2D

const SPEED = 100.0
const DASH_SPEED = 175
const JUMP_VELOCITY = -225.0
const BOUNCE_STRENGTH = 375

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var worms = 0
var bones = 0
var lives = 3
var canTele = false
var teleCoords: Vector2
var canDash = false
var canJump = false
var dashing = false
var jumping = false
var is_grounded

func playerTele():
	if canTele:
		position = teleCoords
		canTele = false

func on_collision_with_enemy(enemy_position: Vector2):
	# Calculate the direction from the enemy to the player
	var bounce_direction = (position - enemy_position).normalized()
	
	if is_grounded:
		velocity.y = BOUNCE_STRENGTH
	# Apply the bounce in the opposite direction
	velocity = bounce_direction * BOUNCE_STRENGTH

func _physics_process(delta):
	#Handle Bones & Lives
	$Bones/Label.text = ": " + str(bones)
	$Bones/Label2.text = ": " + str(lives)
	if lives == 2:
		$Bones/Sprite2D2.frame = 1
	elif lives == 1:
		$Bones/Sprite2D2.frame = 0
	elif lives == 0:
		$Bones/Sprite2D2.flip_v = true
	
	is_grounded = is_on_floor()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor() and lives >= 1:
		velocity.y = JUMP_VELOCITY
	
	# Handle wells
	if Input.is_action_just_pressed("down") and lives >= 1:
		playerTele()
	
	if Input.is_action_just_pressed("Pow1") and lives >= 1:
		if canJump:
			if !jumping:
				jumping = true
				$jumpTimer.start()
				velocity.y = JUMP_VELOCITY * 1.5
	
	if Input.is_action_just_pressed("Pow2") and lives >= 1:
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
	if direction and lives >= 1:
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
