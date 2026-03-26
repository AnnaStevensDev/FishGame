extends CharacterBody3D
# How fast the player moves in meters per second.
@onready var movement_speed = 5
@export var rotation_speed = .1
@onready var acceleration = 10

@onready var pointer : Sprite3D = $Pointer
@onready var raycast  : RayCast3D  = $RayCast3D
# The downward acceleration when in the air, in meters per second squared.

var target_velocity = Vector3.ZERO


func _physics_process(delta: float) -> void: 
	var movement_direction = Vector3.ZERO
	var rotation = Vector3.ZERO
	# MOVEMENT
	if Input.is_action_pressed("move_right"):
		movement_direction.x += 1
	if Input.is_action_pressed("move_left"):
		movement_direction.x -= 1
	if Input.is_action_pressed("move_back"):
		movement_direction.z += 1
	if Input.is_action_pressed("move_forward"):
		movement_direction.z -= 1
	# ROTATION
	#if Input.is_action_just_pressed("rotate_clockwise"):
		#rotation.y = 30 / rotation_speed # this division here is to prevent any changes to rotation speed breaking this
	if Input.is_action_pressed("rotate_clockwise"):
		rotation.y += PI/6
	#if Input.is_action_just_pressed("rotate_counterclockwise"):
		#rotation.y = 30 / rotation_speed
	if Input.is_action_pressed("rotate_counterclockwise"):
		rotation.y -= PI/6
	
	if movement_direction != Vector3.ZERO:
		movement_direction = movement_direction.normalized()
	
	if rotation != Vector3.ZERO:
		self.rotation.y += rotation.y * rotation_speed
		#pointer.rotation.y += rotation.y * rotation_speed
		
	target_velocity.x = movement_direction.x * movement_speed
	target_velocity.z = movement_direction.z * movement_speed
	
	pointer.position += movement_direction * .05
	
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	move_and_slide()
	
	var normal = raycast.get_collision_normal() # the normal is the perpendicular unit vector ! 
	var xform = align_with_fish(global_transform, normal)
	global_transform = global_transform.interpolate_with(xform, .2)
	
	
func align_with_fish(xform, new_y : Vector3):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y) # get cross product
	xform.basis = xform.basis.orthonormalized()
	return xform
	
