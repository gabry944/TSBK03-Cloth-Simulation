#version 150

in vec3 Position;
in vec2 texCoord;

uniform sampler2D tex;

uniform float height;

out vec4 Out_Color;

void main(void) {
  
  vec2 cord = texCoord;
  vec4 c = texture(tex, cord);
  c.r = 0;
  c.g = height;
  c.b = 0;
  c.a = 0;
  Out_Color = c;
  
  //Out_Color = vec4(value, value, value, 1.0);
}