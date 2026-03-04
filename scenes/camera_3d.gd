extends Node3D

var mouse_pos : Vector2
@onready var phantom_camera_3d: PhantomCamera3D = $".."
@onready var car_rb: Car = $"../../car_rb"
@onready var car_pause: Node3D = $"../../car_pause"

@export var min_x = -0.5
@export var max_x = 0.5
@export var min_z = -0.5
@export var max_z = 0.5
var pos_y = 1.75



func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		phantom_camera_3d.global_position.x += event.relative.x/get_viewport().get_visible_rect().size.x
		phantom_camera_3d.global_position.z += event.relative.y/get_viewport().get_visible_rect().size.y


func _process(delta: float) -> void:
	if car_rb.current_state == car_rb.Car_state.PAUSED:
		phantom_camera_3d.look_at_target = car_pause
	elif car_rb.current_state == car_rb.Car_state.IDLE or car_rb.current_state == car_rb.Car_state.BOOST:
		phantom_camera_3d.look_at_target = car_rb
	phantom_camera_3d.global_position.x = clamp(phantom_camera_3d.global_position.x, min_x,max_x)
	phantom_camera_3d.global_position.z = clamp(phantom_camera_3d.global_position.z,min_z,max_z)
	phantom_camera_3d.global_position.y = pos_y
