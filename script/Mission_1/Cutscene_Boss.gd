extends Area2D

var stage
var myPlayer
var rockFall
var is_detecting_player = false
var ROCK_FALL = preload("res://scene/Mission1/RockFall.tscn")

func _ready():
	stage = get_node("/root/Stage")
	myPlayer = get_node("/root/Stage/Player")

func _physics_process(delta):
	if(is_detecting_player):
		var rf = ROCK_FALL.instance()
		rf.position = $Position2D.global_position
		stage.add_child(rf)
		myPlayer.get_node("Camera2D").limit_left = 3200
		queue_free()

func _on_Cutscene_body_entered(body):
	if body.is_in_group("Player"):
		is_detecting_player = true
