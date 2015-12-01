#version 150

in vec3 Position;
in vec2 texCoord;

uniform sampler2D tex;

out vec4 Out_Color;

void main(void) {
  
	vec3 kUp;
	vec3 cUp;
	vec3 kLeft;
	vec3 cLeft;
	vec3 kRight;
	vec3 cRight;
	vec3 kDown;
	vec3 cDown;
	vec3 k2Down;
	vec3 c2Down;
	vec3 kUpLeft;
	vec3 cUpLeft;
	vec3 kUpRight;
	vec3 cUpRight;
	vec3 kDownLeft;
	vec3 cDownLeft;
	vec3 kDownRight;
	vec3 cDownRight;
	vec3 k2Up;
	vec3 c2Up;
	vec3 k2Right;
	vec3 c2Right;
	vec3 k2Left;
	vec3 c2Left;

	vec2 cord = texCoord;
	vec4 c = texture(tex, cord);
	if (c.a == 0)
	{
		c.r = 1337;
		c.g = -1337;
		c.b = 1337;
	}
	else
	{
		c.r = c.r;
		c.g = c.g;
		c.b = c.b;
		c.a = c.a;
	}
	Out_Color = c;
}
