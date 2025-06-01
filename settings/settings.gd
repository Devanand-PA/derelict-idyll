extends Control

func on_save_button_pressed():
	SettingsManager.save_game()

func on_load_button_pressed():
	SettingsManager.load_game()
	
func _on_quit_pressed() -> void:
	get_tree().quit()
