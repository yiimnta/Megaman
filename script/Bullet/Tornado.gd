extends Area2D

var TORNADO_MINI = preload("res://scene/Bullet/Tornado_mini.tscn")
var is_start = false
export var collisionDamage = 18

func _ready():
	$Timer_Prepare.start()
	$Collision.visible =false
	$Collision.disabled = true
	$Sprite.visible = false

func _process(delta):
	if is_start:
		$Collision.visible = true
		$Sprite.visible = true
		$Collision.disabled = false
		$Tornado_mini.queue_free()
		$AnimationPlayer.play("Run")
		is_start = false
		$AudioStreamPlayer.play()

func _on_Timer_Prepare_timeout():
	is_start = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Run":
		queue_free()

func _on_Tornado_body_entered(body):
	if body.is_in_group("Player"):
		body.enemies_entered.append(self.get_path())

func _on_Tornado_body_exited(body):
	if body.is_in_group("Player"):
		body.enemies_entered.erase(self.get_path())
