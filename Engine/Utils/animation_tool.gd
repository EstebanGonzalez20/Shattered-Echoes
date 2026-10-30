@tool
extends EditorScript

# nombre final de la animación -> archivo .glb de origen
const SOURCES := {
	&"idle":    "res://weapons/sword/sword_idle.glb",
	&"attack1": "res://weapons/sword/sword_attack1.glb",
	&"attack2": "res://weapons/sword/sword_attack2.glb",
	&"block":   "res://weapons/sword/sword_block.glb",
}
const OUTPUT := "res://weapons/sword/sword_animations.res"

func _run() -> void:
	var lib := AnimationLibrary.new()

	for anim_name in SOURCES:
		var scene := load(SOURCES[anim_name]) as PackedScene
		var inst := scene.instantiate()
		var player := inst.find_child("AnimationPlayer", true, false) as AnimationPlayer

		# Ignoramos "RESET", que Godot agrega automáticamente
		var original := ""
		for n in player.get_animation_list():
			if n != "RESET":
				original = n
				break

		lib.add_animation(anim_name, player.get_animation(original).duplicate())
		inst.free()   # la malla instanciada ya no hace falta

	var err := ResourceSaver.save(lib, OUTPUT)
	print("Guardado: ", OUTPUT, " (código ", err, ")")
