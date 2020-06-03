extends Node2D

var is_run = false


func _process(delta):
	if is_run:
		$AudioStreamPlayer2D.play()
		$Sprite/AnimationPlayer.play("Show")
		is_run = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Show":
		$Sprite/AnimationPlayer.play("Idle")
	elif anim_name == "Idle":
		$Sprite/AnimationPlayer.play("Hide")
	else:
		queue_free()
