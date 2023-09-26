shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0, 1.0);
uniform float flipped : hint_range(0.0, 1.0, 1.0);
const float steps = 15.0;


void fragment() {
	float value = 0.3 * texture(TEXTURE, UV).r;
	float flip_term = (1.0 - flipped) * (2.0 * SCREEN_UV.y);
	float offset = 0.7 * floor((flipped - SCREEN_UV.y + flip_term) * steps) / steps;

	
	if (value + offset < cutoff) {
		// rgb: 55, 51, 52
		COLOR = vec4(0.216, 0.2, 0.204, 1);
	} else {
		COLOR = vec4(0, 0, 0, 0);
	}
}