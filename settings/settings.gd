extends Control
func _input(event):
	if event.is_action_pressed("escape_button"):
		print("Escape pressed")
		print("Current scene is :",SettingsManager.curr_scene)
		print("Last Scene was :",SettingsManager.last_scene)
		SettingsManager.change_scene(SettingsManager.last_scene)

func on_save_button_pressed():
	SettingsManager.save_game()

func on_load_button_pressed():
	SettingsManager.load_game()
