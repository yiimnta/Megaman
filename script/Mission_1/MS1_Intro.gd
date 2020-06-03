extends Node2D

var audio_1 = "res://audio/ZX/Ambience/AMBIENT_AIRSHIP0.wav"
var audio_2 = "res://audio/ZX/Ambience/AMBIENT_AIRSHIP1.wav"
var audio_intro = "res://audio/stage1/intro/intro.ogg"
var can_go_mission = false
var is_playing_video = false
var section = "Player"
var BASE_LIVES = 2

func _ready():
	$Player/AnimationPlayer.play("Idle")
	$AudioStreamPlayer.stream = load(audio_1)
	$AudioStreamPlayer.play()
	$Timer_Chat.start()
	$Timer_Audio.start()
	$Video.visible = false
	$Data.saveData(section,"lives", BASE_LIVES)
	$AnimationPlayer.queue("Normal")

func _process(delta):
	if $Chat_Dialog.isEnd():
		can_go_mission = true

func _input(event):
	if can_go_mission:
		if !is_playing_video:
			is_playing_video = true
			$AudioStreamPlayer.stop()
			$Video.visible = true
			$Video.play()
		if Input.is_action_just_pressed("ui_esc"):
			get_tree().change_scene("res://scene/Mission1/Misson1.tscn")

func _on_Timer_Chat_timeout():
	$Chat_Dialog.actived = true
	$Chat_Dialog.show()
	$AudioStreamPlayer.stream = load(audio_intro)
	$AudioStreamPlayer.play()


func _on_Timer_Audio_timeout():
	$AudioStreamPlayer.stream = load(audio_2)
	$AudioStreamPlayer.play()
	$AnimationPlayer.queue("Warning")

func _on_Video_finished():
	get_tree().change_scene("res://scene/Mission1/Misson1.tscn")
