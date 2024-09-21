extends Area2D

var collected = false

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property($Sprite2D, "position", Vector2($Sprite2D.position.x, $Sprite2D.position.y - 3), 0.7)
	tween.tween_property($Sprite2D, "position", Vector2($Sprite2D.position.x, $Sprite2D.position.y), 0.7)

func _on_body_entered(body):
	if !collected:
		collected = true
		body.bones += 1
		if body.bones == 5 || body.bones == 10 || body.bones == 15:
			body.lives += 1
		queue_free()
