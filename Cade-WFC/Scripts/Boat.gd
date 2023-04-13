extends RigidBody3D

# defining boat movement properties
@export var speed: float = 1.0
@export var acceleration: float = 3.0
@export var deceleration: float = 0.1
var direction = Vector3.ZERO

# ref to the camera within the WFC-World scene
@onready var camera = get_node("/root/WFC-World/World/Camera3D") as Camera3D

func _process(_delta):
	
	# reset boat position when 'generate_world' is pressed (SPACEBAR)
	if(Input.is_action_just_pressed("generate_world")):
		global_transform.origin = Vector3(8,0,5)

func _physics_process(delta: float) -> void:
	movement()
	forces(delta)
	rotate_boat()

# calculates the desired movement direction
func movement() -> void:
	
	direction = Vector3(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		0,
		Input.get_action_strength("Back") - Input.get_action_strength("Forward")
	)
	
	# convert the direction to global coordinates, remove vertical component (boat would fly away)
	direction = (camera.to_global(direction) - camera.global_transform.origin)
	direction.y = 0
	direction = direction.normalized()

# apply forces based on the movement direction and acceleration/deceleration
func forces(_delta: float) -> void:
	var acceleration_amount = acceleration if direction != Vector3.ZERO else deceleration
	apply_central_force((direction * speed) * acceleration_amount)

# rotate the boat to face the direction of movement
func rotate_boat() -> void:
	var target_position = global_transform.origin + linear_velocity
	if !global_transform.origin.is_equal_approx(target_position):
		look_at(target_position, Vector3.UP)
