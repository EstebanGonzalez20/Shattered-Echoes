## Clase con los datos del personaje.
class_name CharacterData extends Resource

## Nombre del personaje.
@export var characters_name : StringName

## Lista de componentes con los que empieza el personaje.
@export var initial_components : Array[Component]

## Modelo del arma.
@export var viewmodel_scene : PackedScene

## Libreria con las animaciones del arma.
@export var animation_library : AnimationLibrary
