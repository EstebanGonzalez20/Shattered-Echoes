class_name EnemyBehaviorSystem extends RefCounted

func process_enemy_behavior(enemy: CharacterBody3D, players) -> void:
	var enemy_pos = enemy.global_transform.origin
	var enemy_entity: EntityComponent = enemy.get_node("EntityComponent")
	var enemy_nav_agent: NavigationAgent3D = enemy.get_node("NavigationAgent3D")
	var enemy_behavior_comp: EnemyBehavior = enemy_entity.get_component("EnemyBehavior")
	
	var closest_player = null
	var closest_distance = INF
	
	for player in players:
		var dist = enemy_pos.distance_to(player.global_transform.origin)
		
		if dist < closest_distance:
			closest_distance = dist
			closest_player = player
	
	if closest_player == null:
		return
		
	if closest_distance > enemy_behavior_comp.max_player_distance:
		# acercarse
		enemy_nav_agent.target_position = closest_player.global_transform.origin
	
	elif closest_distance < enemy_behavior_comp.min_player_distance:
		# alejarse
		var dir = (enemy_pos - closest_player.global_transform.origin).normalized()
		enemy_nav_agent.target_position = enemy_pos + dir * 5.0
	
	else:
		# quedarse quieto
		enemy_nav_agent.target_position = enemy_pos
