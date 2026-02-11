extends Camera3D

var mouse_pos : Vector2

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("camera rotate"):
		mouse_pos = get_viewport().get_mouse_position()
		#rotate_x(mouse_pos.y)
		#rotate_y(mouse_pos.x)
		
		
		
