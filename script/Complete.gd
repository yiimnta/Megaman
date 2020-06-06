extends Node2D

export var is_active = false

func _ready():
	if is_active:
		$AnimationPlayer.play("Run")
		$Timer.start()

func _process(delta):
	if is_active:
		$AnimationPlayer.play("Run")
		$Timer.start()
		is_active = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Run":
		queue_free()


func _on_Timer_timeout():
	$AudioStreamPlayer.play()
