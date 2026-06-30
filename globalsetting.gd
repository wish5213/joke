extends Node

var save_path = "user://settings.cfg" 
var config = ConfigFile.new()

var set_mine_count : int = 3
var set_joker_count : int = 4
var set_joker_rand_flag : bool = true
var set_joker_min : int = 1
var set_joker_max : int = 3
var set_joker_probability : int  = 70
var set_default_lan = 0
var set_secret_array : Array = [4,5,6,7,8,9]
var set_lan_new : String  = "zh_TW"



func _ready() -> void:
	set_mine_count = set_mine_count 
	set_joker_count = set_joker_count
	set_joker_rand_flag = set_joker_rand_flag
	set_joker_min = set_joker_min
	set_joker_max = set_joker_max
	set_joker_probability = set_joker_probability
	
	save_settings()
	
	load_settings()


func save_settings():
	config.set_value("gameset","set_mine_count",set_mine_count)
	config.set_value("jokerset","set_joker_count",set_joker_count)
	config.set_value("jokerset","set_joker_rand_flag",set_joker_rand_flag)
	config.set_value("jokerset","set_joker_min",set_joker_min)
	config.set_value("jokerset","set_joker_max",set_joker_max)
	config.set_value("jokerset","set_joker_probability",set_joker_probability)
	config.set_value("gameset","set_default_lan",set_default_lan)
	config.set_value("gameset","set_secret_array",set_secret_array)
	config.set_value("gameset","set_lan_new",set_lan_new)
	
	config.save(save_path)


func load_settings():
	var err = config.load(save_path)
	if err == OK:
		set_mine_count = config.get_value("gameset","set_mine_count",3)
		set_joker_count = config.get_value("jokerset","set_joker_count",4)
		set_joker_rand_flag = config.get_value("jokerset","set_joker_rand_flag",false)
		set_joker_min = config.get_value("jokerset","set_joker_min",1)
		set_joker_max = config.get_value("jokerset","set_joker_max",3)
		set_joker_probability = config.get_value("jokerset","set_joker_probability",4)
		set_default_lan = config.get_value("gameset","set_default_lan",0)
		set_secret_array = config.get_value("gameset","set_secret_array",[4,5,6,7,8,9])
		set_lan_new = config.get_value("gameset","set_lan_new","zh_TW")
			
	else:
		pass
