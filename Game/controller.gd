class_name Controller extends Node

var attack_system := AttackSystem.new()
var collision_system := CollisionSystem.new()
var health_system := HealthSystem.new()
var enemy_behavior_system := EnemyBehaviorSystem.new()
var enemy_movement_system := EnemyMovementSystem.new()
var input_system := InputSystem.new()
var look_system := LookSystem.new()
var pickup_system := PickupSystem.new()
var player_movement_system := PlayerMovementSystem.new()
var projectile_movement_system := ProjectileMovementSystem.new()
var skill_system := SkillSystem.new()

var players: Array[Node]
var players_entities: Array[EntityComponent]
var enemies: Array[Node]


## Libera una entidad de la escena
func free_entity(entity: Node3D) -> void:
	if entity in players:
		players.erase(entity)
		var entity_comp: EntityComponent = entity.get_node("EntityComponent")
		players_entities.erase(entity_comp)
	elif entity in enemies:
		enemies.erase(entity)
	
	entity.queue_free()
	if players.size() == 0:
		get_tree().paused = true


## Ejecuta la lógica de todas las tareas de una lista
func process_tasks(tasks: Array[Task]) -> void:
	tasks.map(func(t): execute_task(t))
	tasks.clear()


## Ejecuta cierta lógica dependiendo del tipo de tarea
func execute_task(task: Task) -> void:
	match task.get_script():
		PerformAttackTask:
			attack_system.perform_attack(task, get_tree().current_scene)
		
		DamageEntityTask:
			var entity := health_system.apply_damage(task)
			if entity != null:
				free_entity(entity)
		
		HealEntityTask:
			health_system.apply_heal(task)


## Evento para escuchar cuando una hurtbox entra en un área
func _on_hurtbox_entered(hurtbox: Area3D, other_area: Area3D) -> void:
	var other_entity: EntityComponent = other_area.get_node("EntityComponent")
	if other_entity == null:
		return
	
	var tasks: Array[Task] = collision_system.process_collision(hurtbox, other_entity)
	process_tasks(tasks)


## Evento para escuchar cuando se computa la velocidad de un enemigo
func _on_navigation_velocity(enemy: CharacterBody3D, safe_velocity: Vector3) -> void:
	enemy_movement_system.on_velocity_computed(safe_velocity, enemy)


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	players = get_tree().get_nodes_in_group("players")
	for player in players:
		players_entities.append(player.get_node("EntityComponent") as EntityComponent)
	
	SignalBus.navigation_velocity_computed.connect(
		_on_navigation_velocity
	)
	
	SignalBus.hurtbox_entered.connect(
		_on_hurtbox_entered
	)


func _input(event):
	input_system.process_movement(players_entities[0].get_component(&"Input"))
	
	if event is InputEventMouseMotion:
		input_system.process_mouse_motion(event, players_entities[0].get_component(&"Input"))
	
	var action_name: StringName
	for action in Global.ACTIONS:
		if event.is_action_pressed(action):
			action_name = action
			break
	
	match action_name:
		&"basic_attack", &"special_attack":
			var weapon: Weapon = players_entities[0].get_component(&"Weapon")
			var skill: SkillResource = weapon.get(action_name)
			
			var tasks: Array[Task] = skill_system.process_skill(skill, players[0], players_entities[0], weapon)
			process_tasks(tasks)

func _physics_process(delta: float):
	player_movement_system.movement_process(players[0], players_entities[0], delta)
	look_system.look_process(players[0], players_entities[0])
	
	for projectile in get_tree().get_nodes_in_group("projectiles"):
		var proj_duration: Duration = projectile.get_node("EntityComponent").get_component(&"Duration")
		proj_duration.duration -= delta
		
		if proj_duration.duration <= 0:
			projectile.queue_free()
		
		projectile_movement_system.movement_process(projectile,
			projectile.get_node("EntityComponent").get_component(&"ShotSpeed"), delta)
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var enemy_nav: NavigationAgent3D = enemy.get_node("NavigationAgent3D")
		if enemy_nav != null:
			enemy_behavior_system.process_enemy_behavior(enemy, players)
			enemy_movement_system.process_movement(enemy, delta)
