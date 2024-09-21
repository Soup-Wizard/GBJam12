extends Area2D

var direction: Vector2
var telePos

func _on_body_entered(body):
	#direction = body.last_pos - body.current_pos
	if body.canBeHit:
		body.lives -= 1
	if body.lives >= 1:
		if body.checkpoints.is_empty():
			telePos = body.spawnPos
		else:
			telePos = body.checkpoints.values()[body.checkpoints.size() - 1]
		
		body.checkpointTele(telePos)
		if !body.checkpoints.is_empty():
			body.checkpoints.erase(body.checkpoints.keys()[body.checkpoints.size() - 1])
		print(body.checkpoints)
		
		body.canBeHit = false
		body.get_node("visibilityTimer").start()
		body.get_node("hitTimer").start()
		await get_tree().create_timer(1.5).timeout
		body.get_node("visibilityTimer").stop()
		body.visible = true
	else:
		body.checkpointTele(body.spawnPos)
		body.canBeHit = false
		body.get_node("visibilityTimer").start()
		body.get_node("hitTimer").start()
		await get_tree().create_timer(1.5).timeout
		body.get_node("visibilityTimer").stop()
		body.visible = true
		#body.get_node("CollisionShape2D").queue_free()
