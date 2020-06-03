extends Area2D

var collisionDamage = 1000000
var stage = null
var player = null

func _ready():
	stage = get_node("/root/Stage")
	player = get_node("/root/Stage/Player")

func _physics_process(delta):
	if !stage.is_start:
			return

func _on_Death_Range_body_entered(body):
	if body.is_in_group("Player"):
		if !stage.is_start:
			return
		else:
			body.takingDamage(collisionDamage)
		body.enemies_entered.append(self.get_path())

func _on_Death_Range_body_exited(body):
	if body.is_in_group("Player"):
		body.enemies_entered.erase(self.get_path())
