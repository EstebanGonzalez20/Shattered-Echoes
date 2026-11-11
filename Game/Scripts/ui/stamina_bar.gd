extends ProgressBar

var stamina : int = 0

func initialize(stamina_component : Stamina):
	max_value = stamina_component.max_stamina
	stamina = max_value
	value = max_value

func set_stamina(new_value):
	stamina = clamp(new_value, 0, max_value)
	value = stamina
