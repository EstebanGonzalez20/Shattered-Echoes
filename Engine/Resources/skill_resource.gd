class_name SkillResource extends Resource

## Enum con los posibles efectos de una habilidad.
enum EffectType {
	Damage,
	ShotSpeed,
	Duration,
	ProjectileScene
}

## Diccionario con los efectos de una habilidad.
@export var effects: Dictionary[EffectType, SkillEffect]
