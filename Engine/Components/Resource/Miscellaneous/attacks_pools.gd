class_name AttacksPools extends Component

func get_type() -> StringName:
	return &"AttacksPools"

@export var attacks_pools: Array[AttacksPool] ## Representa Todos los ataques de un enemigo en cada fase (los índices de la lista)
