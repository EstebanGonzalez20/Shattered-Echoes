## Esta clase almacena la información de los personajes que se muestra en los menús
class_name CharacterInfo extends Resource

## Ruta del character_data del personaje.
@export var character_data_path : String

## Esta variable almacena el nombre del personaje
@export var character_name : StringName

## Esta variable almacena el valor base de vida máxima del personaje.
@export var base_max_health_value: int

## Esta variable almacena el valor base de daño del personaje.
@export var base_damage_value: int

## Esta variable almacena el valor base de velocidad de ataque del personaje.
@export var base_attack_speed_value: float

## Esta variable almacena el valor base de velocidad de movimiento del personaje.
@export var base_movement_speed_value: int

## Esta variable almacena el slpashart del personaje.
@export var characetr_splashart: Texture2D

## Esta variable almacena la descripción del personaje.
@export var character_description: String

## Esta variable almacena el nombre del arma del personaje.
@export var weapon_name: String

## Esta variable almacena la descripción del arma del personaje.
@export var weapon_description: String

## imagen del arma.
@export var weapon_image: Texture2D

## Esta variable almacena el nombre del arma del personaje.
@export var ability_name: String

## Esta variable almacena la descripción del arma del personaje.
@export var ability_description: String

## imagen del arma.
@export var ability_image: Texture2D
