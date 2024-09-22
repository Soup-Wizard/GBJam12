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
			body.playText("BigWorm1")
		else:
			body.playText("BigWormHasSpoken")
		
		if !BigWormHasSpoken:
			await get_tree().create_timer(25).timeout
			$BigWorm1/Blocker.visible = false
			$BigWorm1/Blocker/StaticBody2D/CollisionShape2D2.set_deferred("disabled", true)
			BigWormHasSpoken = true
			await get_tree().create_timer(10).timeout
			LittleWorm1 = false

func _on_big_worm_2_area_body_entered(body):
	if body.bones < 15:
		await body.playText("BigWorm2")
		body.checkpointTele()
	elif body.bones >= 15:
		body.playText("BigWorm3")
		for i in $WORM_MOON.get_children():
			i.wormMoon()
