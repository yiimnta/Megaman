extends Area2D

var health = 30
var is_dead = false
var EXPLODE = preload("res://scene/Enemies/Exp_00.tscn")
export var ex_scale_value = 2.5
export var collisionDamage = 15
var is_ground = false;
var player = null
var is_player_in = false
var WEAPON = preload("res://scene/Enemies/E_01_Attack.tscn")
var stage = null
var player_entered_in_range_attack = false
var can_attack = true
var is_hurt = false

func _ready():
	$AnimationPlayer.queue("Idle")
	player = get_node("/root/Stage/Player")
	stage = get_node("/root/Stage")

func takingDamage(value):
	health -= value

	if health <= 0:
		is_dead = true
	else:
		is_hurt = true
		$Timer_Hurt.start()

func death():
	var explode = EXPLODE.instance()
	explode.s_scale(ex_scale_value)
	get_parent().add_child(explode)
	explode.position = position
	explode.position.y-=10
	$CollisionShape2D.disabled = true
	queue_free()

func _physics_process(delta):
	if is_dead:
		death()
	else:
		if !is_ground:
			translate(Vector2(0,100*delta));
		
		if !stage.is_start:
			return
		if can_attack and player_entered_in_range_attack:
			attack()
		
		if is_hurt:
			if Engine.get_frames_drawn() % 3:
				$Sprite.modulate = Color("f45b5b")
			else:
				$Sprite.modulate = Color("ffffff")

func _on_Node2D_body_entered(body):
	if body.is_in_group("Ground"):
		is_ground = true
	if body.is_in_group("Player"):
		if !stage.is_start:
			return
		else:
			body.takingDamage(collisionDamage)
		body.enemies_entered.append(self.get_path())

func _on_Node2D_body_exited(body):
	if body.is_in_group("Ground"):
		is_ground = false
	if body.is_in_group("Player"):
		body.enemies_entered.erase(self.get_path())

func _on_Attack_Range_body_entered(body):
	if body.is_in_group("Player"):
		player_entered_in_range_attack = true

func _on_Attack_Range_body_exited(body):
	if body.is_in_group("Player"):
		player_entered_in_range_attack = false

func attack():
	if !stage.is_start:
		return
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Attack")
	var wp = WEAPON.instance()
	wp.get_node("Sprite").flip_h = $Sprite.flip_h
	wp.position = $Pos_Shooter.global_position
	get_parent().add_child(wp)
	can_attack = false
	$Timer_Attack_Delay.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Attack"):
		$AnimationPlayer.play("Idle")


func _on_Timer_Attack_Delay_timeout():
	can_attack = true

func _on_Timer_Hurt_timeout():
	is_hurt = false
	$Sprite.modulate = Color("ffffff")
