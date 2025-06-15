shader_type spatial;

render_mode cull_front, unshaded;

uniform vec4 outline_color : source_color;
uniform float outline_thickness = 0.01;

void vertex() {
	VERTEX += NORMAL * outline_thickness;
}

void fragment() {
	ALBEDO = outline_color.rgb;
}
