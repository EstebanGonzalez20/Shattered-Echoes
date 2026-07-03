class_name ProjectileSceneEffect extends SkillEffect

@export var projectile_scene: PackedScene ## La escena de un proyectil
@export var projectile_scalar: Vector3 ## El escalado del modelo del proyectil
@export var has_spawn_coordinates: bool ## Determina si aparece en un lado fijo, o en el lugar predeterminado (en frente del jugador)
@export var spawn_coordinates: Vector3 ## Las coordenadas en donde aparece el proyectil (la entidad es su centro)
