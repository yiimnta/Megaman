extends Area2D

export var health = 500
export var speed = 200
export var gravity_n = 200
export var speed_roll = 700
export var gravity_roll = 125
var is_dead = false
var EXPLODE = preload("res://scene/Enemies/Exp_00.tscn")
export var ex_scale_value = 2.5
export var collisionDamage = 15
var is_ground = false;
var player = null
var is_player_in = false
var stage = null
var player_entered_in_range_attack = false
var can_attack = true
var is_hurt = false
var flip = -1
var is_using_sk1 = false
var is_using_sk2 = false
var can_use_sk1 = true
var is_stop = true
var animation
var is_cutscene = false

func _ready():
	animation = $AnimationPlayer
	animation.queue("Idle")
	player = get_node("/root/Stage/Player")
	stage = get_node("/root/Stage")

func takingDamage(value):
	if is_hurt:
		return
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
	if (!is_ground or is_cutscene) and !is_stop:
		if is_using_sk2:
			translate(Vector2(0,gravity_roll*delta))
		else:
			translate(Vector2(0,gravity_n*delta))
	
	if !stage.is_start or is_stop or is_cutscene:
		return
	
	print($Check_Wall.is_colliding())
	if is_ground and $Check_Wall.is_colliding():
		if $Check_Wall.get_collider().is_in_group("Ground"):
			if animation.get_current_animation() == "Run":
				$Sprite.flip_h = !$Sprite.flip_h
				$Check_Skill_1.scale = Vector2($Check_Ground.scale.x*-1,1)

	if $Sprite.flip_h:
		flip = 1
	else:
		flip = -1

	if is_dead:
		death()
	else:
		if !is_using_sk1:
			animation.play("Run")
			translate(Vector2(speed * delta * flip,0))

		if is_hurt:
			if Engine.get_frames_drawn() % 3:
				$Sprite.modulate = Color("f45b5b")
			else:
				$Sprite.modulate = Color("ffffff")

func attack():
	if !stage.is_start:
		return

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Skill_1":
		is_using_sk1 = false

func _on_Timer_Attack_Delay_timeout():
	can_attack = true

func _on_Timer_Hurt_timeout():
	is_hurt = false
	$Sprite.modulate = Color("ffffff")

func _on_Boss_MS1_body_entered(body):

	if is_cutscene:
		return

	if body.is_in_group("Player"):
		if !stage.is_start:
			return
		else:
			body.enemies_entered.append(self.get_path())

func _on_Boss_MS1_body_exited(body):
	if is_cutscene:
		return
		
	if body.is_in_group("Player"):
		body.enemies_entered.erase(self.get_path())


func _on_Check_Ground_body_entered(body):
	if body.is_in_group("Ground"):
		is_ground = true

func _on_Check_Ground_body_exited(body):
	if body.is_in_group("Ground"):
		is_ground = false

func _on_Check_Skill_1_body_entered(body):
	if is_cutscene:
		return

	if body.is_in_group("Player"):
		if can_use_sk1:
			can_use_sk1 = false
			is_using_sk1 = true
			animation.play("Skill_1")
			$Timer_Skill1.start()


func _on_Timer_Skill1_timeout():
	can_use_sk1 = true
