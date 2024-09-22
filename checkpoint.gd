extends Area2D

var visited = false
var active = false

# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	#if !active:
		#active = true
	if body.lives > 0 && body.checkpoint != global_position:
		body.checkpoint = global_position
		await body.playText("Checkpoint")
		if name == "Checkpoint1" && !visited:
			visited = true
			await body.playText("CheckpointRead")
			await body.playText("Checkpoint1")
		elif name == "Checkpoint2" && !visited:
			visited = true
			await body.playText("CheckpointRead")
			await body.playText("Checkpoint2")
		elif name == "Checkpoint3" && !visited:
			visited = true
			await body.playText("CheckpointRead")
			await body.playText("Checkpoint3")
	#active = false

