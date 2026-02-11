extends Area3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var respawn_pos = Vector3(-0.17,0.7,-0.25)

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body is Car:
		body.position = respawn_pos
		body.linear_velocity = Vector3.ZERO
		body.speed_input = 0
