class_name GlobalVariables extends Resource

## Enum para tipos de acciones del jugador.
enum ACTION_TYPE {
	Basic_attack,
	Special_attack
}

## Diccionario para tipos de acciones del jugador en StringName.
const ACTION_NAME := {
	ACTION_TYPE.Basic_attack: &"basic_attack",
	ACTION_TYPE.Special_attack: &"special_attack"
}
