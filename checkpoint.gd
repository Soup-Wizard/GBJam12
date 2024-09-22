extends Area2D

# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	if body.lives > 0 && body.checkpoint != global_position:
		body.playText("Checkpoint")
	body.checkpoint = global_position
