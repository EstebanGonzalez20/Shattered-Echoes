class_name EnemyBehaviorSystem
extends Node

func process(enemy: CharacterBody3D, data: EnemyPlayerDistanceComponent) -> void:
	var enemy_pos = enemy.global_transform.origin

	var closest_player = null
	var closest_distance = INF

	for player in get_tree().get_nodes_in_group("players"):
		var dist = enemy_pos.distance_to(player.global_transform.origin)

		if dist < closest_distance:
			closest_distance = dist
			closest_player = player

	if closest_player == null:
		return
	
	if closest_distance > data.max_player_distance:
		# acercarse
		enemy.nav_agent.target_position = closest_player.global_transform.origin

	elif closest_distance < data.min_player_distance:
		# alejarse
		var dir = (enemy_pos - closest_player.global_transform.origin).normalized()
		enemy.nav_agent.target_position = enemy_pos + dir * 5.0

	else:
		# quedarse quieto
		enemy.nav_agent.target_position = enemy_pos
