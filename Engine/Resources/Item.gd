## Clase base para objetos, solo debe usarse como herencia porque no cuenta con la lógica nescesaria para objetos activos o pasivos.
class_name Item extends Resource

## ID que identifica al objeto de otros.
@export var id : StringName

## Calidad del objeto.
@export var quality : Globals.ItemQuality

## Nombre del objeto que se le muestra al jugador.
@export var name : String

## Descripción del objeto que se le muestra al jugador.
@export var description : String

## Icono que representa al item en los menus.
@export var icon: Texture2D

## Usar mientras el ítem se representa como sprite (Sprite3D)
@export var pickup_texture: Texture2D

## Usar cuando el ítem tenga un modelo 3D completo (reemplaza a pickup_texture si está presente)
@export var pickup_model: PackedScene
