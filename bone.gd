extends Area2D

var collected = false

func _on_body_entered(body):
	if !collected:
		collected = true
		body.bones += 1
		print(body.bones)
		visible = false



