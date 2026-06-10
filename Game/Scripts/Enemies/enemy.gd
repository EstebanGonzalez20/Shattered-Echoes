extends CharacterBody3D

@export var movement: MovementComponent
@export var enemy_player_distance: EnemyPlayerDistanceComponent

var enemy_behavior_system: EnemyBehaviorSystem
var movement_system: MovementSystem

@onready var nav_agent = $NavigationAgent3D

func _ready() -> void:
	enemy_behavior_system = Systems.get_node("EnemyBehaviorSystem")
	movement_system = Systems.get_node("MovementSystem")
	movement_system.connect_navigation_signal(self)

func _physics_process(delta: float) -> void:
	enemy_behavior_system.process(self, enemy_player_distance)
	
	var parameters: MovementSystemParameters = MovementSystemParameters.new()
	parameters.set_enemy_parameters(self, movement)
	
	movement_system.process('enemy', parameters, delta)
