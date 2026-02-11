class_name Car
extends RigidBody3D
@onready var car_mesh: MeshInstance3D = $"../car_mesh"



var acceleration = 0.25
var steering_angle = 18.0
var turn_speed = 0.2
var jump_force = 0.07
var max_height = 1

var speed_input = 0
var turn_input = 0



func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	apply_central_force(car_mesh.global_basis.z * speed_input)
	speed_input = Input.get_axis("brake","accelerate") * acceleration
	turn_input = Input.get_axis("steer_right","steer_left") * deg_to_rad(steering_angle)
	car_mesh.rotate_y(turn_input * turn_speed)
	print(turn_input * turn_speed)

	if Input.is_action_just_pressed("jump") :
		apply_impulse(jump_force * Vector3.UP)
		#if position.y >= max_height:
			#linear_velocity.y = 0
