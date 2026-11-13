@tool
extends EditorScript

const SOURCES := {
	&"Idle": "res://Assets/Characters/Knight/knight_weapon_idle.glb",
	&"Primary1": "res://Assets/Characters/Knight/knight_weapon_primary1.glb",
	&"Primary2": "res://Assets/Characters/Knight/knight_weapon_primary2.glb",
	&"Secondary": "res://Assets/Characters/Knight/knight_weapon_secondary.glb",
}
const LOOPS := {&"Idle": Animation.LOOP_LINEAR} # el resto: sin loop
const PATH_FIXES := {"ArmatureEscudoDefensa": "ArmatureEscudo"}
const OUTPUT := "res://Assets/Characters/Knight/knight_animations.res"
const MIN_LENGTH := 0.05

func _run() -> void:
	var result := {}   # nombre final -> Animation

	for anim_name in SOURCES:
		var inst := (load(SOURCES[anim_name]) as PackedScene).instantiate()
		var player := inst.find_child("AnimationPlayer", true, false) as AnimationPlayer

		# 1. Por cada (ruta, tipo de track) nos quedamos con el que más se mueve
		var best := {}
		var length := 0.0
		for n in player.get_animation_list():
			var a := player.get_animation(n)
			if n == "RESET" or a.length < MIN_LENGTH:
				continue   # descarta la basura
			length = maxf(length, a.length)
			for t in a.get_track_count():
				var path := _fix_path(a.track_get_path(t))
				var key := "%s|%d" % [path, a.track_get_type(t)]
				var m := _motion(a, t)
				if not best.has(key) or m > best[key].motion:
					best[key] = {"anim": a, "idx": t, "motion": m, "src": n, "path": path}

		# 2. Construimos la animación final con los tracks elegidos
		var merged := Animation.new()
		merged.length = length
		for key in best:
			var b = best[key]
			b.anim.copy_track(b.idx, merged)
			merged.track_set_path(merged.get_track_count() - 1, b.path)
			print("%s | %s | de %s | movimiento %.3f" % [anim_name, key, b.src, b.motion])
		merged.loop_mode = LOOPS.get(anim_name, Animation.LOOP_NONE)
		result[anim_name] = merged
		inst.free()

	# 3. Completar tracks faltantes con un solo keyframe (pose de reposo)
	for target_name in result:
		var target: Animation = result[target_name]
		for donor_name in result:
			if donor_name == target_name:
				continue
			var donor: Animation = result[donor_name]
			for t in donor.get_track_count():
				var path := donor.track_get_path(t)
				var type := donor.track_get_type(t)
				if target.find_track(path, type) != -1:
					continue
				donor.copy_track(t, target)
				var idx := target.get_track_count() - 1
				for k in range(target.track_get_key_count(idx) - 1, 0, -1):
					target.track_remove_key(idx, k)
				target.track_set_key_time(idx, 0, 0.0)

	var lib := AnimationLibrary.new()
	for n in result:
		lib.add_animation(n, result[n])
	ResourceSaver.save(lib, OUTPUT)
	print("Guardado: ", OUTPUT)

func _fix_path(p: NodePath) -> NodePath:
	var s := str(p)
	for old in PATH_FIXES:
		s = s.replace(old, PATH_FIXES[old])
	return NodePath(s)

# Cuánto cambia el track respecto a su primer keyframe (0 = estático)
func _motion(a: Animation, t: int) -> float:
	var n := a.track_get_key_count(t)
	if n < 2:
		return 0.0
	var first = a.track_get_key_value(t, 0)
	var m := 0.0
	for k in range(1, n):
		var v = a.track_get_key_value(t, k)
		if v is Quaternion:
			m = maxf(m, first.angle_to(v))
		elif v is Vector3:
			m = maxf(m, first.distance_to(v))
	return m
