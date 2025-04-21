extends Control

func _on_keybind_settings_pressed():
	# Replace "res://Intro.tscn" with the actual path to your intro scene file
	var error = get_tree().change_scene_to_file("res://settings/keybind_settings.tscn")
	if error != OK:
		printerr("Error changing scene to keybind_settings.tscn: ", error)
