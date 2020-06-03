extends CanvasLayer

var can_enter = false

func _ready():
	$GAME/Sprite/AnimationPlayer.play("Run")
	$OVER/Sprite/AnimationPlayer.play("Run")
	$Label.visible = false
	$Timer.start()

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		$Accept.play()
		$Timer2.start()

func _on_Timer_timeout():
	$Label.visible = true
	can_enter = true

func _on_Timer2_timeout():
	get_tree().change_scene("res://scene/TitleScreen.tscn")
