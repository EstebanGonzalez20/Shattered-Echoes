shader_type spatial;

uniform sampler2D albedo_texture : source_color;

global uniform sampler2D color_lights_tex;
global uniform int color_light_count;

void fragment() {
	vec4 color = texture(albedo_texture, UV);
	vec3 grey = vec3(dot(color.rgb, vec3(0.299, 0.587, 0.114)));

	vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float color_influence = 0.0;
	
	for (int i = 0; i < color_light_count; i++) {
		vec4 light_data = texelFetch(color_lights_tex, ivec2(i, 0), 0);
		vec3 light_pos = light_data.rgb;
		float radius = light_data.a;

		float dist = distance(world_pos, light_pos);
		float influence = 1.0 - smoothstep(radius * 0.4, radius * 0.8, dist);
		color_influence = max(color_influence, influence);
	}

	ALBEDO = mix(grey, color.rgb, color_influence);
}