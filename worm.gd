extends Node2D

@onready var anchorPos = $MoonAnchor.position
@onready var anchorPos2 = Vector2($MoonAnchor.global_position)
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3).timeout
	if get_parent().name == "WORM_MOON":
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "position", anchorPos2 * .02, 2)
		print(anchorPos2)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
