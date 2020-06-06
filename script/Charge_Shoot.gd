extends Area2D

var is_charge = false
var charge_shoot = 1
var stage = null
var audio_charge = load("res://audio/X/shooter/charge.wav")
var audio_charge_max = load("res://audio/X/shooter/charge_max.wav")
export var damage = 10
var player = null

func _ready():
	visible = false
	stage = get_node("/root/Stage")
	player = get_node("/root/Stage/Player")

func _process(delta):
	if player.is_dead:
		queue_free()
	if stage.is_start:
		if Input.is_action_pressed("ui_key_c") and !is_charge:
			charge_shoot = 1
			is_charge = true
			$Timer.start()
		
		if Input.is_action_just_released("ui_key_c") and is_charge:
			is_charge = false
			visible = false
			$AnimationPlayer.stop()
			$AudioStreamPlayer.stop()
			charge_shoot = 1

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Small":
		$AnimationPlayer.queue("Normal")
		charge_shoot = 2
	elif anim_name == "Normal" :
		$AudioStreamPlayer.stream = audio_charge_max
		$AudioStreamPlayer.play()
		$AnimationPlayer.queue("Big")
		charge_shoot = 3

func _on_Timer_timeout():
	if is_charge:
		$AnimationPlayer.queue("Small")
		$AudioStreamPlayer.stream = audio_charge
		$AudioStreamPlayer.play()
		visible = true
