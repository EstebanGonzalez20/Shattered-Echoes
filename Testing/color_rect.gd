extends CanvasLayer

@export var subviewport: SubViewport
@onready var mat = $ColorRect.material

func _ready():
	var vp_texture = subviewport.get_texture()
	mat.set_shader_parameter("mask_texture", vp_texture)
