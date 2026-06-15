shader_type spatial;

// Textura base del objeto.
// Contiene colores originales para recuperarlos cuando una 'Color Light' lo ilumine.
uniform sampler2D albedo_texture : source_color;

// Textura global utilizada como buffer de datos.
// Cada pixel almacena información de una 'Color Light':
// - RGB = posición mundial.
// - A = radio de influencia.
global uniform sampler2D color_lights_tex;
global uniform int color_light_count;

// ── Main ─────────────────────────────────────────────────────────────────
void fragment() {
	// Obtiene color original del material utilizando las coordenadas UV del fragmento actual.
	// UV determina qué parte de la textura corresponde a este punto del modelo.
	vec4 color = texture(albedo_texture, UV);
	
	// Convierte el color original a escala de grises.
	// El producto escalar aplica la fórmula clásica de luminancia perceptual:
	// - El rojo es el 29.9%.
	// - El verde es el 58.7%.
	// - El azul es el 11.4%.
	// Esto refleja la sensibilidad real del ojo humano.
	vec3 grey = vec3(dot(color.rgb, vec3(0.299, 0.587, 0.114)));
	
	// Reconstruye la posición mundial del fragmento.
	// VERTEX es la posición del fragmento actual expresada en espacio de vista.
	// INV_VIEW_MATRIX puede transformar espacio de vista amundo.
	vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// Intensidad máxima de color detectada.
	// De 0 a 1 se determina si es completamente gris o coloreado.
	float color_influence = 0.0;
	
	for (int i = 0; i < color_light_count; i++) {
		// Lee el pixel que almacena información de la 'Color Light' actual.
		vec4 light_data = texelFetch(color_lights_tex, ivec2(i, 0), 0);
		vec3 light_pos = light_data.rgb;
		float radius = light_data.a;
		
		// Distancia entre el fragmento y 'Color Light' actuales.
		float dist = distance(world_pos, light_pos);
		
		// Calcula cuánto afecta la 'Color Light' actual al fragmento actual.
		// De 0 a 1 se determina si está cerca del borde o del centro.
		// 'smoothstep' devuelve entre 0 y 1 dependiendo de
		// si su tercer argumento es más grande o chico que los otros dos.
		float influence = 1.0 - smoothstep(radius * 0.4, radius * 0.8, dist);
		
		// Conservamos la influencia más fuerte encontrada.
		// Si varias luces afectan al mismo fragmento, se utiliza la de mayor intensidad.
		color_influence = max(color_influence, influence);
	}
	// 'ALBEDO' es el color base del material del fragmento actual.
	// Esta linea determina cuánto color recupera el objeto.
	// 'mix' devuelve un valor entre el primer y segundo argumento,
	// utilizando al tercero (valor entre 0 y 1) como porcentaje.
	ALBEDO = mix(grey, color.rgb, color_influence);
}