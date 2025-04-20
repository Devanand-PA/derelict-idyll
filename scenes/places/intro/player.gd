extends CharacterBody2D
# Exporting allows you to change this value in the Inspector
@export var speed = 300.0 # Pixels per second

func _physics_process(delta):
	# Get input direction vector
	# Input.get_vector(negative_x, positive_x, negative_y, positive_y)
	# This automatically handles normalization (diagonal speed isn't faster)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Set velocity based on direction and speed
	if direction:
		velocity = direction * speed
	else:
		# If no input, stop moving
		velocity = Vector2.ZERO # Or move_toward(velocity, Vector2.ZERO, speed) for gradual stop

	# Move the character and handle collisions
	# move_and_slide() is the core function for CharacterBody2D movement
	move_and_slide()
