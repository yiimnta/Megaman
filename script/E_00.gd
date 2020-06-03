extends Area2D

var health = 10
var is_dead = false
var EXPLODE = preload("res://scene/Enemies/Exp_00.tscn")
export var ex_scale_value = 3
var is_immunity = false
export var collisionDamage = 15
var is_ground = false;
var player = null
var stage = null
var is_player_in = false

func _ready():
	$AnimationPlayer.queue("Idle")
	is_immunity = true
	player = get_node("/root/Stage/Player")
	stage = get_node("/root/Stage")

func takingDamage(value):
	if is_immunity:
		immunity()
		return
	health -= value
	if health <= 0:
		is_dead = true

func death():
	var explode = EXPLODE.instance()
	explode.s_scale(ex_scale_value)
	get_parent().add_child(explode)
	explode.position = position
	$CollisionShape2D.disabled = true
	queue_free()

func _physics_process(delta):
	if is_dead:
		death()
	else:
		if !is_ground:
			translate(Vector2(0,100*delta));

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Idle":
		is_immunity = false
		$AnimationPlayer.queue("Stand")
	if anim_name == "Stand":
		is_immunity = true
		$AnimationPlayer.queue("Idle_Re")
	if anim_name == "Idle_Re":
		$AnimationPlayer.queue("Idle")

func immunity():
	$AudioStreamPlayer2D.stream = load("res://audio/Enemies/immunity.wav")
	$AudioStreamPlayer2D.play()

func _on_E_00_body_entered(body):
	if body.is_in_group("Player"):
		if !stage.is_start:
			return
		else:
			body.takingDamage(collisionDamage)
		body.enemies_entered.append(self.get_path())

func _on_E_00_body_exited(body):
	if body.is_in_group("Player"):
		body.enemies_entered.erase(self.get_path())

func _on_check_ground_body_entered(body):
	if body.is_in_group("Ground"):
		is_ground = true

func _on_check_ground_body_exited(body):
	if body.is_in_group("Ground"):
		is_ground = false
