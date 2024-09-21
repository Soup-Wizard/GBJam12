extends Node2D

@export var vertical: bool
@export var distancePos = 32
@export var distanceNeg = -32
@export var outTime = 0.45
@export var inTime = 0.35

@onready var sprite = $hit/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_loops()
	if vertical:
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y + distanceNeg), outTime)
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y), inTime)
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y + distancePos), outTime)
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y), inTime)
	else:
		tween.tween_property($hit, "position", Vector2($hit.position.x + distancePos, $hit.position.y), outTime)
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y), inTime)
		tween.tween_property($hit, "position", Vector2($hit.position.x + distanceNeg, $hit.position.y), outTime)
		tween.tween_property($hit, "position", Vector2($hit.position.x, $hit.position.y), inTime)
		$flipTimer.wait_time = inTime + outTime
		await get_tree().create_timer(outTime).timeout
		if distancePos > 0:
			sprite.flip_h = !sprite.flip_h
		$flipTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_flip_timer_timeout():
	sprite.flip_h = !sprite.flip_h
