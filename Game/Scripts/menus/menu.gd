extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	# la camara empieza en z:7 debería moverse hacia z:33 aprox
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()
