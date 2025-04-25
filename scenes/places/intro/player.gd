extends CharacterBody2D

func _input(event):
	if event.is_action_pressed("escape_button"):
		print("Escape pressed")
		SettingsManager.change_scene("res://settings/settings.tscn")
