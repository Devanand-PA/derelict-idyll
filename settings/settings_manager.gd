extends Node

const KEYBINDS_SAVE_PATH = "user://keybinds.cfg"
# You might want REBINDABLE_ACTIONS here too, or pass it during save/load
const REBINDABLE_ACTIONS = ["move_left", "move_right", "move_up", "move_down"] # Keep consistent!

func _ready():
	print("SettingsManager: Loading keybinds on startup.")
	load_keybinds()

func save_keybinds():
	var config = ConfigFile.new()
	for action in REBINDABLE_ACTIONS:
		var events = InputMap.action_get_events(action)
		if events.size() > 0 and events[0] is InputEventKey:
			var key_event = events[0] as InputEventKey
			config.set_value("keybinds", action, key_event.physical_keycode)
		else:
			config.set_value("keybinds", action, null)
	var error = config.save(KEYBINDS_SAVE_PATH)
	if error != OK:
		printerr("Error saving keybinds: ", error)
	else:
		print("SettingsManager: Keybinds saved.")


func load_keybinds():
	var config = ConfigFile.new()
	var error = config.load(KEYBINDS_SAVE_PATH)
	if error != OK:
		if error == ERR_FILE_NOT_FOUND:
			print("Keybinds file not found. Using defaults (from InputMap).")
			save_keybinds() # Create file with defaults if not found
		else:
			printerr("Error loading keybinds: ", error)
		return

	var loaded_count = 0
	for action in REBINDABLE_ACTIONS:
		if config.has_section_key("keybinds", action):
			var saved_keycode = config.get_value("keybinds", action)
			InputMap.action_erase_events(action) # Clear current bindings first!
			if saved_keycode != null and saved_keycode is int:
				var new_event = InputEventKey.new()
				new_event.physical_keycode = saved_keycode
				InputMap.action_add_event(action, new_event)
				loaded_count += 1
			# else: Action remains unbound if saved_keycode was null or invalid

	print("SettingsManager: Loaded %d keybinds." % loaded_count)

	# Important: After loading, ensure the InputMap is up-to-date for the engine
	InputMap.load_from_project_settings() # Re-syncs with project defaults potentially, check if needed
	# The manual adding/erasing above should be sufficient, test without this line first.
	
