shader_type canvas_item;

// EXPLANATION:
// We don't want to scale the root EyeWhite to make it blink, as this will
// scale all its children, but we do need to scale it to do the blinking.
//
// So, just do that inside this shader.

uniform float scale = 1.0;

void fragment() {
	vec2 uv = UV;
	uv.y = (uv.y - 0.5) / scale + 0.5;
	COLOR = texture(TEXTURE, uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
