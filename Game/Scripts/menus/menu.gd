extends Control

const CHARACTER_SELECT = preload("res://Game/scenes/ui/menus/character_select.tscn")

# Elementos del menú
@onready var title: Label = $Title
@onready var buttons: VBoxContainer = $ButtonContainer

# Duración de la animación de la cámara en segundos
const CAMERA_ANIM_DURATION := 9.5
# Posición Z inicial y final de la cámara
const CAMERA_START_Z := 7.0
const CAMERA_END_Z := 41.0

var tween: Tween = null

func _ready() -> void:
	title.modulate.a = 0
	buttons.modulate.a = 0

	var tween = create_tween()

	tween.parallel().tween_property(
		title,
		"modulate:a",
		1.0,
		4.5
	)

	tween.parallel().tween_property(
		buttons,
		"modulate:a",
		1.0,
		4.5
	)

func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	# 1. Instanciar la sala de personajes y agregarla a la escena
	var char_select = CHARACTER_SELECT.instantiate()
	# La agregamos al padre (Node3D raíz), no a este Control,
	# para que viva en el espacio 3D y no sea un hijo del UI.
	get_parent().add_child(char_select)

	# 2. Posicionar la sala detrás de la cámara (en Z mayor, ya que la cámara mira hacia -Z)
	# La sala aparece en la posición destino, donde va a llegar la cámara.
	char_select.position = Vector3(0, 0, CAMERA_START_Z)

	# 3. Ocultar el UI del menú principal inmediatamente
	# Usamos visible = false en vez de queue_free() porque la cámara
	# todavía está animándose y no queremos destruir el nodo padre todavía.
	var fade = create_tween()
	fade.parallel().tween_property(
		title,
		"modulate:a",
		0,
		1
)

	fade.parallel().tween_property(
		buttons,
		"modulate:a",
		0,
		1
	)
	
	await fade.finished
	visible = false

	# 4. Obtener la cámara desde el árbol de la escena
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera == null:
		push_error("No se encontró una Camera3D activa en la escena.")
		return

	# 5. Crear el Tween para animar la cámara suavemente
	# Si ya había un tween corriendo (doble clic rápido), lo matamos primero.
	if tween:
		tween.kill()

	tween = create_tween()
	# Usamos ease_in_out para que la cámara arranque suave, acelere y frene suave al llegar.
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)

	# Animamos solo la Z de la posición de la cámara hacia CAMERA_END_Z
	tween.tween_property(
		camera,
		"position:z",
		CAMERA_END_Z,
		CAMERA_ANIM_DURATION
	)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
