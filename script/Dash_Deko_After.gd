extends Area2D

onready var player = get_node("/root/Stage/Player")

func _ready():
	$AnimationPlayer.queue("Dash_Deko")

func _process(delta):
	if player != null:
		if !player.on_ground:
			queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
