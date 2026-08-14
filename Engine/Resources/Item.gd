## Clase base para objetos, solo debe usarse como herencia porque no cuenta con la lógica nescesaria para objetos activos o pasivos.
class_name Item extends Resource

## ID que identifica al objeto de otros.
@export var id : StringName

## Calidad del objeto.
@export var quality : Globals.ItemQuality

## Nombre del objeto que se le muestra al jugador.
@export var name : String

## Sprite que se muestra en el juego, más adelante se cambiara por un modelo 3D.
@export var sprite : Texture2D

## Descripción del objeto que se le muestra al jugador.
@export var description : String
