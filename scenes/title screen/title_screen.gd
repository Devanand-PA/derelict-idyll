extends Control

func _ready() -> void:
	SettingsManager.initScene()

func _on_start_new_game_pressed() -> void:
	SettingsManager.change_scene("res://scenes/places/intro/intro.tscn")

func on_settings_button_pressed():
	SettingsManager.change_scene("res://settings/settings.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

func on_resume_button_pressed() :
	SettingsManager.load_game()
