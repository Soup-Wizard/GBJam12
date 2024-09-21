extends Node2D

var BigWorm1Speaking = false
var BigWormHasSpoken = false
var BigWorm2Speaking = false
var LittleWorm1Speaking = false

var textBox

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
	$worm4.visible = true


func _on_worm_4_body_entered(body):
	body.canDash = true
	body.get_node("Bones/DashArrow").visible = true


func _on_big_worm_area_body_entered(body):
	if !BigWorm1Speaking:
		BigWorm1Speaking = true
		if !BigWormHasSpoken:
			$BigWorm1/Blocker/StaticBody2D/CollisionShape2D2.set_deferred("disabled", false)
			$BigWorm1/Blocker.visible = true
		textBox = body.get_node("Bones/Text")
		textBox.visible = true
		if !BigWormHasSpoken:
			body.playText("BigWorm1")
		else:
			body.playText("BigWormHasSpoken")
			$BigWorm1/Timer.wait_time = 14
		
		$BigWorm1/Timer.start()
		
		if !BigWormHasSpoken:
			await get_tree().create_timer(20).timeout
			$BigWorm1/Blocker.visible = false
			$BigWorm1/Blocker/StaticBody2D/CollisionShape2D2.set_deferred("disabled", true)
			


func _on_timer_timeout():
	BigWorm1Speaking = false
	BigWormHasSpoken = true
	textBox.visible = false
