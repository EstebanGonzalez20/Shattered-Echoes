class_name Component extends Resource
func get_type() -> StringName:
	assert(false, "Componente %s no implementa get_type()" % get_class())
	return &""
