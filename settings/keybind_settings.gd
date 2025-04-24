extends Control
signal closed
# List of actions you want to allow rebinding for
const REBINDABLE_ACTIONS = ["move_left", "move_right", "move_up", "move_down","jump","sprint","interact","back_button"] # Add other actions like "jump", "interact"

func _on_back_button_pressed():
	closed.emit() # Emit the signal first
	queue_free()  # Then remove the scene from the tree
# Dictionary to map action names to their UI buttons
var action_buttons = {}

# Variable to store which action we are currently waiting to rebind
var action_to_rebind = null

# Path to save the keybinds
const KEYBINDS_SAVE_PATH = "user://keybinds.cfg"


func _ready():
	# --- Populate action_buttons dictionary (Adjust paths based on your scene structure) ---
	action_buttons["move_left"] = $MarginContainer/VBoxContainer/HBoxContainer/BindKey_move_left
	action_buttons["move_right"] = $MarginContainer/VBoxContainer/HBoxContainer2/BindKey_move_right
	action_buttons["move_up"] = $MarginContainer/VBoxContainer/HBoxContainer3/BindKey_move_up # Assuming you add these
	action_buttons["move_down"] = $MarginContainer/VBoxContainer/HBoxContainer4/BindKey_move_down # Assuming you add these
	action_buttons["jump"] = $MarginContainer/VBoxContainer/HBoxContainer5/BindKey_jump
	action_buttons["sprint"] = $MarginContainer/VBoxContainer/HBoxContainer6/BindKey_sprint
	action_buttons["interact"] = $MarginContainer/VBoxContainer/HBoxContainer7/BindKey_move_interact
	action_buttons["back_button"] = $MarginContainer/VBoxContainer/HBoxContainer8/BindKey_back_button
	# ... Add entries for other action buttons ...

	# --- Connect button signals ---
	for action in REBINDABLE_ACTIONS:
		if action_buttons.has(action):
			# When a button is pressed, call _on_rebind_button_toggled
			# Pass the action name and the button itself as arguments using bind()
			action_buttons[action].toggled.connect(_on_rebind_button_toggled.bind(action, action_buttons[action]))
		else:
			printerr("Button not found in action_buttons for action: ", action)

	# Optional: Connect a "Back" button if you have one
	# $MarginContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

	# --- Load saved keybinds OR apply defaults ---
	load_keybinds()
	# --- Update button text initially ---
	update_all_button_texts()


# Called when one of the rebind buttons is toggled (pressed/released)
func _on_rebind_button_toggled(pressed: bool, action_name: String, button: Button):
	if pressed:
		# Start waiting for input for THIS action
		action_to_rebind = action_name
		button.text = "Press key..."

		# Untoggle other buttons if they were active
		for other_action in REBINDABLE_ACTIONS:
			if other_action != action_name and action_buttons.has(other_action):
				action_buttons[other_action].button_pressed = false # Untoggle visually
				if action_buttons[other_action].text == "Press key...": # Reset text if needed
					update_button_text(other_action, action_buttons[other_action])

	else:
		# Stopped waiting for input for THIS action (user clicked again)
		if action_to_rebind == action_name: # Only reset if this button was the active one
			action_to_rebind = null
			update_button_text(action_name, button) # Reset text to show current key


# Handles global input events - perfect for catching the next key press
func _unhandled_input(event: InputEvent):
	# Check if we are currently waiting to rebind an action
	if action_to_rebind == null:
		return # Not waiting, do nothing

	# Check if the input is a key press (and not a release or echo)
	if event is InputEventKey and event.is_pressed() and not event.is_echo():

		# --- Optional: Prevent binding certain keys (like Escape) ---
		if event.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled() # Consume the event
			# Reset the button state without rebinding
			var button = action_buttons[action_to_rebind]
			button.button_pressed = false # Untoggle visually
			action_to_rebind = null
			update_button_text(button.get_meta("action_name"), button) # Reset text
			return

		# --- Rebind the action ---
		# 1. Clear previous events for this action
		InputMap.action_erase_events(action_to_rebind)
		# 2. Add the new key event
		InputMap.action_add_event(action_to_rebind, event)

		# --- Update UI & Stop Waiting ---
		var button = action_buttons[action_to_rebind]
		update_button_text(action_to_rebind, button)
		button.button_pressed = false # Untoggle visually
		action_to_rebind = null # Stop waiting

		# --- Save the changes ---
		save_keybinds()

		# --- Mark event as handled ---
		# Prevents the key press from triggering game actions immediately
		get_viewport().set_input_as_handled()


# Updates the text of a specific button to show its currently bound key
func update_button_text(action_name: String, button: Button):
	var events = InputMap.action_get_events(action_name)
	if events.size() > 0:
		# Get the first key event associated with the action
		# Note: This simplified example only handles the *first* key found
		var key_event = events[0] as InputEventKey
		if key_event:
			# Get a human-readable string for the key
			button.text = OS.get_keycode_string(key_event.get_physical_keycode_with_modifiers()).capitalize()
		else:
			button.text = "[Not Key]" # If it's a mouse button or joystick
	else:
		button.text = "[Unbound]"


# Loop through all actions and update their button texts
func update_all_button_texts():
	for action in REBINDABLE_ACTIONS:
		if action_buttons.has(action):
			update_button_text(action, action_buttons[action])


# --- Saving and Loading ---

func save_keybinds():
	var config = ConfigFile.new()

	# Loop through actions and save the first key event's physical keycode
	for action in REBINDABLE_ACTIONS:
		var events = InputMap.action_get_events(action)
		if events.size() > 0 and events[0] is InputEventKey:
			var key_event = events[0] as InputEventKey
			# Use physical_keycode for better layout independence
			config.set_value("keybinds", action, key_event.physical_keycode)
		else:
			# Handle cases where it's unbound or not a key (optional)
			config.set_value("keybinds", action, null) # Or some indicator

	var error = config.save(KEYBINDS_SAVE_PATH)
	if error != OK:
		printerr("Error saving keybinds: ", error)


func load_keybinds():
	var config = ConfigFile.new()
	var error = config.load(KEYBINDS_SAVE_PATH)

	if error != OK:
		if error == ERR_FILE_NOT_FOUND:
			print("Keybinds file not found. Using defaults (from InputMap).")
			# Optionally apply hardcoded defaults here if needed
			# apply_default_keybinds() # You would need to create this function
			save_keybinds() # Create the file with current InputMap settings
		else:
			printerr("Error loading keybinds: ", error)
		return # Stop loading on error

	# Clear existing events and load saved ones
	for action in REBINDABLE_ACTIONS:
		if config.has_section_key("keybinds", action):
			var saved_keycode = config.get_value("keybinds", action)

			if saved_keycode != null and saved_keycode is int: # Make sure it's a valid keycode int
				InputMap.action_erase_events(action) # Clear current bindings
				var new_event = InputEventKey.new()
				new_event.physical_keycode = saved_keycode # Use physical keycode
				# Note: You might want to save/load modifiers (Shift, Ctrl, Alt) too for more complex binds
				InputMap.action_add_event(action, new_event)
			else:
				# Handle case where saved value is null (unbound)
				InputMap.action_erase_events(action)
		#else:
			# Optional: Handle actions defined in REBINDABLE_ACTIONS but not found in the save file
			# Maybe apply a default? Or leave it as defined in InputMap?


# Optional: Function to go back from the settings menu
#func _on_back_pressed():
#   get_tree().change_scene_to_file("res://TitleScreen.tscn") # Or hide this panel


# --- Helper to get human-readable key names (already used in update_button_text) ---
# Note: OS.get_keycode_string() is built-in and usually sufficient.
	
