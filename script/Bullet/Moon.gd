extends Area2D

var vel = Vector2()
export var rotate = 28
export var SPEED = 1000
export var collisionDamage = 12
export var group = "Enemy"

func _ready():
	vel = Vector2(SPEED,0).rotated(deg2rad(rotate))
	self.rotation_degrees = rotate
	$AnimationPlayer.play("Idle")

func _physics_process(delta):
	var flip = -1
	if $Sprite.flip_h:
		flip = 1
	position += vel * delta * flip


func _on_Moon_body_entered(body):
	
	if body.is_in_group(group):
		return

	if body.is_in_group("Player"):
		body.enemies_entered.append(self.get_path())
	if body.is_in_group("Ground"):
		queue_free()

func _on_Moon_body_exited(body):
	if body.is_in_group(group):
		return

	if body.is_in_group("Player"):
		body.enemies_entered.erase(self.get_path())
