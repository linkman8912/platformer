extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0
const DASH_VELOCITY = 1000

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Input.get_axis("ui_left", "ui_right")
var walljumped = 0
var walljumpedLast = 0
var wasInAir = false
var oldYvelocity = 0
var walljumpY = 600
var walljumpX = 600
var hasDashed = 0
var dashState = 0
var dashDirection = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor():
		walljumpedLast = 0
		hasDashed = false
		
	if Input.is_action_just_pressed("Dash") and hasDashed == false:
		dashState = 2
		

	# Handle jump.
	if Input.is_action_pressed("Jump") and is_on_floor():
		if wasInAir:
			velocity.y = JUMP_VELOCITY - oldYvelocity
		else:
			velocity.y = JUMP_VELOCITY
	direction = Input.get_axis("ui_left", "ui_right")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if walljumped != 0 and is_on_floor():
		walljumped = 0
	elif walljumped != 0:
		if walljumped > 0.2:
			walljumped -= 0.2
			velocity.x = SPEED * 2
		elif walljumped < -0.2:
			walljumped += 0.2
			velocity.x = SPEED * -2
		else:
			walljumped = 0
	elif dashState != 0:
		if dashState < 0.2:
			dashState = 0
		else:
			pass # should use direction to figure out where to move
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if not is_on_floor():
		wasInAir = true
		oldYvelocity = velocity.y
	else:
		wasInAir = false

func _ready():
	walljumped = 0

func _on_area_2d_2_body_entered(body):
	if walljumpedLast != 1 and Input.is_action_pressed("ui_accept"):
		velocity.y -= 400
		velocity.x += 600
		walljumped = 3
		walljumpedLast = 1
		print("walljumped left")


func _on_area_2d_body_entered(body):
	if walljumpedLast != -1 and Input.is_action_pressed("ui_accept"):
		velocity.y = -walljumpY
		velocity.x = -walljumpX
		walljumped = -3
		walljumpedLast = -1
		print("walljumped right")


func _on_area_2d_3_body_entered(body):
	if walljumpedLast != 1 and Input.is_action_pressed("ui_accept"):
		velocity.y = -walljumpY
		velocity.x = walljumpX
		walljumped = 3
		walljumpedLast = 1
		print("walljumped left")  
 
