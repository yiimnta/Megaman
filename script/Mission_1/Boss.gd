extends Area2D

export var health = 500
export var speed = 200
export var gravity_n = 200
export var speed_roll = 700
export var gravity_roll = 125
var is_dead = false
var EXPLODE = preload("res://scene/Enemies/Exp_00.tscn")
var MOON = preload("res://scene/Bullet/Moon.tscn")
var TORNADO = preload("res://scene/Bullet/Tornado.tscn")
var audio_tornado = load("res://audio/Enemies/Boss/Tornado.wav")

export var ex_scale_value = 2.5
export var collisionDamage = 15
export var skill3_Damage = 15
var is_ground = false;
var player = null
var is_player_in = false
var stage = null
var player_entered_in_range_attack = false
var can_attack = true
var is_hurt = false
var flip = -1
#skills
export var is_using_sk1 = false
export var is_using_sk2 = false
export var is_using_sk3 = false
export var is_using_sk3_repared = false
export var is_using_sk3_run = false
export var can_use_sk1 = true
export var can_use_sk2 = false
export var can_use_sk3 = false
export var throw_sk2 = false 
var is_stop = true
var animation
var is_cutscene = false
var can_shoot_skill1 = false
var pos_shoot_skill1 = 0
var first_time = true
var is_first_time_sk3 = true
var half_heath
var can_use_skill = true
var explose = true

func _ready():
	animation = $AnimationPlayer
	animation.queue("Idle")
	player = get_node("/root/Stage/Player")
	stage = get_node("/root/Stage")
	half_heath = health/2

func takingDamage(value):
	if is_hurt:
		return
	health -= value

	if health <= 0:
		is_dead = true
		$AudioDeath.play()
	else:
		is_hurt = true
		$Timer_Hurt.start()

func death():
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("Die")
	if !explose:
		return
	explose = false
	var explode = EXPLODE.instance()
	explode.s_scale(ex_scale_value)
	get_parent().add_child(explode)
	explode.position = position
	explode.position.y = rand_range(explode.position.y - 40,explode.position.y + 40 )
	explode.position.x = rand_range(explode.position.x - 20,explode.position.x + 20 )
	$Timer_Death.start()

func _physics_process(delta):

	if (!is_ground or is_cutscene) and !is_stop:
		if is_using_sk2:
			translate(Vector2(0,gravity_roll*delta))
		else:
			translate(Vector2(0,gravity_n*delta))
	
	if !stage.is_start or is_stop or is_cutscene:
		return

	if is_ground and $Check_Wall.is_colliding():
		if $Check_Wall.get_collider().is_in_group("Ground"):
			$Sprite.flip_h = !$Sprite.flip_h
			if is_using_sk3:
				stage.get_node("ScreenShake").screen_shake(0.5,10,100)
				stage.get_node("ScreenShake").playAudio()
				if player.on_wall:
					player.takingDamage(skill3_Damage)
					
	
	if $Sprite.flip_h:
		$Check_Wall.rotation_degrees = 180
	else:
		$Check_Wall.rotation_degrees = 0

	if first_time:
		$Timer_Skill2_Delay.start()
		first_time = false
		is_using_sk1 = false
		is_using_sk2 = false

	if $Sprite.flip_h:
		flip = 1
	else:
		flip = -1

	if is_dead:
		death()
	else:
		if is_hurt:
			if Engine.get_frames_drawn() % 3:
				$Sprite.modulate = Color("f45b5b")
			else:
				$Sprite.modulate = Color("ffffff")

		if is_first_time_sk3 and health <= half_heath:
			can_use_sk3 = true
			is_first_time_sk3 = false

		if is_using_sk3_repared:
			return
		if !is_using_sk1 and !is_using_sk2 and !is_using_sk3:
			animation.play("Run")
			translate(Vector2(speed * delta * flip,0))
		
		if can_use_skill == false:
			return
			
		if can_use_sk2 and !is_using_sk1 and !is_using_sk2 and !is_using_sk3:
			can_use_sk2 = false
			is_using_sk2 = true
			throw_sk2 = true
			$Timer_Skill2.start()
			animation.play("Angry")
			$AudioStreamPlayer.stream = audio_tornado
			$AudioStreamPlayer.play()
		
		if can_use_sk3 and !is_using_sk1 and !is_using_sk2 and !is_using_sk3:
			is_using_sk3_repared = true
			can_use_sk3 = false
			$AnimationPlayer.play("Skill_3_R")
			$Timer_Skill3.start()
		
		if is_using_sk3:
			$AnimationPlayer.play("Skill_3")
			translate(Vector2(speed_roll * delta * flip,0))

		if is_using_sk2 and throw_sk2:
			var to1 = TORNADO.instance()
			to1.position = player.global_position
			to1.position.y = self.global_position.y
			get_parent().add_child(to1)
			throw_sk2 = false
			$Timer_Skill2_Throw.start()
		
		if is_using_sk1:
			if can_shoot_skill1:
				var moon = MOON.instance()
				if flip == -1:
					moon.position = $Pos_Skill1_L.global_position
				else:
					moon.position = $Pos_Skill1_R.global_position
				moon.get_node("Sprite").flip_h = $Sprite.flip_h
				if pos_shoot_skill1 == 0:
					moon.position.y -= 50
					moon.rotate = 60 * -flip
				elif pos_shoot_skill1 == 1:
					moon.position.y -= 25
					moon.rotate = 30 * -flip
				else:
					moon.rotate = 0

				pos_shoot_skill1 +=1
				if pos_shoot_skill1 > 2:
					pos_shoot_skill1 = 0
				get_parent().add_child(moon)
				can_shoot_skill1 = false
				$Timer_Skill1_Delay.start()

func attack():
	if !stage.is_start:
		return

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Skill_1":
		is_using_sk1 = false
	if anim_name == "Skill_3_R":
		is_using_sk3 = true
		is_using_sk3_repared = false
		$AnimationPlayer.play("Skill_3")
	if anim_name == "Die":
		queue_free()

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
		if can_use_skill == false:
			return

		if is_using_sk2 or is_using_sk3 or is_using_sk3_repared:
			return

		if can_use_sk1:
			can_use_sk2 = false
			can_use_sk1 = false
			can_use_sk3 = false
			is_using_sk1 = true
			animation.play("Skill_1")
			$Timer_Skill1.start()
			$Timer_Skill1_Repare.start()
			if(body.position.x > position.x):
				$Sprite.flip_h = true
			else:
				$Sprite.flip_h = false

func _on_Timer_Skill1_timeout():
	can_use_sk1 = true
	can_use_sk2 = true
	can_shoot_skill1 = false
	pos_shoot_skill1 = randi()%2

func _on_Timer_Skill1_Repare_timeout():
	can_shoot_skill1 = true

func _on_Timer_Skill1_Dekay_timeout():
	can_shoot_skill1 = true

func _on_Timer_Skill2_Delay_timeout():
	can_use_sk2 = true

func _on_Timer_Skill2_timeout():
	is_using_sk2 = false
	$Timer_Skill2_Delay.start()

func _on_Timer_Skill2_Throw_timeout():
	throw_sk2 = true

func _on_Timer_Skill3_timeout():
	is_using_sk3 = false
	position.y-=40
	can_use_skill = false
	$Timer_Pause.start()


func _on_Timer_Pause_timeout():
	can_use_skill = true


func _on_Timer_Death_timeout():
	explose = true
