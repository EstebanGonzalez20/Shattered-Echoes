@tool
extends EditorScript

const FILES := [
	"res://Assets/Characters/Knight/EspadaCaballera_AtaqueBasico1.blend11.glb",
	"res://Assets/Characters/Knight/EspadaCaballera_AtaqueBasico2.blend11.glb",
	"res://Assets/Characters/Knight/EspadaEscudoIdle.blend11 - copia.glb",
	"res://Assets/Characters/Knight/EspadaEscudoSecundario.blend11 - copia (2).glb"
]

func _run() -> void:
	for path in FILES:
		var inst := (load(path) as PackedScene).instantiate()
		var player := inst.find_child("AnimationPlayer", true, false) as AnimationPlayer
		print("== ", path)
		for n in player.get_animation_list():
			var a := player.get_animation(n)
			print("  ", n, " | ", snappedf(a.length, 0.001), "s | tracks: ", a.get_track_count())
			for t in a.get_track_count():
				print("       ", a.track_get_path(t))
		inst.free()
