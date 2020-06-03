extends Area2D

var is_ground = false
var x = 1
var y = 1

func _physics_process(delta):
	if !is_ground:
		translate(Vector2(0,1000*delta));
	else:
		get_parent().create_cell(x,y)
		queue_free()


func _on_Rock_body_entered(body):
	if body.is_in_group("Ground"):
		is_ground = true
