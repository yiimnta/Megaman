extends Area2D

var rotate = 0;
func _ready():
	pass # Replace with function body.

func _process(delta):
	rotate += 0.001
	$Sprite.rotate(rotate)
