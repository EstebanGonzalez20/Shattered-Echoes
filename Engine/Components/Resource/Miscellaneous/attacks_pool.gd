class_name AttacksPool extends Component

func get_type() -> StringName:
	return &"AttacksPool"

@export var attacks_pool: Array[SkillResource] ## Representa Todos los ataques de un enemigo en una fase
