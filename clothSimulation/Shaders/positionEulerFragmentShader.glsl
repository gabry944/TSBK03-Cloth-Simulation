#version 150

in vec3 Position2;
in vec2 texCoord;

uniform sampler2D VelocityOld;
uniform sampler2D PositionOld;

uniform float timestep;

out vec4 Out_Color;

void main(void) {
 
	vec2 cord = texCoord;
	vec4 vel = texture(VelocityOld, cord); 
	vec4 pos = texture(PositionOld, cord); 
	
	vec3 NewPosition;
	vec3 velocity = vec3(vel);
	vec3 position = vec3(pos);

	//calculate the new position
	NewPosition = position + timestep * velocity;

	pos.r = NewPosition.x;
	pos.g = NewPosition.y;
	pos.b = NewPosition.z;
	
	Out_Color = pos;
}
