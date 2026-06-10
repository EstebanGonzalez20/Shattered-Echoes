class_name InputComponent
extends Component

func get_type() -> StringName:
	return &"Input"

var move_vector: Vector2 = Vector2.ZERO
var jump_pressed: bool = false
var mouse_delta: Vector2 = Vector2.ZERO
