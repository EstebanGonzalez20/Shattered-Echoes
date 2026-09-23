extends Control

@onready var _panel: Control = $Panel
@onready var _name_label: RichTextLabel = $Panel/VBoxContainer/NameLabel
@onready var _description_label: RichTextLabel = $Panel/VBoxContainer/DescriptionLabel

## Este diccionario mapea cada calidad a un color, usando Global.ItemQuality como llave.
var quality_to_color : Dictionary = {
	Global.ItemQuality.vulgar : Color.GREEN,
	Global.ItemQuality.fine : Color.SKY_BLUE,
	Global.ItemQuality.divine : Color.YELLOW,
	Global.ItemQuality.spiritual : Color.PURPLE,
}

## Cambias el color de fondo para el label del nombre en base a la calidad del item.
func change_name_label_bg_color(quality : Globals.ItemQuality) -> void:
	var style : StyleBoxFlat = _name_label.get_theme_stylebox("normal").duplicate()
	style.bg_color = quality_to_color[quality]
	_name_label.add_theme_stylebox_override("normal", style)

func _ready() -> void:
	_panel.hide()

## Muestra el tooltip con la información del item que se le pase.
func show_for(item: Item) -> void:
	_name_label.text = item.name
	change_name_label_bg_color(item.quality)
	_description_label.text = item.description
	_panel.show()

## Esconde el tooltip.
func hide_tooltip() -> void:
	_panel.hide()

func _process(_delta: float) -> void:
	if _panel.visible:
		_panel.global_position = get_viewport().get_mouse_position() + Vector2(16, 16)
