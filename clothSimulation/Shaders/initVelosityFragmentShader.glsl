#version 150

in vec3 Position;
in vec2 texCoord;

uniform sampler2D tex;

uniform float height;
uniform float width;

out vec4 Out_Color;

void main(void) {
  
  vec2 cord = texCoord;
  vec4 c = texture(tex, cord);
  c.r = height;
  c.g = texCoord[0];
  c.b = texCoord[1];
  c.a = 1/(height*4*width);
  Out_Color = c;
  
  //Out_Color = vec4(value, value, value, 1.0);
}