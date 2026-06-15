extends WorldEnvironment

func _ready() -> void:
	# Hace el material único para este nodo, evita el cacheo de Godot
	var sky_mat = environment.sky.sky_material
	if sky_mat:
		environment.sky.sky_material = sky_mat.duplicate()

func _process(_delta: float) -> void:
	var mat = environment.sky.sky_material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("time_value", Time.get_ticks_msec() / 1000.0)
