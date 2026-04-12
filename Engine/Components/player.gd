extends CharacterBody3D

const SPEED: float = 10.0
const MOUSE_SENNS: float = 2.0
const JUMP_VELOCITY = 4.5


#Movimiento del mouse
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#evento de lo que pasa al mover el mouse
func _input(event) -> void:
	if event is InputEventMouseMotion:
		#este sirve para mover la camara en el eje x
		rotation_degrees.y -= event.relative.x * MOUSE_SENNS
		#este sirve para mover la camara en el eje y
		rotation_degrees.x -= event.relative.y * MOUSE_SENNS

#gravedad
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

#Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

#movimiento del personaje
#obitene los vectores que va a usar para moverse (si o si 4)
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#indica que se mueve en el eje x e y
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#si obtiene la variable direccion entonces se mueve en los ejes Z y X osea horizontal y profundidad
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	#mueve al personaje en base a la colision de otra cosa y desliza sobre esa colision
	move_and_slide()
