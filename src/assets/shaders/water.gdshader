shader_type spatial;
render_mode cull_back, diffuse_burley;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_nearest_mipmap;
uniform sampler2D water_texture;
uniform sampler2D noise_texture;
uniform float water_texture_raise : hint_range(0.0, 1.0) = 0.0;
uniform vec2 water_uv = vec2(10.0, 10.0);
uniform vec4 water_albedo : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float water_speed_multi = 0.05;
uniform float amount : hint_range(0.2, 1.5) = 0.7;
uniform float height_offset = 0.0;

uniform bool transperancy = false;
uniform float beer_factor = 0.2;

varying float vertex_height;

float generateOffset(float x, float z, float val1, float val2, float time, vec2 uv){
	float speed = 1.0;
	
	float radiansX = ((mod(x + z * x * val1, amount) / amount) + (time * speed) * mod(x * 0.8 + z, 1.5)) * 2.0 * 3.14;
	float radiansZ = ((mod(val2 * (z * x + x * z), amount) / amount) + (time * speed) * 2.0 * mod(x,2.0)) * 2.0 * 3.14;

	//float noise_affect = texture(noise_texture, uv + vec2(TIME * water_speed_multi, TIME * water_speed_multi)).x;
	return amount * 0.5 * (sin(radiansZ) + cos(radiansX));
	//return noise_affect;
}


vec3 applyDistortion(vec3 vertex, float time, vec2 uv){
	float xd = generateOffset(vertex.x, vertex.z, 0.2, 0.1, time, uv);
	float yd = generateOffset(vertex.x, vertex.z, 0.2, 0.1, time, uv);
	float zd = generateOffset(vertex.x, vertex.z, 0.2, 0.1, time, uv);
	return vertex + vec3(xd, yd, zd);
}

void vertex() {
	VERTEX = applyDistortion(VERTEX, TIME * 0.1, UV);
	VERTEX.y += height_offset;
	
	vertex_height = VERTEX.y;
}

void fragment() {
	
	//NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX) ) );
	//NORMAL = normalize(mix(dFdx(VERTEX), dFdy(VERTEX), vec3(0.5, 1.0, 1.0)));
	//ALBEDO = out_color.xyz * 2.0;
	METALLIC = 0.0;
	SPECULAR = 0.0;
	ROUGHNESS = 1.0;
	
	float height_white_augment = vertex_height * 0.8;
	
	vec4 texture_color = texture(water_texture, UV * vec2(water_uv.x, water_uv.y) + vec2(TIME * water_speed_multi, TIME * water_speed_multi)) + vec4(water_texture_raise, water_texture_raise, water_texture_raise, 1.0) + vec4(height_white_augment, height_white_augment, height_white_augment, 1.0); 
	ALBEDO = texture_color.xyz * 1.0;
	
	//if (transperancy == true){
		//float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
		//
		//depth = depth * 2.0 - 1.0;
		//depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
		//depth += VERTEX.z;
	//
		//depth = exp(depth * beer_factor);
		//ALPHA = clamp(1.0 - depth, 0.0, 1.0);
	//}
}



