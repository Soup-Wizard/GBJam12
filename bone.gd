extends Area2D

var collected = false
@onready var boneNear = $Sprite2D/BoneNear
@onready var boneGet = $Sprite2D/BoneGet
@onready var boneDone = $Sprite2D/BoneDone

func _ready():
	#boneNear.play()
	var tween = create_tween().set_loops()
	tween.tween_property($Sprite2D, "position", Vector2($Sprite2D.position.x, $Sprite2D.position.y - 3), 0.7)
	tween.tween_property($Sprite2D, "position", Vector2($Sprite2D.position.x, $Sprite2D.position.y), 0.7)

func _on_body_entered(body):
	if !collected:
		collected = true
		visible = false
		boneNear.stop()
		body.bones += 1
		if body.bones < 15:
			boneGet.play()
		else:
			boneDone.play()
		if body.bones == 5 || body.bones == 10 || body.bones == 15:
			body.lives += 1

func _on_bone_get_finished():
	queue_free()

func _on_bone_done_finished():
	queue_free()
