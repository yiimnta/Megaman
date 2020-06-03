extends Control

var is_pressed = false
var newGameBtn
var continueBtn
var exitBtn
var firstFocus = true
export var color_focus = Color("#ff0000")
export var color_normal = Color("#000000")
export var next_stage = "res://scene/Mission1/Intro.tscn"
var is_video_playing = false

func _ready():
	newGameBtn = $Menu/HBoxContainer/Buttons/NewGame
	continueBtn = $Menu/HBoxContainer/Buttons/Continue
	exitBtn = $Menu/HBoxContainer/Buttons/Exit
	newGameBtn.grab_focus()
	newGameBtn.get_node("Label").get_font("font").outline_color = color_focus
	continueBtn.visible = false
	$VideoPlayer.visible = false
	$TimerVideo.start()

func _input(event):
	if !is_video_playing:
		return
	if Input.is_action_just_pressed("ui_esc"):
		$VideoPlayer.stop()
		$VideoPlayer.visible = false
		$Audio_BG.play()
		is_video_playing = false

func _process(delta):
	if is_pressed:
		return
	
	if newGameBtn.is_hovered():
		newGameBtn.grab_focus()
		newGameBtn.get_node("Label").get_font("font").outline_color = color_focus
	else:
		newGameBtn.get_node("Label").get_font("font").outline_color = color_normal
		
	if continueBtn.is_hovered():
		continueBtn.grab_focus()
		continueBtn.get_node("Label").get_font("font").outline_color = color_focus
	else:
		continueBtn.get_node("Label").get_font("font").outline_color = color_normal

	if exitBtn.is_hovered():
		exitBtn.grab_focus()
		exitBtn.get_node("Label").get_font("font").outline_color = color_focus
	else:
		exitBtn.get_node("Label").get_font("font").outline_color = color_normal

func _on_Timer_timeout():
	get_tree().change_scene(next_stage)

func _on_NewGame_focus_entered():
	if firstFocus:
		firstFocus = false
		return
	if is_video_playing:
		return
	$AudioStreamPlayer2D.play()


func _on_Continue_focus_entered():
	if is_video_playing:
		return
	$AudioStreamPlayer2D.play()


func _on_Exit_focus_entered():
	if is_video_playing:
		return
	$AudioStreamPlayer2D.play()


func _on_NewGame_pressed():
	if is_video_playing:
		return
	if !is_pressed:
		$accept.play()
		$Timer.start()
		is_pressed = true

func _on_Exit_pressed():
	if is_video_playing:
		return
	get_tree().quit()

func _on_TimerVideo_timeout():
	$VideoPlayer.visible = true
	$VideoPlayer.play()
	is_video_playing = true
	$Audio_BG.stop()
