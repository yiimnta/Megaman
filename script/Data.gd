extends Node2D

var lives = 0
var save_path = "res://save/data.cfg"
var config = ConfigFile.new()
var load_response = config.load(save_path)
var player = null

func _ready():
	player = get_node("/root/Stage/Player")	
	pass
	
func saveData(section, key, value):
	config.set_value(section, key, value)
	config.save(save_path)

func loadData(section, key, value):
	return config.get_value(section, key, value)
