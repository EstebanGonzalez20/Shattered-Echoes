class_name Inventory extends NodeComponent

func get_type() -> StringName:
	return &"Inventory"

## Diccionario que almacena los objetos pasivos, utiliza las id de los objetos como llave y almacena la cantidad de copias que hay de ese objeto.
var passive_items: Dictionary[StringName, Dictionary] = {}  # StringName -> {resource: Item, count: int}

## Diccionario que relaciona los objetos almacenados a sus respectivos hooks
var subscribed_hooks : Dictionary[Globals.EventHooks, Array] = {}

## Hace referencia a la entidad dueña del inventario.
@onready var entity : EntityComponent = get_parent()

## Añade los hooks del objeto al diccionario para que el inventario los registre.
func add_item_hooks(item : PassiveItem) -> void:
	for hook in item.hooks:
		if hook != Globals.EventHooks.OnStack:
			if hook in subscribed_hooks.keys():
				subscribed_hooks[hook].append(item.id)
		
		else:
			subscribed_hooks[hook] = [item.id]

## Añade el objeto pasivo al inventario.
func add_passive_item(item: PassiveItem, amount: int = 1) -> void:
	if passive_items.has(item.id):
		passive_items[item.id].count += amount

	else:
		passive_items[item.id] = {"resource": item, "count": amount}
		add_item_hooks(item)

	if item.hooks.has(Globals.EventHooks.OnStack):
		item.on_stack_changed(entity, passive_items[item.id]["count"])
