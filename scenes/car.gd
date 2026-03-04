class_name Car
extends RigidBody3D
@onready var ray_cast_ground: RayCast3D = $RayCast3D
@onready var start: Node3D = $"../start"
@onready var turbo_timer: Timer = $turbo_timer
@onready var car_model: Node3D = $"../car_model"
@onready var username: TextEdit = %Username





var has_checkpoint_one : bool
var has_checkpoint_two : bool
var has_checkpoint_three : bool
var has_checkpoint_four : bool
var has_checkpoint_five : bool
signal check

var can_use_turbo : bool

enum Car_state {
	IDLE,
	PAUSED,
	BOOST
}
var current_state : Car_state

@export var acceleration : float
@export var turbo : float
var steering_angle = 10.0
var turn_speed = 0.2
var jump_force = 0.25
var max_jump = 0.73
var ground = 0.71
var speed_input = 0
var turn_input = 0



func _ready() -> void:
	position = start.position
	current_state = Car_state.PAUSED



func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if current_state != Car_state.PAUSED:
		if ray_cast_ground.is_colliding():
			apply_central_force(car_model.global_basis.z * speed_input)
		speed_input = Input.get_axis("brake","accelerate") * acceleration
		turn_input = Input.get_axis("steer_right","steer_left") * deg_to_rad(steering_angle)
		car_model.rotate_y(turn_input * turn_speed)
		if current_state == Car_state.BOOST:
			acceleration = 1.75
		else :
			acceleration = 0.75
		
		if Input.is_action_just_pressed("jump"):
			Handle_jumping()

		if Input.is_action_just_pressed("turbo"):
			if can_use_turbo:
				current_state = Car_state.BOOST
				turbo_timer.start()




func Handle_jumping() -> void:
	if ray_cast_ground.is_colliding():
		apply_impulse(jump_force * Vector3.UP)


func _on_checkpoint_1_body_entered(body: Node3D) -> void:
	if body is Car :
		if !has_checkpoint_one && !has_checkpoint_two && !has_checkpoint_three && !has_checkpoint_four && !has_checkpoint_five:
			has_checkpoint_one = true
			check.emit()


func _on_checkpoint_2_body_entered(body: Node3D) -> void:
	if body is Car:
		if has_checkpoint_one && !has_checkpoint_two && !has_checkpoint_three && !has_checkpoint_four && !has_checkpoint_five:
			has_checkpoint_two = true
			check.emit()


func _on_checkpoint_3_body_entered(body: Node3D) -> void:
	if body is Car:
		if has_checkpoint_one && has_checkpoint_two && !has_checkpoint_three && !has_checkpoint_four && !has_checkpoint_five:
			has_checkpoint_three = true
			check.emit()

func _on_checkpoint_4_body_entered(body: Node3D) -> void:
	if body is Car:
		if has_checkpoint_one && has_checkpoint_two && has_checkpoint_three && !has_checkpoint_four && !has_checkpoint_five:
			has_checkpoint_four = true
			check.emit()

func _on_checkpoint_5_body_entered(body: Node3D) -> void:
		if body is Car:
			if has_checkpoint_one && has_checkpoint_two && has_checkpoint_three && has_checkpoint_four && !has_checkpoint_five:
				has_checkpoint_five = true
				can_use_turbo = true
				check.emit()

func _on_respawn_area_body_entered(body: Node3D) -> void:
	if body is Car :
		reset_car()

func reset_car()-> void:
	position = start.position
	has_checkpoint_one = false
	has_checkpoint_two = false
	has_checkpoint_three = false
	has_checkpoint_four = false
	has_checkpoint_five =false
	can_use_turbo = false
	acceleration = 0.75
	current_state = Car_state.PAUSED

func _on_turbo_timer_timeout() -> void:
	if current_state == Car_state.BOOST:
		current_state = Car_state.IDLE
