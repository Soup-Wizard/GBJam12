extends Node2D

var BigWormHasSpoken = false
var BigWorm2Speaking = false
var LittleWorm1 = true
var LittleWorm2 = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_welleport_1_body_entered(body):
	$Welleport1/AnimatedSprite2D.visible = true
	body.teleCoords = Vector2(376, 365)
	body.canTele = true


func _on_welleport_1_body_exited(body):
	$Welleport1/AnimatedSprite2D.visible = false
	body.canTele = false


func _on_welleport_2_body_entered(body):
	$Welleport2/AnimatedSprite2D.visible = true
	body.teleCoords = Vector2(413, 116)
	body.canTele = true


func _on_welleport_2_body_exited(body):
	$Welleport2/AnimatedSprite2D.visible = false
	body.canTele = false


func _on_worm_3_body_entered(body):
	body.canJump = true
	body.get_node("Bones/JumpArrow").visible = true


func _on_area_2d_body_entered(body):
	if !LittleWorm1:
		$worm4.visible = true
		body.canDash = true
		body.get_node("Bones/DashArrow").visible = true
		body.playText("LittleWorm1")
		LittleWorm1 = true

func _on_big_worm_area_body_entered(body):
	if !body.textActive:
		if !BigWormHasSpoken:
			$BigWorm1/Blocker/StaticBody2D/CollisionShape2D2.set_deferred("disabled", false)
			$BigWorm1/Blocker.visible = true
		if !BigWormHasSpoken:
			await body.playText("BigWorm1")
			await body.playText("BigWorm1.1")
			$BigWorm1/Blocker.visible = false
			$BigWorm1/Blocker/StaticBody2D/CollisionShape2D2.set_deferred("disabled", true)
			await body.playText("BigWorm1.2")
			BigWormHasSpoken = true
			LittleWorm1 = false
		else:
			body.playText("BigWormHasSpoken")
		
		#if !BigWormHasSpoken:
			#await get_tree().create_timer(25).timeout
			#$BigWorm1/Blocker.visible = false
			#$BigWorm1/Blocker/StaticBody2D/CollisionShape2D2.set_deferred("disabled", true)
			#BigWormHasSpoken = true
			#await get_tree().create_timer(10).timeout
			#LittleWorm1 = false

func _on_big_worm_2_area_body_entered(body):
	if body.bones < 15 && !BigWorm2Speaking:
		BigWorm2Speaking = true
		await get_tree().create_timer(3).timeout
		$BigWorm2.visible = true
		await body.playText("BigWorm2")
		body.checkpointTele(true)
		BigWorm2Speaking = false
		$BigWorm2.visible = false
	elif body.bones >= 15 && !BigWorm2Speaking:
		BigWorm2Speaking = true
		$BigWorm2/blocker/CollisionShape2D.set_deferred("disabled", false)
		await get_tree().create_timer(3).timeout
		$BigWorm2.visible = true
		await body.playText("BigWorm3")
		var bonesNode = body.get_node("Bones")
		bonesNode.get_node("Label").visible = false
		bonesNode.get_node("Sprite2D").visible = false
		bonesNode.get_node("Label2").visible = false
		bonesNode.get_node("Sprite2D2").visible = false
		#await get_tree().create_timer(0.5).timeout
		for i in $WORM_MOON.get_children():
			i.wormMoon()
		await body.playText("BigWorm4")
		await get_tree().create_timer(2).timeout
		body.ending = true
		body.endPos = body.position
		await body.playText("Ending1")
		await body.endingAnim()
		await body.playText("Ending2")
