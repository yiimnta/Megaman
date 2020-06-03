extends Node2D

var player = null

func _ready():
	player = get_node("/root/Stage/Player")
	$HealthBar.max_value = player.MAX_HEALTH
	$HealthBar.value = player.health
	setLives()

func _physics_process(delta):
	$HealthBar.value = player.health
	setLives()


func setLives():
	if(player.lives == 0) :
		$HealthBar/Sprite.frame = 9
	else:
		$HealthBar/Sprite.frame = player.lives - 1
