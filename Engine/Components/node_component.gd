## para componentes que necesitan nodos hijos
class_name NodeComponent extends Node
func get_type() -> StringName:
	assert(false, "Componente %s no implementa get_type()" % get_class())
	return &""
