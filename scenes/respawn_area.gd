extends Area3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var start: Node3D = $"../start"




func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body is Car:
		body.position = start.position
		body.linear_velocity = Vector3.ZERO
		body.speed_input = 0
