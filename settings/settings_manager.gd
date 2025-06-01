extends Node


static var curr_scene: String
static var last_scene: String
static var last_setting: String
static var curr_setting: String
func initScene():
	print("Current scene is :",SettingsManager.curr_scene)
	print("Last Scene was :",SettingsManager.last_scene)

func change_scene(new_scene: String):
	last_scene = curr_scene
	curr_scene = new_scene
	get_tree().change_scene_to_file(new_scene)


func save_game():
	# Bad idea since this will probably return settings menu or something
	var save_dict = {
		"curr_scene" : SettingsManager.curr_scene,
		"last_scene" : SettingsManager.last_scene,
		"curr_x_pos" : Globals.player_position_x,
		"curr_y_pos" : Globals.player_position_y,
	}
	print(save_dict)
	var save_file = FileAccess.open("user://savegame.json",FileAccess.WRITE)
	save_file.store_string(JSON.stringify(save_dict, "\t"))
	save_file = null
	
func load_game():
	var load_file = FileAccess.open("user://savegamea.json",FileAccess.READ)
	print("This is soem shit", load_file.get_as_text())
	var load_dict = JSON.parse_string(load_file.get_as_text())
	load_file = null
	if load_dict :
		SettingsManager.curr_scene = load_dict.curr_scene
		SettingsManager.last_scene = load_dict.last_scene
		Globals.player_position_x = load_dict.curr_x_pos
		Globals.player_position_y = load_dict.curr_y_pos
	SettingsManager.change_scene(SettingsManager.curr_scene)
	print("New positions are : ",Globals.player_position_x,Globals.player_position_y)
	
	
	
