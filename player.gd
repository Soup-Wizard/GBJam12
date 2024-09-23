extends CharacterBody2D

const SPEED = 100.0
const DASH_SPEED = 175
const JUMP_VELOCITY = -225.0
const BOUNCE_STRENGTH = 375

const TEXT = {
	"BigWorm1": "You may have died but you still owe me. I'll make sure you suffer endlessly if you don't meet me at the moon with 15 bones.",
	"BigWorm1.1": "Little Worm has something for you to climb the roots down here, but that's all you're getting from the worms.",
	"BigWorm1.2": "Don't play with my bones, Ghosty! Playing with my bones is like playing with my emotions!",
	"BigWormHasSpoken": "Quit wasting my time and get my bones!",
	"LittleWorm1": "Don't tell Big Worm about this.\nUse this with your jump to reach higher ground!",
	"BigWorm2": "What did I tell you, Ghosty? Stop playing with my emotions!\nGet my bones before you waste my time again.",
	"BigWorm3": "You actually did it? I guess I underestimated you...\n",
	"BigWorm4": "Let the worm moon commence! Get on up and free your spooky soul!",
	"Checkpoint": "Checkpoint activated!\nTAB / SEL to return.",
	"CheckpointRead": "Let's see what it says...",
	"Checkpoint1": "'Oh how I wish I made it to the clouds before I died...'\n'Those beautiful blobs of vapor filled with bones.'",
	"Checkpoint2": "'Oh how I wish I took my time in life before I died...'\n'Then I wouldn't be so dead right now.'",
	"Checkpoint3": "'Oh how I wish they didn't nail the coffin shut...\n'Then I could get out of here before it's too late.",
	"Ending1": "Art/Audio/Code created by\nSoup-Wizard for GBJAM 12",
	"Ending2": "Thanks for playing!\n- Soup-Wizard"
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
var canDash = false
var canJump = false
var dashing = false
var jumping = false
var canBeHit = true
var textActive = false
var ending = false
var endPos: Vector2
var paused = false

# NOTE
# When time permits, add a func with a tween that drags your character to center of the moon,
# disables controls, and plays the ghost laugh animation on repeat.

func wellTele():
	if canTele:
		position = teleCoords
		canTele = false

func checkpointTele(wormReturn = false):
	if checkpoint:
		position = checkpoint
	else:
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
	await get_tree().create_timer(2).timeout
	if txt != "Ending2":
		$Bones/Text.visible = false
		textLabel.text = ""
		textActive = false

func endingAnim():
	#ending = true
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("laugh")
	#$CollisionShape2D.queue_free()
	print(position)
	print(global_position)
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(104, -1384), 3)
	#await tween.tween_property($AnimatedSprite2D, "position", Vector2(104, -1384), 3)
	#tween.tween_property($AnimatedSprite2D/Camera2D, "global_position", Vector2(104, -1384), 3)
	$AnimatedSprite2D/Camera2D.offset = Vector2(0, -32)
	position = Vector2(104, -1384)
	global_position = Vector2(104, -1384)
	pass

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
	
	# Handle pause
	if Input.is_action_just_pressed("start"):
		if !paused:
			paused = true
			Engine.time_scale = 0
		else:
			Engine.time_scale = 1
			paused = false
	
	# Add the gravity.
	if not is_on_floor() and !ending and !paused:
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor() and !ending and !paused:
		velocity.y = JUMP_VELOCITY
	
	# Handle wells
	if Input.is_action_just_pressed("down") and !ending and !paused:
		wellTele()
	
	# Handle Checkpoints
	if Input.is_action_just_pressed("select") and !ending and !paused:
		if lives > 0 && checkpoint:
			checkpointTele()
	
	if Input.is_action_just_pressed("Pow1") and !ending and !paused:
		if canJump:
			if !jumping:
				$Bones/JumpArrow/Sprite2D.visible = true
				jumping = true
				$jumpTimer.start()
				velocity.y = JUMP_VELOCITY * 1.5
	
	if Input.is_action_just_pressed("Pow2") and !ending and !paused:
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
	if direction and !ending and !paused:
		if !dashing:
			velocity.x = direction * SPEED
			if direction < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
	elif !ending:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if !ending:
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
