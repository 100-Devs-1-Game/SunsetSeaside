shader_type spatial;

uniform vec3 top_color : source_color;

uniform sampler2D screen_tex: hint_screen_texture;
uniform sampler2D depth_tex: hint_depth_texture;
uniform float depth_distance : hint_range(0.0, 50.0, 0.1) = 0.5;

void fragment() {
	
	
	
	float depth_r = textureLod(depth_tex, SCREEN_UV, 0.0).r;
	vec4 world = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, depth_r, 1.0);
	world.xyz /= world.w;
	float depth_blend = smoothstep(world.z + depth_distance, world.z, VERTEX.z);
	
	vec3 screen = textureLod(screen_tex, SCREEN_UV, 0.0).rgb;
	
	ALBEDO = screen * depth_blend;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
