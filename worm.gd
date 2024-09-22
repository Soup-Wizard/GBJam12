extends Node2D

@onready var anchorPos2 = Vector2($MoonAnchor.global_position)

func wormMoon():
	await get_tree().create_timer(7).timeout
	if get_parent().name == "WORM_MOON":
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "position", anchorPos2 * .02, 2)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
