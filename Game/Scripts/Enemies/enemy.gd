extends CharacterBody3D

@export var movement: MovementComponent
@export var enemy_player_distance: EnemyPlayerDistanceComponent

var enemy_behavior_system: EnemyBehaviorSystem
var enemy_movement_system: EnemyMovementSystem

@onready var nav_agent = $NavigationAgent3D

func _ready() -> void:
	enemy_behavior_system = Systems.get_node("EnemyBehaviorSystem")
	enemy_movement_system = Systems.get_node("EnemyMovementSystem")
	enemy_movement_system.connect_navigation_signal(self)

func _physics_process(delta: float) -> void:
	enemy_behavior_system.process(self, enemy_player_distance)
	enemy_movement_system.process(self, movement, delta)
