extends RefCounted

class_name RoomNode

enum RoomType {
	START,
	COMBAT,
	SPECIAL_ROOM,
	ELITE,
	BOSS
}
var id: int
var room_type: RoomType
var connections: Array[int] = []
var depth: int = 0

var parent_id: int = -1
var world_position: Vector2i = Vector2i.ZERO
