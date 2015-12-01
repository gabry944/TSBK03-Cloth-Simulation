#version 150

in vec3 Position;
in vec2 texCoord;

uniform sampler2D tex;

uniform int nrOfParticlesHorizontally;
uniform float timestep;
uniform float particleMass;
uniform float g;
uniform float kSt;
uniform float kSh;
uniform float kB;
uniform float oaSt;//kanske onöding
uniform float oaSh;//kanske onöding
uniform float oaB ;//kanske onöding
uniform float cSt;
uniform float cSh;
uniform float cB;

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

	vec3 velocity;
	vec3 velocity_old = c.rgb;

	vec2 cord = texCoord;
	vec4 c = texture(tex, cord);
	if (c.a == 0)
	{
		//bend spring upwards
		k2Up = ((particle_old[j - 2 * nrOfParticlesHorizontally] - particle_old[j])*((norm(particle_old[j - 2 * nrOfParticlesHorizontally] - particle_old[j]) - oaB) / norm(particle_old[j - 2 * nrOfParticlesHorizontally] - particle_old[j])));
		c2Up = velocity_old[j - 2 * nrOfParticlesHorizontally] - velocity_old[j];

		//streatch spring upwards
		kUp = ((particle_old[j - nrOfParticlesHorizontally] - particle_old[j])*((norm(particle_old[j - nrOfParticlesHorizontally] - particle_old[j]) - oaSt) / norm(particle_old[j - nrOfParticlesHorizontally] - particle_old[j])));
		cUp = velocity_old[j - nrOfParticlesHorizontally] - velocity_old[j];

		//bend spring to the right
		k2Right = ((particle_old[j + 2] - particle_old[j])*((norm(particle_old[j + 2] - particle_old[j]) - oaB) / norm(particle_old[j + 2] - particle_old[j])));
		c2Right = velocity_old[j + 2] - velocity_old[j];
		
		//streatch spring to the right
		kRight = ((particle_old[j + 1] - particle_old[j])*((norm(particle_old[j + 1] - particle_old[j]) - oaSt) / norm(particle_old[j + 1] - particle_old[j])));
		cRight = velocity_old[j + 1] - velocity_old[j];

		//bend spring downwards
		k2Down = ((particle_old[j + 2 * nrOfParticlesHorizontally] - particle_old[j])*((norm(particle_old[j + 2 * nrOfParticlesHorizontally] - particle_old[j]) - oaB) / norm(particle_old[ j + 2 * nrOfParticlesHorizontally] - particle_old[j])));
		c2Down = velocity_old[j + 2 * nrOfParticlesHorizontally] - velocity_old[j];

		//streatch spring downwards
		kDown = ((particle_old[ j + nrOfParticlesHorizontally] - particle_old[j])*((norm(particle_old[j + nrOfParticlesHorizontally] - particle_old[j]) - oaSt) / norm(particle_old[j + nrOfParticlesHorizontally] - particle_old[j])));
		cDown = velocity_old[j + nrOfParticlesHorizontally] - velocity_old[j];

		//bend spring to the left
		k2Left = ((particle_old[j - 2] - particle_old[j])*((norm(particle_old[j - 2] - particle_old[j]) - oaB) / norm(particle_old[j - 2] - particle_old[j])));
		c2Left = velocity_old[j - 2] - velocity_old[j];

		//streatch spring to the left
		kLeft = ((particle_old[j - 1] - particle_old[j])*((norm(particle_old[j - 1] - particle_old[j]) - oaSt) / norm(particle_old[j - 1] - particle_old[j])));
		cLeft = velocity_old[j - 1] - velocity_old[j];
		
		//shear spring to the right and Upwards
		kUpRight = ((particle_old[j - nrOfParticlesHorizontally + 1] - particle_old[j])*((norm(particle_old[j - nrOfParticlesHorizontally + 1] - particle_old[j]) - oaSh) / norm(particle_old[j - nrOfParticlesHorizontally + 1] - particle_old[j])));
		cUpRight = velocity_old[ j - nrOfParticlesHorizontally + 1] - velocity_old[j];
		
		//shear spring to the right and downwards
		kDownRight = ((particle_old[j + nrOfParticlesHorizontally + 1] - particle_old[j])*((norm(particle_old[j + nrOfParticlesHorizontally + 1] - particle_old[j]) - oaSh) / norm(particle_old[j + nrOfParticlesHorizontally + 1] - particle_old[j])));
		cDownRight = velocity_old[j + nrOfParticlesHorizontally + 1] - velocity_old[j];
		
		//shear spring to the left and downwards
		kDownLeft = ((particle_old[j + nrOfParticlesHorizontally - 1] - particle_old[j])*((norm(particle_old[j + nrOfParticlesHorizontally - 1] - particle_old[j]) - oaSh) / norm(particle_old[j + nrOfParticlesHorizontally - 1] - particle_old[j])));
		cDownLeft = velocity_old[j + nrOfParticlesHorizontally - 1] - velocity_old[j];
		
		//shear spring to the left and Upwards
		kUpLeft = ((particle_old[j - nrOfParticlesHorizontally - 1] - particle_old[j])*((norm(particle_old[j - nrOfParticlesHorizontally - 1] - particle_old[j]) - oaSh) / norm(particle_old[j - nrOfParticlesHorizontally - 1] - particle_old[j])));
		cUpLeft = velocity_old[j - nrOfParticlesHorizontally - 1] - velocity_old[j];
		




		//calculate the new velosity
		velocity = velocity_old + (timestep / particleMass)*(particleMass*g + kSt*(kUp +kLeft + kRight + kDown) + kSh*(kUpLeft + kUpRight + kDownLeft + kDownRight) + kB*(k2Up + k2Right + k2Down + k2Left) + cSt*(cUp + cLeft + cRight + cDown) + cSh*(cUpLeft + cUpRight + cDownLeft + cDownRight) + cB*(c2Up + c2Right + c2Down + c2Left));

		c.r = velocity.r;
		c.g = velocity.g;
		c.b = velocity.b;
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
