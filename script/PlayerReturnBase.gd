extends Node2D

var is_idle = true
export var SPEED = -500

func _ready():
	$AnimationPlayer.play("Idle")
	$Timer.start()

func _process(delta):
	if !is_idle:
		translate(Vector2(0,SPEED * delta))

func _on_Timer_timeout():
	is_idle = false
	$AnimationPlayer.play("Run")
