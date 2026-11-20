class_name Player extends CharacterBody3D

@onready var entity_component: EntityComponent = $EntityComponent
@onready var hud: CanvasLayer = $"../Hud"
@onready var camera: Camera3D = $Head/Camera3D
@onready var pivot: Node3D = $Head/Camera3D/ViewmodelPivot

signal player_died

## Datos del personaje del jugador.
var character_data : CharacterData
var viewmodel: Node3D
var weapon_anim: AnimationPlayer

# Cosas del arma.
## segundos tras terminar el ataque para encadenar
const COMBO_WINDOW := 0.6
## fracción de la animación tras la cual se permite encadenar
const CANCEL_POINT := 0.5
## transición suave entre animaciones
const BLEND_TIME := 0.1   

var combo_index := 0
var last_attack_end := -INF
var is_attacking := false
var can_chain := false
var attack_queued := false

## Hace todas las preparaciones y lógicas de arranque que no puedan hacerse en _ready()
func initialize() -> void:
	_setup_viewmodel()
	for component in character_data.initial_components:
		entity_component.add_component(component)
	
	## Realiza todas las conexiones para la vida.
	var player_health : Health = entity_component.get_component("Health")
	player_health.damage_taken.connect(_on_damage_taken)
	player_health.health_restore.connect(_on_health_restore)
	player_health.die.connect(_on_die)
	
	## Realiza todas las conexiones para la estamina.
	if entity_component.has_component("Stamina"):
		var player_stamina : Stamina = entity_component.get_component("Stamina")
		player_stamina.stamina_changed.connect(_on_stamina_changed)
	
	## Realiza todas las conexiones para el input.
	if entity_component.has_component("Input"):
		var player_input : PlayerInput = entity_component.get_component("Input")
		player_input.player_action.connect(_on_action_done)

func _setup_viewmodel() -> void:
	if viewmodel:
		viewmodel.queue_free()

	viewmodel = character_data.viewmodel_scene.instantiate()
	pivot.add_child(viewmodel)   # antes: camera.add_child(viewmodel)
	weapon_anim = viewmodel.find_child("AnimationPlayer", true, false)
	weapon_anim.add_animation_library("weapon", character_data.animation_library)
	weapon_anim.animation_finished.connect(_on_anim_finished)
	weapon_anim.play("weapon/Idle")

func _on_damage_taken(amount) -> void:
	var player_health : Health = entity_component.get_component("Health")
	hud.healthBar.set_health(player_health.current_health)

func _on_health_restore(amount) -> void:
	var player_health : Health = entity_component.get_component("Health")
	hud.healthBar.set_health(player_health.current_health)

func _on_stamina_changed(new_value, old_value) -> void:
	hud.update_stamina(entity_component.get_component("Stamina").current_stamina)

func _on_action_done(action_name) -> void:
	match action_name:
		&"basic_attack", &"special_attack":
			try_attack()

func _start_attack() -> void:
	entity_component.get_component("Stamina").expend_stamina(30)
	var now := Time.get_ticks_msec() / 1000.0
	if not is_attacking and now - last_attack_end > COMBO_WINDOW:
		combo_index = 0   # pausa larga: reinicia el combo
	var anim_name := "weapon/Primary1" if combo_index == 0 else "weapon/Primary2"
	combo_index = 1 - combo_index
	is_attacking = true
	can_chain = false
	attack_queued = false
	weapon_anim.play(anim_name, BLEND_TIME)

func try_attack() -> void:
	if is_attacking and not can_chain:
		attack_queued = true    # buffer: se ejecutará al llegar al punto de cancelación
		return
	_start_attack()

func _on_anim_finished(anim_name: StringName) -> void:
	if not str(anim_name).begins_with("weapon/Ataque"):
		return
	is_attacking = false
	can_chain = false
	attack_queued = false
	last_attack_end = Time.get_ticks_msec() / 1000.0
	weapon_anim.play("weapon/Idle", BLEND_TIME)

func _on_die() -> void:
	player_died.emit()

func _process(_delta: float) -> void:
	if not is_attacking or can_chain:
		return
	var length := weapon_anim.current_animation_length
	if length > 0.0 and weapon_anim.current_animation_position >= length * CANCEL_POINT:
		can_chain = true
		if attack_queued:
			_start_attack()
