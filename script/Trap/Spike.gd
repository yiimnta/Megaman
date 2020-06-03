extends Area2D

export var collisionDamage = 10000000
var is_ground = false;
var player = null
var stage = null
var is_player_in = false

func _ready():
	player = get_node("/root/Stage/Player")
	stage = get_node("/root/Stage")

func _physics_process(delta):
	if !is_ground:
		translate(Vector2(0,100*delta));


func _on_Spike_body_entered(body):
	if body.is_in_group("Ground"):
		is_ground = true
	if body.is_in_group("Player"):
		if !stage.is_start:
			return
		else:
			body.takingDamage(collisionDamage)
		body.enemies_entered.append(self.get_path())


func _on_Spike_body_exited(body):
	if body.is_in_group("Ground"):
		is_ground = false
	if body.is_in_group("Player"):
		body.enemies_entered.erase(self.get_path())
