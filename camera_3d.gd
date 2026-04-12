extends Camera3D

@export var main_camera: Camera3D
@onready var mani_camera = get_node("/World3D/Camera3D")

func _process(delta):
		if main_camera:
			global_transform = main_camera.global_transform
