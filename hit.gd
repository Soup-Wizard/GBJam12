extends Area2D

var direction: Vector2

func _on_body_entered(body):
	#direction = body.last_pos - body.current_pos
	if body.canBeHit:
		body.lives -= 1
	if body.lives >= 1:
		body.on_collision_with_enemy(get_parent().position)
		body.canBeHit = false
		body.get_node("visibilityTimer").start()
		body.get_node("hitTimer").start()
		await get_tree().create_timer(1.5).timeout
		body.get_node("visibilityTimer").stop()
		body.visible = true
		#if body.get_node("AnimatedSprite2D").flip_h == true:
			#body.velocity.x = 800
			#body.velocity.y = -250
		#else:
			#body.velocity.x = -800
			#body.velocity.y = -250
	else:
		body.visible = false
		#body.get_node("CollisionShape2D").queue_free()
