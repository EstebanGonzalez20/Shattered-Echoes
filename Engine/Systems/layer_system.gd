extends Node

class_name LayerSystem

func connect_rooms(room_a: RoomNode, room_b: RoomNode) -> void:

	if !room_a.connections.has(room_b.id):
		room_a.connections.append(room_b.id)

	if !room_b.connections.has(room_a.id):
		room_b.connections.append(room_a.id)


func generate_main_path(length: int) -> Array[RoomNode]:
	var rooms: Array[RoomNode] = []

	for i in range(length):
		var room = RoomNode.new()
		room.id = i

		if i == 0:
			room.room_type = RoomNode.RoomType.START
		elif i == length - 1:
			room.room_type = RoomNode.RoomType.BOSS
		else:
			room.room_type = RoomNode.RoomType.COMBAT

		rooms.append(room)

	for i in range(length - 1):
		connect_rooms(rooms[i], rooms[i + 1])

	return rooms


func add_shop(rooms: Array[RoomNode]):

	var candidates: Array[RoomNode] = []

	for room in rooms:
		if room.room_type == RoomNode.RoomType.COMBAT:
			candidates.append(room)

	var parent = candidates.pick_random()

	var shop = RoomNode.new()
	shop.id = rooms.size()
	shop.room_type = RoomNode.RoomType.SPECIAL_ROOM

	connect_rooms(parent, shop)

	rooms.append(shop)


func add_branch(rooms: Array[RoomNode]):

	var parent = rooms.pick_random()

	if parent.room_type in [
		RoomNode.RoomType.START,
		RoomNode.RoomType.BOSS,
		RoomNode.RoomType.SPECIAL_ROOM
	]:
		return

	var branch = RoomNode.new()

	branch.id = rooms.size()
	branch.room_type = RoomNode.RoomType.COMBAT

	connect_rooms(parent, branch)

	rooms.append(branch)


func add_long_branch(rooms: Array[RoomNode], length: int):

	var parent = rooms.pick_random()

	while parent.room_type in [
		RoomNode.RoomType.START,
		RoomNode.RoomType.BOSS,
		RoomNode.RoomType.SPECIAL_ROOM
	]:
		parent = rooms.pick_random()

	var previous = parent

	for i in range(length):

		var room = RoomNode.new()
		room.id = rooms.size()

		if i == length - 1:
			room.room_type = RoomNode.RoomType.ELITE
		else:
			room.room_type = RoomNode.RoomType.COMBAT

		connect_rooms(previous, room)

		rooms.append(room)

		previous = room
