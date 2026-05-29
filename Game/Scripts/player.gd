extends CharacterBody3D

@export var movement: MovementComponent
@export var look: LookComponent
@export var input_comp: InputComponent
@export var health: HealthComponent
@export var weapon_comp: WeaponComponent

var input_system: InputSystem
var look_system: LookSystem
var movement_system: MovementSystem
var damage_system: DamageSystem
var attack_system: AttackSystem

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	input_system = Systems.get_node("InputSystem")
	look_system = Systems.get_node("LookSystem")
	movement_system = Systems.get_node("MovementSystem")
	damage_system = Systems.get_node("DamageSystem")
	attack_system = Systems.get_node("AttackSystem")
	
	
	if health != null:
		health.current_health = health.max_health

func _input(event):
	input_system.process_mouse(event, input_comp, weapon_comp, self, attack_system)

func _physics_process(delta):
	input_system.process_actions(input_comp)
	look_system.process(self, look, input_comp)
	movement_system.process(self, movement, input_comp, delta)

func take_damage(amount: float):
	damage_system.apply_direct_damage(self, amount)

func die():
	print("Jugador murió")
	queue_free()
