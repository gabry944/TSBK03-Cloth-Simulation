#version 150

in vec3 Position;
in vec2 texCoord;

uniform sampler2D tex;

out vec4 Out_Color;

void main(void) {
  
  vec2 cord = texCoord;
  vec4 c = texture(tex, cord);
  c.r =  c.r - 30;
  c.g =  c.g - 30;
  c.b =  c.b - 30;
  Out_Color = c; 

}