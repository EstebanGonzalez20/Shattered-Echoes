extends Control

@onready var characters_name : Label = $PanelContainer/VBoxContainer/CharactersName
@onready var splashart: TextureRect = $PanelContainer/VBoxContainer/Splashart
@onready var health_label: RichTextLabel = $PanelContainer/VBoxContainer/StatContainerTop/HealthLabel
@onready var damage_label: RichTextLabel = $PanelContainer/VBoxContainer/StatContainerTop/DamageLabel
@onready var speed_label: RichTextLabel = $PanelContainer/VBoxContainer/StatContainerBottom/SpeedLabel
@onready var attack_speed_label: RichTextLabel = $PanelContainer/VBoxContainer/StatContainerBottom/AttackSpeedLabel
@onready var character_description: Label = $PanelContainer/VBoxContainer/CharacterDescription
@onready var weapon_image: TextureRect = $PanelContainer/VBoxContainer/WeaponContainer/WeaponImage
@onready var weapon_name: Label = $PanelContainer/VBoxContainer/WeaponContainer/VBoxContainer/WeaponName
@onready var weapon_desciption: Label = $PanelContainer/VBoxContainer/WeaponContainer/VBoxContainer/WeaponDesciption
@onready var ability_image: TextureRect = $PanelContainer/VBoxContainer/AbilityContainer/AbilityImage
@onready var ability_name: Label = $PanelContainer/VBoxContainer/AbilityContainer/VBoxContainer/AbilityName
@onready var ability_desciption: Label = $PanelContainer/VBoxContainer/AbilityContainer/VBoxContainer/AbilityDesciption


var health_icon : String = "res://Assets/GUI/health_icon.png"
var damage_icon : String = "res://Assets/GUI/damage_icon.png"
var speed_icon : String = "res://Assets/GUI/speed_icon.png"
var attack_speed_icon : String = "res://Assets/GUI/attack_speed_icon.png"


func display_character(character_info : CharacterInfo) -> void:
	splashart.texture = character_info.characetr_splashart
	characters_name.text = character_info.character_name
	health_label.text = "[img width=25 height=25]%s[/img][color=green]%s[/color]" % [health_icon, str(character_info.base_max_health_value)]
	damage_label.text = "[img width=25 height=25]%s[/img][color=red]%s[/color]" % [damage_icon, str(character_info.base_damage_value)]
	speed_label.text = "[img width=25 height=25]%s[/img][color=blue]%s[/color]" % [speed_icon, str(character_info.base_movement_speed_value)]
	attack_speed_label.text = "[img width=25 height=25]%s[/img][color=yellow]%s[/color]" % [attack_speed_icon, str(character_info.base_attack_speed_value)]
	character_description.text = character_info.character_description
	weapon_image.texture = character_info.weapon_image
	weapon_name.text = character_info.weapon_name
	weapon_desciption.text = character_info.weapon_description
	ability_image.texture = character_info.ability_image
	ability_name.text = character_info.ability_name
	ability_desciption.text = character_info.ability_description
