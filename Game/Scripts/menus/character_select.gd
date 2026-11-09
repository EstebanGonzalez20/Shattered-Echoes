extends Node3D

@onready var character_display := $CharacterDisplay
@onready var characters : Node3D = $Characters

var active : bool = false
var character_list : Array = []
var current_index : int = 0 :
	set(new_value):
		if new_value > character_list.size() - 1:
			current_index = 0
		
		elif new_value < 0:
			current_index = character_list.size() - 1
		
		else:
			current_index = new_value

var current_character : CharacterContainer :
	get:
		return character_list[current_index]

func _ready() -> void:
	character_display.visible = false
	for character in characters.get_children():
		character_list.append(character)

func start() -> void:
	active = true
	character_display.visible = true
	character_display.display_character(current_character.character_info)

func _process(delta: float) -> void:
	if active:
		if Input.is_action_just_pressed("move_right"):
			current_index += 1
			character_display.display_character(current_character.character_info)
		
		if Input.is_action_just_pressed("move_left"):
			current_index -= 1
			character_display.display_character(current_character.character_info)
