extends Node2D

var scene_path = "res://scene/Mission1/Mission1.tscn"
var audio_foot_step = load("res://audio/ZX/FootStep/FOOT_COMMON.wav")
var TRANSFORM_X = preload("res://scene/Transform_X.tscn")
var music_stage = load("res://audio/stage1/bg.ogg")
export var is_start = false
var transform_x = null
var audioSp = null
var is_game_over = false
var is_first_time = true

func _ready():
	is_start = true
	transform_x = TRANSFORM_X.instance()
	transform_x.position = $Player.position
	transform_x.position.x +=25
	transform_x.position.y -=50
	self.add_child(transform_x)
	$Boss_MS1.is_stop = false
	$Boss_MS1.is_cutscene = false
