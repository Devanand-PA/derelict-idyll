extends CharacterBody2D
var idle_counter = 0
var acceleration = 20
var friction = 80
var input_dir = Vector2.ZERO
func _input(event):
	if event.is_action_pressed("escape_button"):
		print("Escape pressed")
		SettingsManager.change_scene("res://settings/settings.tscn")

var max_speed = 600
var playerDirection =  Vector2(0,1)
@onready var playerSprite = $playerSprite1
var playerVelocity = Vector2.DOWN

func move_up():
	input_dir[1] = 1
	print('what')

func move_down():
	input_dir[1] = -1
	
func move_left():
	input_dir[0] = -1
	
func move_right():
	input_dir[0] = 1

func _physics_process(delta):

	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	input_dir = input_dir.normalized()
	if input_dir != Vector2.ZERO :
		velocity = velocity.move_toward(input_dir * max_speed,acceleration)
		playerVelocity = velocity
		# Movement animation
		playerDirection = input_dir
		if playerDirection[1] > 0 :
			playerSprite.play("idle_down")
		elif playerDirection[1] < 0 :
			playerSprite.play("idle_up")
		elif playerDirection[0] < 0 :
			playerSprite.play("idle_left")
		elif playerDirection[0] > 0 :
			playerSprite.play("idle_right")
			
			
	else :
		if velocity != Vector2.ZERO :
			velocity = velocity.move_toward(Vector2.ZERO,friction)
			idle_counter = 0
			playerSprite.stop()
		else :
			idle_counter +=1*delta

	# idle animation
	if (input_dir == Vector2.ZERO) and (velocity == Vector2.ZERO) and (idle_counter > 5) :
		if playerDirection[1] > 0 :
			playerSprite.play("idle_down")
		elif playerDirection[1] < 0 :
			playerSprite.play("idle_up")
		elif playerDirection[0] < 0 :
			playerSprite.play("idle_left")
		elif playerDirection[0] > 0 :
			playerSprite.play("idle_right")
		
	move_and_collide(velocity * delta)
	print(idle_counter,playerDirection)	
