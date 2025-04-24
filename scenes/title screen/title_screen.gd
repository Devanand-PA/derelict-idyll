extends Control


func _on_start_new_game_pressed():
	# Replace "res://Intro.tscn" with the actual path to your intro scene file
	var error = get_tree().change_scene_to_file("res://scenes/places/intro/intro.tscn")
	if error != OK:
		printerr("Error changing scene to Intro.tscn: ", error)
		
func _on_settings():
	# Replace "res://Intro.tscn" with the actual path to your intro scene file
	var error = get_tree().change_scene_to_file("res://settings/settings.tscn")
	if error != OK:
		printerr("Error changing scene to Intro.tscn: ", error)
		
func _on_quit_pressed():
	get_tree().quit()
