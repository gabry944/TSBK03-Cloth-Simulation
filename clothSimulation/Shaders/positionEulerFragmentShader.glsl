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
	vec3 velocity;
	velocity.r = vel.r;
	velocity.g = vel.g;
	velocity.b = vel.b;
	vec3 position;
	position.r = pos.r;
	position.g = pos.g;
	position.b = pos.b;

	//calculate the new position
	//particlesNextPos[j] = particle[j] + timestep*velocity[j];
	NewPosition  = position + timestep * velocity;

	pos.r = NewPosition.x;
	pos.g = NewPosition.y;
	pos.b = NewPosition.z;
	
	Out_Color = pos;
}
