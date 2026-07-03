class_name Globals extends Node

## Lista de los tipos de acción que puede realizar el jugador con inputs para ejecutar una habilidad.
const ACTIONS: Array[StringName] = [
	&"basic_attack",
	&"special_attack",
]

## Enum con los posibles efectos de una habilidad.
enum EffectType {
	Damage,
	Healing,
	AttackSpeed,
	ShotSpeed,
	Duration,
	Uses,
	ProjectileScene
}

## Enum que dicta qué objetos pertenecen a qué layer
enum CollisionLayers {
	WORLD = 0,
	PLAYERS = 1,
	ENEMIES = 2,
	PROJECTILES = 3,
	PICKUPS = 4
}
