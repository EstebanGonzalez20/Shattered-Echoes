## Clase base para objetos pasivos, solo debe usarse como herencia porque no cuenta con la lógica de los hooks, de eso se encarga cada objeto.
class_name PassiveItem extends Item

## Eventos a los que el objeto está subscrito, cuando estos eventos ocurran el objeto será llamado y aplicara sus efectos correspondientes al evento.
@export var hooks : Array[Globals.EventHooks]

func on_stack_changed(owner : EntityComponent, newStack : int):
	pass
