extends Area2D

var speed = 240

var collisionDamage = 20

func _ready():
	pass

func _physics_process(delta):
	
	var flip = -1 
	if $Sprite.flip_h:
		flip = 1

	translate(Vector2(speed*delta*flip, 0))	


func _on_Node2D_body_entered(body):
	if body.is_in_group("Player"):
		body.takingDamage(collisionDamage)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
