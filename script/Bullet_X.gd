extends Area2D

const SPEED = 65
var velocity = Vector2()
var charge = 0
export var flip_h = false
var flip = 1
var playback : AnimationNodeStateMachinePlayback
var timer = null
var can_shoot = false
var first_shoot = true
var is_die = false
var damage = 10 

func _ready():
	playback = $AnimationTree_Bullet.get("parameters/playback")
	playback.start("small")
	$AnimationTree_Bullet.active = true

func _physics_process(delta):
	if !is_die:
		if flip_h:
			flip = -1
		else:
			flip = 1
	
		if can_shoot :
			can_shoot = false
			if charge == 1:
				playback.travel("small")
			elif charge == 2:
				playback.travel("normal")
			else:
				playback.travel("big")
	
		if weakref($Bullet).get_ref():
			$Bullet.flip_h = flip_h
			if first_shoot:
				velocity.x = (SPEED * 10 * flip * delta)
			else:
				velocity.x += (SPEED * flip * delta)
			translate(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_X_body_entered(body):
	if body.is_in_group("Enemy"):
		body.takingDamage(damage)
		if charge < 3:
			queue_free()
	if charge < 3 and body.is_in_group("Ground"):
		$Animation_Bullet.queue("Die")
		playback.stop()
		is_die = true


func _on_Animation_Bullet_animation_finished(anim_name):
	if anim_name == "Die" :
		queue_free()


func _on_Bullet_X_area_entered(area):
	if is_die or area.is_in_group("Player") :
		return
	if area.is_in_group("No_Collision"):
		return
	if area.is_in_group("Enemy"):
		area.takingDamage(damage)
		if charge < 3:
			queue_free()
	if area.is_in_group("Bullet_E_Pass_Though"):
		return
	if charge < 3:
		if !area.is_in_group("Attack_Range"):
			$Animation_Bullet.queue("Die")
			playback.stop()
			is_die = true
