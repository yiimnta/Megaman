extends Node2D

var scene_path = "res://scene/Mission1/Mission1.tscn"
var audio_foot_step = load("res://audio/ZX/FootStep/FOOT_COMMON.wav")
var TRANSFORM_X = preload("res://scene/Transform_X.tscn")
var music_stage = load("res://audio/stage1/boss_stage/bg.ogg")
var music_boss_fight = load("res://audio/stage1/boss_stage/boss-fight.ogg")
var music_warning = load("res://audio/stage1/boss_stage/warning.ogg")
export var is_start = true
var transform_x = null
var audioSp = null
var is_game_over = false
var is_first_time = true
var state = null

enum{
	RUN_1,
	IDLE_2,
	RUN_3,
	IDLE_4,
	IDLE_5,
	B_ROLL_6,
	B_ROLL_7,
	B_ROLL_8,
	B_ROLL_9,
	B_IDLE_10,
	WARNING,
	WAITING_ATTACK,
	FIGHT
}
var ani

func _ready():
	is_start = true
	state = RUN_1
	ani = $Player.get_node("X/AnimationTree")
	$Chat_Dialog.visible = false
	$Chat_Dialog_2.visible = false
	$Chat_Dialog_3.visible = false
	$Chat_Dialog_4.visible = false
	$Player.is_cutscreen = true
	ani.is_cutscreen = true
	$Boss_MS1.visible = false
	$Boss_MS1.is_cutscene = true
	$Boss_MS1.is_stop = true
	$Warning.visible = false
	$CanvasLayer/Control.visible = false

func _process(delta):
	
	match state:
		RUN_1:
			$Player.translate(Vector2($Player.SPEED*delta, 0))
			ani.change_state(ani.RUN)
			if !$Player.audioFS.is_playing():
				$Player.audioFS.play()
			if $Player.position.x >= $Position_Run1.position.x:
				state = IDLE_2
				$Chat_Dialog.visible = true
				$Chat_Dialog.actived = true
				$Chat_Dialog.show()
				$Player.audioFS.stop()
				$Chat_Dialog.position = $Player/Camera2D.position
				$Chat_Dialog.position.x -= 40
		IDLE_2:
			ani.change_state(ani.IDLE)
			if $Chat_Dialog.isEnd() and Input.is_action_just_pressed("ui_accept"):
				$Chat_Dialog.visible = false
				state = RUN_3
		RUN_3:
			$Player.translate(Vector2($Player.SPEED*delta, 0))
			ani.change_state(ani.RUN)
			if !$Player.audioFS.is_playing():
				$Player.audioFS.play()
			if $Player.position.x >= $Position_Run2.position.x:
				state = IDLE_4
				
				$Player.audioFS.stop()
				$Chat_Dialog_2.position = $Player/Camera2D.position
				
		IDLE_4:
			ani.change_state(ani.IDLE)
			$RockFall/RockController.is_start = true
			if $RockFall/RockController.is_stop and !$Chat_Dialog_2.visible:
				$Chat_Dialog_2.visible = true
				$Chat_Dialog_2.actived = true
				$Chat_Dialog_2.show()
			if $RockFall/RockController.is_stop and Input.is_action_just_pressed("ui_accept"):
				state = IDLE_5
				$Chat_Dialog_2.visible = false
				$Chat_Dialog_3.visible = true
				$Chat_Dialog_3.actived = true
				$Chat_Dialog_3.position = $Player/Camera2D.position
				$Chat_Dialog_3.show()
		IDLE_5:
			$ScreenShake.screen_shake(1,10,100)
			if !$Audio_EW.is_playing():
				$Audio_EW.play()
			if Input.is_action_just_pressed("ui_accept"):
				state = B_ROLL_6
				$Chat_Dialog_3.visible = false
				$Boss_MS1.visible = true
				$Boss_MS1.is_stop = false
				$Boss_MS1.is_using_sk2 = true
				$Boss_MS1.animation.play("Skill_2")
				$Audio_EW.stop()
		B_ROLL_6:
			$Boss_MS1.translate(Vector2(-$Boss_MS1.speed_roll * delta, 0))
			if $Boss_MS1.position.x <= $Position_B_Roll1.position.x:
				state = B_ROLL_7
				$Boss_MS1.get_node("Sprite").flip_h = true
				$Audio_EW.play()
				$ScreenShake.screen_shake(0.5,10,100)
		B_ROLL_7:
			$Boss_MS1.translate(Vector2($Boss_MS1.speed_roll * delta, 0))
			if $Boss_MS1.position.x >= $Position_B_Roll2.position.x:
				state = B_ROLL_8
				$Boss_MS1.get_node("Sprite").flip_h = false
				$Audio_EW.stop()
				$Audio_EW.play()
				$ScreenShake.screen_shake(0.5,10,100)
				$Player/Camera2D.limit_left = 200 
				$Player/X.flip_h = true
				$Player.dash()
				ani.change_state(ani.DASH)
		B_ROLL_8:
			$Boss_MS1.translate(Vector2(-$Boss_MS1.speed_roll * delta, 0))
			if $Player.position.x > $Position_Dash1.position.x:
				$Player.translate(Vector2(-$Player.DASH_POWER*delta, 0))
			else:
				ani.change_state(ani.IDLE)
				$Player/X.flip_h = false
			if $Boss_MS1.position.x <= $Position_B_Roll3.position.x:
				state = B_ROLL_9
				$Boss_MS1.get_node("Sprite").flip_h = true
				$Audio_EW.stop()
				$Audio_EW.play()
				$ScreenShake.screen_shake(0.5,10,100)
		B_ROLL_9:
			$Boss_MS1.translate(Vector2($Boss_MS1.speed_roll * delta, 0))
			if $Boss_MS1.position.x >= $Position_B_Roll4.position.x:
				state = B_IDLE_10
				$Boss_MS1.is_stop = true
				$Boss_MS1.get_node("Sprite").flip_h = false
				$Boss_MS1.animation.play("Idle")
				$ScreenShake.screen_shake(0.5,10,100)
		B_IDLE_10:
			$Chat_Dialog_4.visible = true
			$Chat_Dialog_4.actived = true
			$Chat_Dialog_4.position = $Player/Camera2D.position
			$Chat_Dialog_4.show()
			state = WARNING
		WARNING:
			if $Chat_Dialog_4.isEnd() and Input.is_action_just_pressed("ui_accept"):
				$Chat_Dialog_4.visible = false
				$Warning.is_run = true
				$Warning.visible = true
				state = WAITING_ATTACK
				$Waiting_Warning.start()
		WAITING_ATTACK:
			pass
		FIGHT:
			pass

func _on_Waiting_Warning_timeout():
	state = FIGHT
	$Player/X/Audio_Stage.stream = music_boss_fight
	$Player/X/Audio_Stage.play()
	$Player.is_cutscreen = false
	ani.is_cutscreen = false
	$Boss_MS1.is_cutscene = false
	$Boss_MS1.is_stop = false
	$CanvasLayer/Control.visible = true
