extends Node2D

var top_text = null
var bot_text = null
export var bb_top = []
export var bb_bot= []
export var order = []
export var avatars = []
export var labels = []
var avatar_path="res://sprite/avatar/"
var index_order = 0
var top_page = 0
var bot_page = 0
var top_avatar = null
var bot_avatar = null
var top_lb = null
var bot_lb = null
var top_ani = null
var bot_ani = null
var top_is_show = false
var bot_is_show = false
var actived = false

func _ready():
	top_text = $Top/Dialog/RichTextLabel
	bot_text = $Bottom/Dialog/RichTextLabel
	top_avatar = $Top/Avatar
	bot_avatar = $Bottom/Avatar
	top_lb = $Top/Dialog/Label
	bot_lb = $Bottom/Dialog/Label
	top_ani = $Top/AnimationPlayer
	bot_ani = $Bottom/AnimationPlayer

func _input(event):
	if !actived or isEnd():
		return
	if Input.is_action_just_pressed("ui_accept"):
		setText()

func setTextFirst():
	if index_order >= len(order):
		return
	if !order[index_order]:
		bot_lb.set_text(labels[index_order])
		bot_avatar.texture = load(avatar_path + avatars[index_order])
		bot_text.set_bbcode(bb_bot[bot_page])
		bot_text.set_visible_characters(0)
		bot_page +=1
	else:
		top_lb.set_text(labels[index_order])
		top_avatar.texture = load(avatar_path + avatars[index_order])
		top_text.set_bbcode(bb_top[top_page])
		top_text.set_visible_characters(0)
		top_page +=1
	index_order+=1

func setText():
	if top_text.get_visible_characters() < top_text.get_total_character_count() or bot_text.get_visible_characters() < bot_text.get_total_character_count():
		return;
	if index_order >= len(order):
		return
	if !order[index_order]:
		if !bot_is_show:
			bot_ani.play("Show")
			bot_is_show =true
		changeTextBot()
	else:
		if !top_is_show:
			top_ani.play("Show")
			top_is_show = true
		changeTextTop()
	index_order+=1

func isEnd():
	if index_order == order.size():
		if top_text.get_visible_characters() > top_text.get_total_character_count():
			if bot_text.get_visible_characters() > bot_text.get_total_character_count():
				return true
	return false

func changeTextTop():
	if top_text.get_visible_characters() > top_text.get_total_character_count():
		if top_page < bb_top.size():
			$AudioStreamPlayer.play()
			top_lb.set_text(labels[index_order])
			top_avatar.texture = load(avatar_path + avatars[index_order])
			top_text.set_bbcode(bb_top[top_page])
			top_text.set_visible_characters(0)
			top_page +=1

func changeTextBot():
	if bot_text.get_visible_characters() > bot_text.get_total_character_count():
		if bot_page < bb_bot.size():
			$AudioStreamPlayer.play()
			bot_lb.set_text(labels[index_order])
			bot_avatar.texture = load(avatar_path + avatars[index_order])
			bot_text.set_bbcode(bb_bot[bot_page])
			bot_text.set_visible_characters(0)
			bot_page +=1

func show():
	top_lb.set_text(labels[index_order])
	top_avatar.texture = load(avatar_path + avatars[index_order])
	bot_lb.set_text(labels[index_order])
	bot_avatar.texture = load(avatar_path + avatars[index_order])
	if !order[index_order]:
		bot_ani.play("Show")
		bot_is_show = true
	else:
		top_ani.play("Show")
		top_is_show = true
	$Timer.start()

func _on_Timer_timeout():
	setTextFirst()
