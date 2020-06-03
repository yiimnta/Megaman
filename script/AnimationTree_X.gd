extends AnimationTree

enum{IDLE,
	 RUN,
	 RUN_SHOOT,
	 JUMP,
	 JUMP_SHOOT,
	 HURT,
	 DASH,
	 SHOOT,
	 DIE,
	CLIMB,
	CLIMB_DOWN,
	CLIMB_DOWN_END,
	CLIMB_SHOOT}

var state
var anim
var new_anim
var is_cutscreen

var playback : AnimationNodeStateMachinePlayback
onready var myPlayer = get_node("/root/Stage/Player")
var stage = null
var player = null
var is_gerade_climb_shoot = false

func _ready():
	active = true
	playback = get("parameters/playback")
	playback.start("Idle")
	change_state(IDLE)
	stage = get_node("/root/Stage")
	player = get_node("/root/Stage/Player")
	is_cutscreen = false

func _process(delta):

	if stage.is_start:
		if !is_cutscreen:
			get_input()
	
	if player.visible:
		if player.is_hurt:
			change_state(HURT)
			
		if player.is_dead:
			change_state(DIE)

		if new_anim != anim:
			anim = new_anim
			playback.travel(anim)

func get_input():
	if player.is_dead or player.is_hurt :
		return
	var key_right = Input.is_action_pressed("ui_right")
	var key_left = Input.is_action_pressed("ui_left")
	var key_jump = Input.is_action_just_pressed("ui_key_x")
	var key_shoot_down = Input.is_action_just_pressed("ui_key_c")
	var key_shoot_released = Input.is_action_just_released("ui_key_c")
	var key_dash = Input.is_action_just_pressed("ui_key_z")
	var is_shooting = (key_shoot_down and !myPlayer.is_charge) or (key_shoot_released and myPlayer.is_charge)
	
	if !myPlayer.can_climb:
		change_state(CLIMB)
		return

	if !myPlayer.on_ground or (key_jump and myPlayer.on_ground):
		if is_shooting:
			if myPlayer.gravity_power == 0.80:
				change_state(CLIMB_SHOOT)
				is_gerade_climb_shoot = true
			else:
				change_state(JUMP_SHOOT)
		elif myPlayer.gravity_power == 0.80:
			change_state(CLIMB_DOWN)
		else:
			change_state(JUMP)
	elif myPlayer.SPEED == myPlayer.DASH_POWER:
		change_state(DASH)
	elif key_right or key_left:
		if is_shooting:
			change_state(RUN_SHOOT)
		else:
			change_state(RUN)
	elif key_shoot_down or (key_shoot_released and myPlayer.is_charge):
		change_state(SHOOT)
	else:
		change_state(IDLE)
	#print(playback.get_current_node())

func change_state(new_state):
	state = new_state;
	match state:
		IDLE:
			new_anim = "Idle"
		RUN:
			new_anim = "Run"
		RUN_SHOOT:
			new_anim = "Run_Shoot"
		JUMP:
			new_anim = "Jump"
		JUMP_SHOOT:
			new_anim = "Jump_Shoot"
		HURT:
			new_anim = "Hurt"
		DASH:
			new_anim = "Dash"
		SHOOT:
			new_anim = "Shoot"
		DIE:
			new_anim = "Die"
		CLIMB:
			new_anim = "Climb"
		CLIMB_DOWN:
			new_anim = "Climb_Down"
		CLIMB_DOWN_END:
			new_anim = "Climb_Down_End"
		CLIMB_SHOOT:
			new_anim = "Climb_Shoot"
