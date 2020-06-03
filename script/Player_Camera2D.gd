extends Camera2D

func _physics_process(delta):
	$Audio_Foot_Step.position = Vector2(position.x/2, position.y/2)	
	$Audio_Player.position = Vector2(position.x/2, position.y/2)
	$Audio_Shooter.position = Vector2(position.x/2, position.y/2)
	$Audio_Stage.position = Vector2(position.x/2, position.y/2)
