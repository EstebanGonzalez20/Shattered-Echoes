shader_type sky;

uniform float star_size : hint_range(0.001, 0.05) = 0.015;
uniform float star_brightness : hint_range(0.5, 5.0) = 2.5;
uniform float twinkle_speed : hint_range(0.0, 5.0) = 4.0;
uniform float star_grid_scale : hint_range(5.0, 100.0) = 18.0;
uniform float time_value : hint_range(0.0, 99999.0) = 0.0;

uniform float nebula_scale : hint_range(0.5, 8.0) = 2.8;
uniform float nebula_intensity : hint_range(0.0, 2.0) = 0.9;
uniform vec4 nebula_color_a : source_color = vec4(0.05, 0.10, 0.40, 1.0);
uniform vec4 nebula_color_b : source_color = vec4(0.01, 0.03, 0.15, 1.0);
uniform vec4 nebula_color_c : source_color = vec4(0.12, 0.06, 0.28, 1.0);
uniform float nebula_z_rotation_speed : hint_range(-1.0, 1.0, 0.001) = 0.02;

// ── Hash ─────────────────────────────────────────────────────────────────
// Estas funciones convierte un vector de n dimenciones en otro de m dimenciones,
// modificando sus valores a unos aparentemente aleatorios.
// Se utilizan para distribuir estrellas y generar ruido sin necesidad de texturas.
// Tienen un nombre como 'hashNM', donde 'n' y 'm' son las dimenciones antes mencionadas.

float hash11(float p) {
	// 'fract' devuelve la parte decimal de un número.
	p = fract(p * 0.1031);
	p *= p + 33.33;
	p *= p + p;
	return fract(p);
}

float hash21(vec2 p) {
	p = fract(p * vec2(0.1031, 0.1030));
	// 'dot' devuelve el producto punto de dos vectores.
	p += dot(p, p.yx + 33.33);
	return fract((p.x + p.y) * p.x);
}

vec3 hash23(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.xxy + p3.yzz) * p3.zyx);
}

float hash31(vec3 p) {
	p = fract(p * vec3(0.1031, 0.1030, 0.0973));
	p += dot(p, p.yzx + 33.33);
	return fract((p.x + p.y) * p.z);
}

vec3 hash33(vec3 p) {
	p = fract(p * vec3(0.1031, 0.1030, 0.0973));
	p += dot(p, p.yxz + 33.33);
	return fract((p.xxy + p.yxx) * p.zyx);
}

// ── Ruido para la nebulosa ──────────────────────────────────────────────────
// Obtiene un valor pseudoaleatorio en cada vértice e interpola suavemente entre ellos.
// Esto es lo que logra producir nubes continuas.

float snoise(vec3 p) {
	vec3 i = floor(p);
	vec3 f = fract(p);
	vec3 u = f * f * (3.0 - 2.0 * f);
	return mix(
		mix(mix(hash31(i+vec3(0,0,0)), hash31(i+vec3(1,0,0)), u.x),
			mix(hash31(i+vec3(0,1,0)), hash31(i+vec3(1,1,0)), u.x), u.y),
		mix(mix(hash31(i+vec3(0,0,1)), hash31(i+vec3(1,0,1)), u.x),
			mix(hash31(i+vec3(0,1,1)), hash31(i+vec3(1,1,1)), u.x), u.y),
		u.z);
}

// FBM (Fractal Brownian Motion).
// Combina varias capas de ruido que:
// - cada capa tiene más detalle.
// - cada capa aporta menos intensidad.
// Genera estructuras parecidas a gas, nebulosas y nubes.

float fbm(vec3 p, int octaves) {
	// 'val' es el resultado final.
	float val = 0.0;
	// 'amp' es cuanto aporta cada capa.
	float amp = 0.5;
	// 'freq' mientras más grande es, genera estructuras más pequeñas.
	float freq = 1.0;
	// 'octaves' son el total de capas de ruido a sumar.
	for (int i = 0; i < octaves; i++) {
		val += snoise(p * freq) * amp;
		freq *= 2.1;
		amp *= 0.48;
	}
	return val;
}

// Genera una capa completa de estrellas.
// Convierte una dirección 3D en coordenadas esféricas.
// Divide el cielo en celdas y coloca estrellas en posiciones pseudoaleatorias.
// Cada estrella obtiene:
// - posición.
// - tamaño.
// - brillo.
// - fase de titilado.
// Todo se calcula proceduralmente.

float star_layer(vec3 dir, float grid, float size_mult, float t) {
	// Coordenadas esféricas.
	// Ángulo horizontal de -PI a PI  (azimuth).
	float az = atan(dir.x, dir.z);
	// Ángulo vertical de -PI/2 a PI/2 (elevación).
	// 'clamp' devuelve un valor entre el argumento 2 y 3
	// dependiendo si el argumento uno es mayor o menor a los otros dos.
	float el = asin(clamp(dir.y, -1.0, 1.0));
	
	// Correción de densidad con 'cos(el)', ya que en los polos las celdas se juntan.
	float cos_el = max(cos(el), 0.001);
	// Transforma la esfera en un plano 2D, dando la posición con los ángulos.
	vec2 uv = vec2(
		(az / (2.0 * 3.14159265)) * grid * cos_el,
		(el / 3.14159265) * grid
	);
	
	// 'brightness' es el brillo acumulado de todas las estrellas.
	float brightness = 0.0;
	
	// Revisamos celdas de 2x2 para suavizar bordes.
	for (int cx = 0; cx <= 1; cx++) {
		for (int cy = 0; cy <= 1; cy++) {
			// 'cell' es la celda en la que estamos actualmente.
			vec2 cell = floor(uv) + vec2(float(cx), float(cy));
			// 'local' es la posición porcentual dentro de la celda.
			vec2 local = fract(uv) - vec2(float(cx), float(cy));
			
			// Semilla única y estable por celda.
			vec3 rnd = hash23(cell + vec2(grid * 0.37, grid * 0.91));
			
			// Solo el 60% de las celdas tienen estrella (rnd.z >= 0.4).
			if (rnd.z < 0.4) continue;
			
			// Posición porcentual aleatoria dentro de la celda.
			vec2 star_pos = rnd.xy;
			// Distancia entre el píxel que miro y la estrella.
			vec2 diff = local - star_pos;
			float dist = length(diff);
			
			// Genera tamaño de estrella pseudoaleatorio.
			float sz = size_mult * mix(0.3, 1.0, rnd.z);
			
			// Titilado: fase y velocidad únicas por estrella
			float phase = rnd.x * 6.28318;
			float speed = mix(0.4, 2.0, rnd.y) * twinkle_speed;
			float twinkle = 0.5 + 0.5 * sin(t * speed + phase);
			
			float b = smoothstep(sz, sz * 0.1, dist) * twinkle * mix(0.5, 1.0, rnd.z);
			brightness += b;
		}
	}
	return brightness;
}

float star_field(vec3 dir, float t) {
	// Dos capas con grillas distintas para más densidad y variedad
	float s1 = star_layer(dir, star_grid_scale, star_size, t);
	float s2 = star_layer(dir, star_grid_scale * 1.73, star_size * 0.65, t);
	return s1 + s2 * 0.6;
}

// ── Main ─────────────────────────────────────────────────────────────────
void sky() {
	// 'EYEDIR' es un vector normalizado que indica a que pixel del cielo miro.
	vec3 dir = EYEDIR;
	
	// ── 1. Fondo base ──────────────────────────────────────────────────
	vec3 color = vec3(0.0, 0.001, 0.012);
	
	// ── 2. Nebulosa / Vía Láctea ───────────────────────────────────────
	// Genera ángulo de rotación en base al tiempo
	float nebula_angle = time_value * nebula_z_rotation_speed;
	
	float c = cos(nebula_angle);
	float s = sin(nebula_angle);
	
	// Se rota 'dir' para dar la ilusión de que la nébula gira.
	vec3 ndir = vec3(
		dir.x * c - dir.z * s,
		dir.y,
		dir.x * s + dir.z * c
	);
	
	// Cada llamada produce una nube distinta:
	// - n1: estructura principal.
	// - n2: detalle fino.
	// - n3: formas grandes y suaves.
	// La combinación de las tres genera una nebulosa más orgánica.
	float n1 = fbm(ndir * nebula_scale, 5);
	float n2 = fbm(ndir * nebula_scale * 2.3 + 3.7, 4);
	float n3 = fbm(ndir * nebula_scale * 0.7 + 1.1, 3);
	
	// Queremos concentrar la nebulosa alrededor del "ecuador" celeste.
	// Cuando 'ndir.y' sea cercano a 0, será el centro de la galaxia.
	// Cuando 'ndir.y' sea cercano a 1 o -1, será alguno de los polos celestes.
	// La potencia 2 estrecha la banda para darle una apariencia a la Vía Láctea.
	float band = 1.0 - abs(ndir.y);
	band = pow(max(band, 0.0), 2);
	
	// Crea una máscara de visibilidad de la nebulosa que combina:
	// - estructura principal (n1).
	// - detalle (n2).
	// - banda galáctica.
	// El resultado determina dónde existe la nebulosa.
	float nebula_mask = n1 * n2 * band * 3.0;
	nebula_mask = clamp(nebula_mask, 0.0, 1.0);
	
	// Color base de la nebulosa.
	// Se mezclan varios colores usando los valores del ruido.
	// Esto evita que la nébula tenga un color plano, generando variaciones naturales.
	vec3 neb = mix(nebula_color_b.rgb, nebula_color_a.rgb, n1);
	neb = mix(neb, nebula_color_c.rgb, n2 * n3);
	
	// Algunas regiones reciben brillo adicional para simular:
	// - concentración de polvo.
	// - cúmulos estelares.
	// - regiones densas de gas.
	// La potencia 1.8 hace que sólo las zonas más densas brillen.
	float bright_clouds = pow(n1 * n2, 1.8) * band * 4.0;
	bright_clouds = clamp(bright_clouds, 0.0, 1.0);
	neb += vec3(0.04, 0.07, 0.18) * bright_clouds;
	
	// 'nebula_intensity' es un multiplicador global de intensidad visual.
	color += neb * nebula_mask * nebula_intensity;
	
	// ── 3. Estrellas ───────────────────────────────────────────────────
	// Genera el campo de estrellas.
	float stars = star_field(dir, time_value);
	
	// Ajuste porceptual del brillo.
	// La potencia 1.3 aumenta el contraste:
	// - estrellas débiles son más débiles.
	// - estrellas fuertes son más fuertes.
	stars = pow(max(stars, 0.0), 1.3) * star_brightness;
	
	// Variación de color de las estrellas.
	// Algunas se desplazan hacia tonos azulados o amarillentos.
	// El hash genera una semilla estable para cada región del cielo.
	float tint = hash11(hash31(floor(dir * 80.0)));
	vec3 star_color = mix(vec3(0.80, 0.90, 1.00), vec3(1.00, 0.97, 0.85), tint);
	
	// Las estrellas se vuelven ligeramente más visibles
	// cuando aparecen sobre regiones de nebulosa,
	// simulando dispersión de luz y contraste astronómico.
	color += star_color * stars * (1.0 + nebula_mask * 0.5);
	
	// Color final enviado al renderer del sky shader.
	COLOR = color;
}
