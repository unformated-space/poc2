shader_type spatial;

render_mode wireframe;

void fragment() {
    ALBEDO = vec3(1.0, 0.0, 0.0); // Color rojo para el wireframe
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
