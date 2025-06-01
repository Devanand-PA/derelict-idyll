extends Control

func on_keybind_settings_pressed():
	keybindwindow.visible = true
	curr_settings = "keybinds"
	
func on_save_button_pressed():
	SettingsManager.save_game()

func on_load_button_pressed():
	SettingsManager.load_game()
	
func _on_quit_pressed() -> void:
	get_tree().quit()

var is_settings_open = false
@onready 	var settings_menu = self
@onready var curr_settings = ""
@onready var keybindwindow = $KeybindSettings
func _ready() -> void:
	self.visible = false
	keybindwindow.visible = false
	keybindwindow.position = $"..".position
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape_button") == true:

		var settings_menu = self
		settings_menu.position = $"../playerSprite1".position
		if is_settings_open == false :
			if curr_settings == "" :
				print("Opening settings")
				get_tree().paused = true
				is_settings_open = true
				curr_settings = "settings"
				keybindwindow.visible = false
				settings_menu.visible = true
			elif curr_settings == "settings" :
				print("This shouldn't be happening")

		elif is_settings_open == true :
			get_tree().paused = false
			if curr_settings == "settings" :
				print("Closing Settings")
				curr_settings = ""
				print("curr_settings is :", curr_settings)
				keybindwindow.visible = false
				settings_menu.visible = false
				is_settings_open = false

			elif curr_settings == "keybinds" :
				keybindwindow.visible = false
				settings_menu.visible = true
				is_settings_open = true
				curr_settings = "settings"
		print(curr_settings, is_settings_open)
