extends Node2D

@export var vertical: bool
var outTime = 0.45
var inTime = 0.35

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_loops()
	if vertical:
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y - 32), outTime)
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y), inTime)#.set_delay(0.1)
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y + 32), outTime)
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y), inTime)#.set_delay(0.1)
	else:
		tween.tween_property($hit, "position", Vector2($hit.position.x - 32, $hit.position.y), outTime)
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y), inTime)#.set_delay(0.1)
		tween.tween_property($hit, "position", Vector2($hit.position.x + 32, $hit.position.y), outTime)
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y), inTime)#.set_delay(0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
