extends Area2D

var playback : AnimationNodeStateMachinePlayback
var is_finished = false

func _ready():
	get_node("/root/Stage/Player").visible = false
	get_node("AnimationPlayer").queue("Idle")
	$Timer.start()

func _on_Timer_timeout():
	get_node("AnimationPlayer").queue("Transform")

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Transform"):
		get_node("/root/Stage/Player").visible = true
		get_node("/root/Stage").is_start = true
		queue_free()
