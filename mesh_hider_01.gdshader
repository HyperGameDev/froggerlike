shader_type spatial;

render_mode unshaded;

uniform sampler2D tex : source_color;  // Texture, used as color

uniform vec2 rect_size = vec2(0.6, 0.6); // Size of the rectangle
uniform vec2 feather = vec2(0.0, 0.0); // Feathering of the rectangle's edge

uniform vec2 center = vec2(0.33333, 0.5); // Center (Adjust to move the rectangle around)

float rectangle_mask(vec2 _uv, vec2 _center, vec2 _size, vec2 _feather) {
    vec2 p = abs(_uv - _center); // Distance from current pixel to the center
    vec2 edge = _size * 0.5;
    vec2 sm = smoothstep(edge, edge - _feather, p);
    return sm.x * sm.y; // Smooth transition
}

void fragment() {
    ALPHA = rectangle_mask(UV, center, rect_size, feather); // Use mask for transparency
    ALBEDO = texture(tex, UV).rgb; // Set the albedo to the texture color
}
