shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float radius = 0.5;

void fragment() {
    float dist = distance(UV, center);
    if (dist > radius) {
        discard; // ทิ้ง pixel นอกวงกลม
    }
}