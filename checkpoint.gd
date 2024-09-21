extends Area2D

var claimed = false

# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	if !claimed:
		claimed = true
		body.checkpoints[str(self.name)] = position
		body.checkpointPos = body.checkpoints.size() - 1
		print(body.checkpoints.size(), body.checkpoints)
