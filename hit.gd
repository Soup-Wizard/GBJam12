extends Area2D

var direction: Vector2

func _on_body_entered(body):
	#direction = body.last_pos - body.current_pos
	body.lives -= 1
	if body.lives >= 1:
		body.on_collision_with_enemy(get_parent().position)
		#if body.get_node("AnimatedSprite2D").flip_h == true:
			#body.velocity.x = 800
			#body.velocity.y = -250
		#else:
			#body.velocity.x = -800
			#body.velocity.y = -250
	else:
		body.visible = false
		#body.get_node("CollisionShape2D").queue_free()
