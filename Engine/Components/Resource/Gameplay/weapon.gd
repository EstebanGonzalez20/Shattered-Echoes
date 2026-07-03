class_name Weapon extends Component

func get_type() -> StringName:
	return &"Weapon"

@export var basic_attack: SkillResource ## La habilidad que usa el arma como ataque básico
@export var special_attack: SkillResource ## La habilidad que usa el arma como habilidad especial
@export var scaling_damage: ScalableStatEffect ## Variable usada para calcular el daño del arma
@export var scaling_healing: ScalableStatEffect ## Variable usada para calcular el curado del arma
@export var scaling_attack_speed: ScalableStatEffect ## Variable usada para calcular la cadencia del ataque básico
