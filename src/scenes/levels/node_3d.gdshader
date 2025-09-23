shader_type spatial;

void fragment() {
	ALBEDO += vec3(sin(UV.x * UV.y * 50.0 * TIME) * 5.0, 0.0,0.0); 

}
