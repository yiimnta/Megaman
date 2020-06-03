extends TileMap

var ROCK = preload("res://scene/Mission1/Rock.tscn")
var tile = 10
var xs
var ys
var rock_row
var offset
var c_offset = 0
var c_row = 0
var is_creating = false
var is_stop = false
var r_offset = -1
var is_start = false

func _ready():
	xs = get_parent().xs
	ys = get_parent().ys
	rock_row = get_parent().rock_row
	offset = get_parent().offset

func _process(delta):
	if !is_start:
		return
	if (!is_stop):
		if(!is_creating):
			var ro = ROCK.instance()
			ro.position = position
			ro.position.x += c_offset * 36
			ro.position.y += 30
			ro.x = xs+c_offset
			ro.y = ys-c_row
			add_child(ro)
			c_offset+=1
			if(c_offset >= len(offset)):
				c_offset = 0
				c_row +=1
			if(c_row >= rock_row):
				is_stop = true
				return
			is_creating = true
			$Timer.start()

func create_cell(x, y):
	set_cell(x-1,y+r_offset,tile)
	if(!$AudioStreamPlayer2D.playing):
		$AudioStreamPlayer2D.play()

func _on_Timer_timeout():
	is_creating = false
