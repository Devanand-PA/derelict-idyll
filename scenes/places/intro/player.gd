extends CharacterBody2D

# Exporting allows you to change this value in the Inspector
@export var speed = 300.0 # Pixels per second

# In Player.gd
# ... (rest of the script) ...

func _physics_process(delta):
	# Use the NEW action names
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

# ... (rest of the script) ...
