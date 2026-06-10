extends Resource
class_name MovementSystemParameters

var entity: Node3D
var move_component: MovementComponent
var input_component: InputComponent
var speed: float
 

func set_player_parameters(entity: CharacterBody3D, move_component: MovementComponent, input_component: InputComponent):
	self.entity = entity
	self.move_component = move_component
	self.input_component = input_component

func set_enemy_parameters(entity: CharacterBody3D, move_component: MovementComponent):
	self.entity = entity
	self.move_component = move_component

func set_projectile_parameters(entity: Area3D, speed: float):
	self.entity = entity
	self.speed = speed
