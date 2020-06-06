extends KinematicBody2D

enum{IDLE,
	 RUN,
	 RUN_SHOOT,
	 JUMP,
	 JUMP_SHOOT,
	 HURT,
	 DASH,
	 SHOOT,
	 DIE}

var state
var is_dead = false
var is_hurt = false
var gravity_power = 1
export var lives = 2
export var health = 100
export var camera_limit = [0,0,0,0]
const MAX_HEALTH = 100
const BASE_LIVES = 2
const MAX_LIVES = 9
const JUMP_POWER = -585
const CLIMB_POWER = -630
const DASH_POWER = 550
const GRAVITY = 25
const FLOOR = Vector2(0,-1)
const BULLET = preload("res://scene/Bullet_X.tscn")
const DASH_DEKO_BEFORE = preload("res://scene/Dash_Deko.tscn")
const DASH_DEKO_AFTER = preload("res://scene/Dash_Deko_After.tscn")
const GHOST = preload("res://scene/Ghost_X.tscn")

var velocity = Vector2()
var is_charge = false
export var on_ground = false
export var on_dash = false
export var can_press_key = true
export var SPEED = 170
export var charge_shoot = 0

var can_climb = true
var can_climb_down = true
var can_shoot = true
var can_jump = true
var audioFS = null
var audioA = null
var audioShooter = null
var audio_Stage = null
var can_dash = true
var stage = null
var dash_deko_a = null
var dash_deko_b = null
var is_immunity = false
var enemies_entered = []
var section = "Player"
var is_wall_inside = false
var on_wall = false
var is_cutscreen = false

func _ready():
	audioShooter = $X/Audio_Shooter
	audioA = $X/Audio_Player
	audioFS = $X/Audio_Foot_Step
	audio_Stage = $X/Audio_Stage
	stage = get_node("/root/Stage")
	setAudioFootStep(stage.audio_foot_step)
	setAudioStage(stage.music_stage)
	lives = $Data.loadData(section,"lives",lives)
	$Camera2D.limit_top = camera_limit[0]
	$Camera2D.limit_right = camera_limit[1]
	$Camera2D.limit_bottom = camera_limit[2]
	$Camera2D.limit_left = camera_limit[3]

func setAudioStage(music):
	if music != null:
		audio_Stage.stop()
		audio_Stage.stream = music
		audio_Stage.play()
	
func setAudioFootStep(music):
	if music != null:
		audioFS.stop()
		audioFS.stream = music
		audioFS.play()

func _physics_process(delta):
	
	if !is_cutscreen:
		if is_dead:
			return
	
		if stage.is_start:
			quanque()

	update_floor()
	if stage.is_start:
		if !is_hurt:
			velocity.y += GRAVITY
			velocity.y *= gravity_power
			velocity = move_and_slide(velocity, FLOOR)

		if is_immunity:
			self.modulate.a = 0.2 if Engine.get_frames_drawn() % 3 == 0 else 1.0
		else:
			self.modulate.a = 1.0

			var dam = 0
			for i in enemies_entered:
				if weakref(get_node(i)).get_ref():
					dam += get_node(i).collisionDamage
				else:
					enemies_entered.erase(get_node(i))
			if dam > 0:
				takingDamage(dam)

func quanque():
	if is_hurt or is_dead:
		return

	var key_right = Input.is_action_pressed("ui_right")
	var key_left = Input.is_action_pressed("ui_left")
	var key_jump = Input.is_action_just_pressed("ui_key_x")
	var key_shoot_down = Input.is_action_just_pressed("ui_key_c")
	var key_shoot_released = Input.is_action_just_released("ui_key_c")
	var key_dash = Input.is_action_just_pressed("ui_key_z")

	if key_right:
		$RayCast2D.rotation_degrees = 270
		$RayCast2D2.rotation_degrees = 90
	elif key_left:
		$RayCast2D.rotation_degrees = 90
		$RayCast2D2.rotation_degrees = 270
	
	on_wall =  ($RayCast2D.is_colliding() and $RayCast2D.get_collider().is_in_group("Ground")) or ($RayCast2D2.is_colliding() and $RayCast2D2.get_collider().is_in_group("Ground"))
	gravity_power = 1
	
	if (key_left or key_right) and on_wall and !on_ground:
		if key_jump:
			climb()
		elif can_climb_down:
			climb_down()
	
	is_charge = get_node("X/Charge_Shoot").is_charge

	if key_shoot_down and can_dash:
		shoot()
	elif key_shoot_released and is_charge:
		shoot()
	if key_right:
		move_right()
	elif key_left:
		move_left()
	else:
		velocity.x = 0
	
	if on_ground:
		if can_jump and key_jump:
			jump()

	if key_left or key_right:
		if can_dash and key_dash:
			dash()

func move_right():
	velocity.x = SPEED
	$X.flip_h = false
	if sign($Shoot_Pos.position.x) == -1:
		$Shoot_Pos.position.x += 20
		$Shoot_Pos.position.x *= -1
		$X.get_node("Dash_Deko_Before").position.x *= -1
		$X.get_node("Dash_Deko_Before").position.x *= -1
		$X.get_node("Dash_Deko_After").position.x *= -1
	if !audioFS.is_playing() and can_dash and can_jump and !on_wall:
		audioFS.play()

func move_left():
	velocity.x = -SPEED
	$X.flip_h = true
	if sign($Shoot_Pos.position.x) == 1 :
		$Shoot_Pos.position.x += 20
		$Shoot_Pos.position.x *= -1
		$X.get_node("Dash_Deko_Before").position.x *= -1
		$X.get_node("Dash_Deko_After").position.x *= -1
	if !audioFS.is_playing() and can_dash and can_jump and !on_wall:
		audioFS.play()

func jump():
	audioA.stream = load("res://audio/X/jump/jump.wav")
	audioA.play()
	velocity.y = JUMP_POWER
	on_ground = false
	can_jump = false
	audioFS.stop()

func climb():
	if !can_climb:
		return
	audioA.stream = load("res://audio/X/jump/jump.wav")
	audioA.play()
	velocity.y = CLIMB_POWER
	audioFS.stop()
	can_climb = false
	can_climb_down = false
	$Timer_Climb.start()
	$Timer_Climb_Down.start()

func climb_down():
	gravity_power = 0.80


func update_floor():
	if is_on_floor():
		on_ground = true
		if Input.is_action_pressed("ui_key_x"):
			can_jump = false
		else:
			can_jump = true
	else:
		on_ground = false

func shoot():
	if !can_shoot:
		return
	can_shoot = false
	charge_shoot = get_node("X/Charge_Shoot").charge_shoot
	if charge_shoot == 1:
		audioShooter.stream = load("res://audio/X/shooter/small.wav")
	elif charge_shoot == 2:
		audioShooter.stream = load("res://audio/X/shooter/normal.wav")
	else:
		if !$Audio_X.playing:
			$Audio_X.stream = load("res://audio/X/shooter/big.wav")
			$Audio_X.play()

	audioShooter.play()
	var bullet = BULLET.instance()
	bullet.charge = charge_shoot
	bullet.damage *= charge_shoot 
	bullet.can_shoot = true
	if on_wall and gravity_power == 0.80:
		$Shoot_Pos.position.x *= -1
		bullet.flip_h = !$X.flip_h
		bullet.position = $Shoot_Pos.global_position
		$Shoot_Pos.position.x *= -1
	else:
		bullet.flip_h = $X.flip_h
		bullet.position = $Shoot_Pos.global_position
	get_parent().add_child(bullet)
	get_node("Timer_Shoot").start()

func dash():
	if !on_ground and !on_wall:
		return;
	audioFS.stop()
	SPEED = DASH_POWER
	can_dash = false
	
	if on_ground:
		audioA.stream = load("res://audio/X/dash/dash.wav")
		audioA.play()
		dash_deko_b = DASH_DEKO_BEFORE.instance()
		dash_deko_b.get_node("Sprite").flip_h = $X.flip_h
		dash_deko_b.position = $X.get_node("Dash_Deko_Before").position
		$X.add_child(dash_deko_b)

	dash_deko_a = DASH_DEKO_AFTER.instance()
	dash_deko_a.get_node("Sprite").flip_h = $X.flip_h
	dash_deko_a.position = $X.get_node("Dash_Deko_After").position	
	$X.add_child(dash_deko_a)
	$Timer.start()

func death():
	is_dead = true
	velocity = Vector2(0,0)
	audioA.stream = load("res://audio/X/die.wav")
	audioA.play()
	$Collision.disabled = true
	stage.is_start = false
	$Timer_dead.start()

func hurt():
	is_hurt = true
	is_immunity = true
	velocity = Vector2(0,0)
	audioA.stream = load("res://audio/X/hurt.wav")
	audioA.play()
	$Timer_hurt.start()
	$Timer_immunity.start()

func takingDamage(value):
	if is_immunity or is_cutscreen:
		return
	health -= value
	if health <= 0:
		death()
	else:
		hurt()

func _on_Timer_timeout():
	SPEED = 170
	can_dash = true

func _on_Timer_Shoot_timeout():
	can_shoot = true

func _on_Timer_Ghost_timeout():
	if SPEED < DASH_POWER:
		return
	$Timer_Create_Ghost.start()

func _on_Timer_hurt_timeout():
	is_hurt = false	

func _on_Timer_dead_timeout():
	lives-=1
	if lives < 0:
		$Data.saveData(section,"lives", BASE_LIVES)
		get_tree().change_scene("res://scene/GameOver.tscn")
	else:
		$Data.saveData(section,"lives",lives)
		get_tree().change_scene(stage.scene_path)
		get_tree().reload_current_scene()

func _on_Timer_immunity_timeout():
	is_immunity = false

func _on_Timer_Climb_timeout():
	can_climb = true

func _on_Timer_Create_Ghost_timeout():
	var this_ghost = GHOST.instance()
	get_parent().add_child(this_ghost)
	this_ghost.position = position
	this_ghost.flip_h = $X.flip_h
	this_ghost.frame = $X.frame

func _on_Timer_Climb_Down_timeout():
	can_climb_down = true
