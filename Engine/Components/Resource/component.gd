class_name Component extends Resource
func get_type() -> StringName:
	assert(false, "Componente %s no implementa get_type()" % get_class())
	return &""

## Este método está para los componentes que necesiten terminar de asignar valores o realizar cierta lógica antes de ser usados.
func initialize() -> void:
	pass
