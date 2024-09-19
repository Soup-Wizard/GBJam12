extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_welleport_1_body_entered(body):
	body.teleCoords = Vector2(376, 269)
	body.canTele = true


func _on_welleport_1_body_exited(body):
	body.canTele = false


func _on_welleport_2_body_entered(body):
	body.teleCoords = Vector2(413, 116)
	body.canTele = true


func _on_welleport_2_body_exited(body):
	body.canTele = false


func _on_worm_3_body_entered(body):
	body.canJump = true


func _on_area_2d_body_entered(body):
	$worm4.visible = true


func _on_worm_4_body_entered(body):
	body.canDash = true
