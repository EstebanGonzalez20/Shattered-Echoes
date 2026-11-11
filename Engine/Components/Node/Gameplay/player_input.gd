class_name PlayerInput extends NodeComponent

signal player_action(action_name : StringName)

func get_type() -> StringName:
	return &"Input"

var move_vector: Vector2 = Vector2.ZERO
var jump_pressed: bool = false
var mouse_delta: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	var action_name: StringName
	for action in Global.ACTIONS:
		if event.is_action_pressed(action):
			action_name = action
			break
	
	match action_name:
		&"basic_attack", &"special_attack":
			player_action.emit(action_name)
