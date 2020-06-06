extends Node2D

var camera
var amplitude = 0
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_OUT
var priority = 0

func _ready():
	camera = get_node("/root/Stage/Player/Camera2D")

func move_camera(vector):
	camera.offset = Vector2(rand_range(-vector.x, vector.x), rand_range(-vector.y, vector.y))

func screen_shake(length, power, priority):
	if priority > self.priority:
		self.priority = priority
		$Shake.interpolate_method(self, "move_camera", Vector2(power, power), Vector2(0,0), length, TRANS, EASE, 0)
		$Shake.start()

func _on_Shake_tween_completed(object, key):
	self.priority = 0

func playAudio():
	if !$Audio.playing:
		$Audio.play()
