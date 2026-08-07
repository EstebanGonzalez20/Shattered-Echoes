class_name PassiveItem extends Resource

## ID que identifica al objeto de otros.
@export var id : StringName

## Calidad del objeto.
@export var quality : Globals.ItemQuality

## Nombre del objeto que se le muestra al jugador.
@export var name : String

## Descripción del objeto que se le muestra al jugador.
@export var description : String

@export var hooks : Array[Globals.EventHooks]
