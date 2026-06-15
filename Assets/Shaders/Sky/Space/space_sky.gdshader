shader_type sky;

uniform float star_size       : hint_range(0.001, 0.05)  = 0.015;
uniform float star_brightness : hint_range(0.5, 5.0)     = 2.5;
uniform float twinkle_speed   : hint_range(0.0, 5.0)     = 1.2;
uniform float twinkle_amount  : hint_range(0.0, 1.0)     = 0.5;
uniform float star_grid_scale : hint_range(5.0, 40.0)    = 18.0;
uniform float time_value      : hint_range(0.0, 99999.0) = 0.0;

uniform float nebula_scale    : hint_range(0.5, 8.0)     = 2.8;
uniform float nebula_intensity: hint_range(0.0, 2.0)     = 0.9;
uniform vec4  nebula_color_a  : source_color = vec4(0.05, 0.10, 0.40, 1.0);
uniform vec4  nebula_color_b  : source_color = vec4(0.01, 0.03, 0.15, 1.0);
uniform vec4  nebula_color_c  : source_color = vec4(0.12, 0.06, 0.28, 1.0);
uniform float nebula_band_tilt: hint_range(-1.0, 1.0)    = 0.35;

// ── Hash ─────────────────────────────────────────────────────────────────
float hash11(float p) {
    p = fract(p * 0.1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

float hash21(vec2 p) {
    p = fract(p * vec2(0.1031, 0.1030));
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

// ── Noise para nebulosa ──────────────────────────────────────────────────
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

float fbm(vec3 p, int octaves) {
    float val = 0.0;
    float amp = 0.5;
    float freq = 1.0;
    for (int i = 0; i < octaves; i++) {
        val  += snoise(p * freq) * amp;
        freq *= 2.1;
        amp  *= 0.48;
    }
    return val;
}

float star_layer(vec3 dir, float grid, float size_mult, float t) {
    // Coordenadas esféricas
    float az  = atan(dir.x, dir.z);           // -PI .. PI  (azimuth)
    float el  = asin(clamp(dir.y, -1.0, 1.0)); // -PI/2 .. PI/2 (elevación)

    // Normalizamos a [0, grid] para crear celdas
    // Correción de densidad por cos(el): en los polos las celdas se juntan
    float cos_el = max(cos(el), 0.001);
    vec2 uv = vec2(
        (az  / (2.0 * 3.14159265)) * grid * cos_el,
        (el  / 3.14159265        ) * grid
    );

    float brightness = 0.0;

    // Revisamos 2x2 celdas vecinas para suavizar bordes
    for (int cx = 0; cx <= 1; cx++) {
        for (int cy = 0; cy <= 1; cy++) {
            vec2 cell   = floor(uv) + vec2(float(cx), float(cy));
            vec2 local  = fract(uv) - vec2(float(cx), float(cy));

            // Semilla única y estable por celda
            vec3 rnd = hash23(cell + vec2(grid * 0.37, grid * 0.91));

            // Solo el 60% de las celdas tienen estrella (rnd.z > 0.4)
            if (rnd.z < 0.4) continue;

            // Posición aleatoria dentro de la celda
            vec2 star_pos = rnd.xy;
            vec2 diff = local - star_pos;
            float dist = length(diff);

            float sz = size_mult * mix(0.3, 1.0, rnd.z);

            // Titilado: fase y velocidad únicas por estrella
            float phase = rnd.x * 6.28318;
            float speed = mix(0.4, 2.0, rnd.y) * twinkle_speed;
            float twinkle = 1.0 - twinkle_amount
                          + twinkle_amount * (0.5 + 0.5 * sin(t * speed + phase));

            float b = smoothstep(sz, sz * 0.1, dist) * twinkle * mix(0.5, 1.0, rnd.z);
            brightness += b;
        }
    }
    return brightness;
}

float star_field(vec3 dir, float t) {
    // Dos capas con grillas distintas para más densidad y variedad
    float s1 = star_layer(dir, star_grid_scale,        star_size,        t);
    float s2 = star_layer(dir, star_grid_scale * 1.73, star_size * 0.65, t);
    return s1 + s2 * 0.6;
}

// ── Main ─────────────────────────────────────────────────────────────────
void sky() {
    vec3 dir = EYEDIR;

    // 1. Fondo base
    vec3 color = vec3(0.0, 0.001, 0.012);

    // 2. Nebulosa
    vec3 ndir = normalize(dir + vec3(nebula_band_tilt * dir.x, 0.0, 0.0));
    float n1 = fbm(ndir * nebula_scale,               5);
    float n2 = fbm(ndir * nebula_scale * 2.3 + 3.7,  4);
    float n3 = fbm(ndir * nebula_scale * 0.7 + 1.1,  3);

    float band = pow(clamp(1.0 - abs(ndir.y), 0.0, 1.0), 2.2);
    float nebula_mask = clamp(n1 * n2 * band * 3.5, 0.0, 1.0);

    vec3 neb = mix(nebula_color_b.rgb, nebula_color_a.rgb, n1);
    neb      = mix(neb, nebula_color_c.rgb, n2 * n3);
    float bright_clouds = clamp(pow(n1 * n2, 1.8) * band * 4.0, 0.0, 1.0);
    neb += vec3(0.04, 0.08, 0.22) * bright_clouds;
    color += neb * nebula_mask * nebula_intensity;

    // 3. Estrellas
    float stars = star_field(dir, time_value);
    stars = pow(max(stars, 0.0), 1.3) * star_brightness;

    float tint = hash11(hash31(floor(dir * 80.0)));
    vec3  star_color = mix(vec3(0.80, 0.90, 1.00), vec3(1.00, 0.97, 0.85), tint);
    color += star_color * stars * (1.0 + nebula_mask * 0.5);

    COLOR = color;
}