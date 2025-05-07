extends CharacterBody2D

var acceleration = 20
var friction = 80
func _input(event):
	if event.is_action_pressed("escape_button"):
		print("Escape pressed")
		SettingsManager.change_scene("res://settings/settings.tscn")

var max_speed = 600


func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	input_dir = input_dir.normalized()
	if input_dir != Vector2.ZERO :
		velocity = velocity.move_toward(input_dir * max_speed,acceleration)
	else :
		velocity = velocity.move_toward(Vector2.ZERO,friction)
	move_and_collide(velocity * delta)
