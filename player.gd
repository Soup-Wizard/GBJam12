extends CharacterBody2D

const SPEED = 100.0
const DASH_SPEED = 175
const JUMP_VELOCITY = -225.0
const BOUNCE_STRENGTH = 375

const TEXT = {
	"BigWorm1": "You may be dead now but you still owe me. I'll make sure your suffering is endless if I don't see you at the moon with 15 bones.\nTalk to little worm behind me for a new trick, but that's all you get from me.\nDon't play with my bones, Ghosty! Playing with my bones is like playing with my emotions!",
	"BigWormHasSpoken": "Quit wasting my time and get my bones!",
	"LittleWorm1": "Don't tell Big Worm about this.\nUse this with your jump to reach higher ground.",
	"BigWorm2": "What did I tell you, Ghosty? Stop playing with my emotions!\nGet my bones before you waste my time again.",
	"BigWorm3": "You actually did it? I guess I underestimated your abilities.\nLet the worm moon commence and free your soul!",
	"Checkpoint": "Checkpoint activated"
}

@onready var textLabel = $Bones/Text/RichTextLabel

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var worms = 0
var bones = 0
var lives = 3
var checkpoint: Vector2
var spawnPos = Vector2(49, 121)
var canTele = false
var teleCoords: Vector2
var canDash = false ## SWITCH CHANGE FIX BACK TO FALSE AFTER TESTING
var canJump = false ## SWITCH CHANGE FIX BACK TO FALSE AFTER TESTING
var dashing = false
var jumping = false
var canBeHit = true
var textActive = false

func wellTele():
	if canTele:
		position = teleCoords
		canTele = false

func checkpointTele():
	if lives > 0 && checkpoint:
		position = checkpoint
	if lives == 0 || !checkpoint:
		position = spawnPos

func playText(txt):
	textActive = true
	textLabel.visible_characters = 0
	textLabel.text = TEXT[txt]
	$Bones/Text.visible = true
	for i in TEXT[txt].length():
		#if textLabel.get_visible_line_count() == 2:
			#textLabel  --  If time permits, make it wait for user input to scroll
		textLabel.visible_characters += 1
		await get_tree().create_timer(0.084).timeout
	await get_tree().create_timer(3).timeout
	$Bones/Text.visible = false
	textLabel.text = ""
	textActive = false

func _physics_process(delta):
	#Handle Bones & Lives
	$Bones/Label.text = ": " + str(bones)
	if lives >= 3:
		$Bones/Label2.text = ": " + str(lives)
		$Bones/Sprite2D2.frame = 2
	elif lives == 2:
		$Bones/Label2.text = ": " + str(lives)
		$Bones/Sprite2D2.frame = 1
	elif lives == 1:
		$Bones/Label2.text = ": " + str(lives)
		$Bones/Sprite2D2.frame = 0
	elif lives == 0:
		$Bones/Label2.text = ": 0"
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle wells
	if Input.is_action_just_pressed("down"):
		wellTele()
	
	# Handle Checkpoints
	if Input.is_action_just_pressed("select"):
		if lives > 0 && checkpoint:
			checkpointTele()
	
	if Input.is_action_just_pressed("Pow1"):
		if canJump:
			if !jumping:
				$Bones/JumpArrow/Sprite2D.visible = true
				jumping = true
				$jumpTimer.start()
				velocity.y = JUMP_VELOCITY * 1.5
	
	if Input.is_action_just_pressed("Pow2"):
		if canDash:
			canDash = false
			dashing = true
			$Bones/DashArrow/Sprite2D.visible = true
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
	$Bones/JumpArrow/Sprite2D.visible = false

func _on_dash_cooldown_timeout():
	canDash = true
	$Bones/DashArrow/Sprite2D.visible = false

func _on_hit_timer_timeout():
	canBeHit = true

func _on_visibility_timer_timeout():
	visible = false
	await get_tree().create_timer(0.05).timeout
	visible = true
