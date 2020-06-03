extends Sprite

func _ready():
	$AnimationPlayer.queue("Idle")
	position = Vector2(100,100)

func s_scale(value):
	set_scale(Vector2(value, value))

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
