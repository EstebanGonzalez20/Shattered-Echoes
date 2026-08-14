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

## Enum que dicta los tipos de modificadores que hay para las estadísticas.
enum ModifierType {
	## Representa un modificador aditivo: const + mod
	FLAT,
	## Representa un modificador multiplicativo: const * mod
	MULTIPLIER
}

## Posibles calidades para los objetos.
enum ItemQuality {
	## Un objeto vulgar de baja calidad
	vulgar,
	## Un objeto fino de calidad media
	fine,
	## Un objeto divino de alta calidad
	divine,
	## Un objeto espititual atado a un dios
	spiritual
}

## Hooks con los eventos a los que los 
enum EventHooks {
	## Este hook se llama cuando se acumula aquello subscrito a este hook.
	OnStack
}
