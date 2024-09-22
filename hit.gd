extends Area2D

func _on_body_entered(body):
	if body.canBeHit && body.lives >= 1:
		body.lives -= 1
		body.checkpointTele()
		body.canBeHit = false
		body.get_node("visibilityTimer").start()
		body.get_node("hitTimer").start()
		await get_tree().create_timer(1.5).timeout
		body.get_node("visibilityTimer").stop()
		body.visible = true
	elif body.canBeHit && body.lives <= 0:
		body.checkpointTele()
		body.canBeHit = false
		body.get_node("visibilityTimer").start()
		body.get_node("hitTimer").start()
		await get_tree().create_timer(1.5).timeout
		body.get_node("visibilityTimer").stop()
		body.visible = true
