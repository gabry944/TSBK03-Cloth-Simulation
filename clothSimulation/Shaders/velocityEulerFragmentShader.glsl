#version 150

in vec3 Position2;
in vec2 texCoord;

uniform sampler2D VelocityOld;
uniform sampler2D PositionOld;

uniform int nrOfParticlesHorizontally;
uniform float timestep;
uniform float particleMass;
uniform vec3 g;
uniform float kSt;
uniform float kSh;
uniform float kB;
uniform float oaSt;
uniform float oaSh;
uniform float oaB ;
uniform float cSt;
uniform float cSh;
uniform float cB;

out vec4 Out_Color;

void main(void) {
 
	vec2 cord = texCoord;
	vec4 vel = texture(VelocityOld, cord); 
	vec4 pos = texture(PositionOld, cord); 

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

	vec3 NewVelocity;
	vec3 velocity;
	velocity.r = vel.r;
	velocity.g = vel.g;
	velocity.b = vel.b;
	vec3 position;
	position.r = pos.r;
	position.g = pos.g;
	position.b = pos.b;

	if (vel.a == 0)
	{
		//streatch spring upwards
		vec4 temp = texture(PositionOld, cord - nrOfParticlesHorizontally); 
		vec3 posUp;
		posUp.r = temp.r;
		posUp.g = temp.g;
		posUp.b = temp.b;
		temp = texture(VelocityOld, cord - nrOfParticlesHorizontally); 
		vec3 velUp;
		velUp.r = temp.r;
		velUp.g = temp.g;
		velUp.b = temp.b;

		//streatch spring to the right
		temp = texture(PositionOld, cord + 1); 
		vec3 posRight;
		posRight.r = temp.r;
		posRight.g = temp.g;
		posRight.b = temp.b;
		temp = texture(VelocityOld, cord + 1); 
		vec3 velRight;
		velRight.r = temp.r;
		velRight.g = temp.g;
		velRight.b = temp.b;

		//streatch spring downwards
		temp = texture(PositionOld, cord + nrOfParticlesHorizontally); 
		vec3 posDown;
		posDown.r = temp.r;
		posDown.g = temp.g;
		posDown.b = temp.b;
		temp = texture(VelocityOld, cord + nrOfParticlesHorizontally); 
		vec3 velDown;
		velDown.r = temp.r;
		velDown.g = temp.g;
		velDown.b = temp.b;

		//streatch spring to the left
		temp = texture(PositionOld, cord + 1); 
		vec3 posLeft;
		posLeft.r = temp.r;
		posLeft.g = temp.g;
		posLeft.b = temp.b;
		temp = texture(VelocityOld, cord + 1); 
		vec3 velLeft;
		velLeft.r = temp.r;
		velLeft.g = temp.g;
		velLeft.b = temp.b;

		//streatch spring upwards
		//check for devison by zero and normalisation of zero vector
		vec3 diff = posUp - position;
		vec3 ndiff = normalize(diff);
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z ==0)
			kUp = vec3(0,0,0);
		else
			kUp = (diff)* ((ndiff - oaSt)/ndiff);
		
		cUp = velUp - velocity;	
	
		
		//streatch spring to the right
		//check for devison by zero and normalisation of zero vector
		diff = posRight - position;
		ndiff = normalize(diff);
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			kRight = vec3(0,0,0);
		else
			kRight = (diff)* ((ndiff - oaSt)/ndiff);
		
		cRight = velRight - velocity;

		//streatch spring downwards
		//check for devison by zero and normalisation of zero vector
		diff = posDown - position;
		ndiff = normalize(diff);
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			kDown = vec3(0,0,0);
		else
			kDown = (diff)* ((ndiff - oaSt)/ndiff);

		cDown = velDown - velocity;
		
		//streatch spring to the left
		//check for devison by zero and normalisation of zero vector
		diff = posLeft - position;
		ndiff = normalize(diff);
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			kLeft = vec3(0,0,0);
		else
			kLeft = (diff)* ((ndiff - oaSt)/ndiff);
		
		cLeft = velLeft - velocity;

	/*
		//streatch spring upwards
		kUp = ((particle_old[j - nrOfParticlesHorizontally] - particle_old[j])*((norm(particle_old[j - nrOfParticlesHorizontally] - particle_old[j]) - oaSt) / norm(particle_old[j - nrOfParticlesHorizontally] - particle_old[j])));
		cUp = velocity_old[j - nrOfParticlesHorizontally] - velocity_old[j];

		//streatch spring to the right
		kRight = ((particle_old[j + 1] - particle_old[j])*((norm(particle_old[j + 1] - particle_old[j]) - oaSt) / norm(particle_old[j + 1] - particle_old[j])));
		cRight = velocity_old[j + 1] - velocity_old[j];

		//streatch spring downwards
		kDown = ((particle_old[ j + nrOfParticlesHorizontally] - particle_old[j])*((norm(particle_old[j + nrOfParticlesHorizontally] - particle_old[j]) - oaSt) / norm(particle_old[j + nrOfParticlesHorizontally] - particle_old[j])));
		cDown = velocity_old[j + nrOfParticlesHorizontally] - velocity_old[j];

		//streatch spring to the left
		kLeft = ((particle_old[j - 1] - particle_old[j])*((norm(particle_old[j - 1] - particle_old[j]) - oaSt) / norm(particle_old[j - 1] - particle_old[j])));
		cLeft = velocity_old[j - 1] - velocity_old[j];
	*/
	/*
		//bend spring upwards
		k2Up = ((particle_old[j - 2 * nrOfParticlesHorizontally] - particle_old[j])*((norm(particle_old[j - 2 * nrOfParticlesHorizontally] - particle_old[j]) - oaB) / norm(particle_old[j - 2 * nrOfParticlesHorizontally] - particle_old[j])));
		c2Up = velocity_old[j - 2 * nrOfParticlesHorizontally] - velocity_old[j];

		//bend spring to the right
		k2Right = ((particle_old[j + 2] - particle_old[j])*((norm(particle_old[j + 2] - particle_old[j]) - oaB) / norm(particle_old[j + 2] - particle_old[j])));
		c2Right = velocity_old[j + 2] - velocity_old[j];
		
		//bend spring downwards
		k2Down = ((particle_old[j + 2 * nrOfParticlesHorizontally] - particle_old[j])*((norm(particle_old[j + 2 * nrOfParticlesHorizontally] - particle_old[j]) - oaB) / norm(particle_old[ j + 2 * nrOfParticlesHorizontally] - particle_old[j])));
		c2Down = velocity_old[j + 2 * nrOfParticlesHorizontally] - velocity_old[j];

		//bend spring to the left
		k2Left = ((particle_old[j - 2] - particle_old[j])*((norm(particle_old[j - 2] - particle_old[j]) - oaB) / norm(particle_old[j - 2] - particle_old[j])));
		c2Left = velocity_old[j - 2] - velocity_old[j];
		
		//shear spring to the right and Upwards
		kUpRight = ((particle_old[j - nrOfParticlesHorizontally + 1] - particle_old[j])*((norm(particle_old[j - nrOfParticlesHorizontally + 1] - particle_old[j]) - oaSh) / norm(particle_old[j - nrOfParticlesHorizontally + 1] - particle_old[j])));
		cUpRight = velocity_old[ j - nrOfParticlesHorizontally + 1] - velocity_old[j];
		
		//shear spring to the right and downwards
		kDownRight = ((particle_old[j + nrOfParticlesHorizontally + 1] - particle_old[j])*((norm(particle_old[j + nrOfParticlesHorizontally + 1] - particle_old[j]) - oaSh) / norm(particle_old[j + nrOfParticlesHorizontally + 1] - particle_old[j])));
		cDownRight = velocity_old[j + nrOfParticlesHorizontally + 1] - velocity_old[j];
		
		//shear spring to the left and downwards
		kDownLeft = ((particle_old[j + nrOfParticlesHorizontally - 1] - particle_old[j])*((norm(particle_old[j + nrOfParticlesHorizontally - 1] - particle_old[j]) - oaSh) / norm(particle_old[j + nrOfParticlesHorizontally - 1] - particle_old[j])));
		cDownLeft = velocity_old[j + nrOfParticlesHorizontally - 1] - velocity_old[j];
	*/
		
		//shear spring to the left and Upwards
		kUpLeft = vec3(0,0,0);// ((particle_old[j - nrOfParticlesHorizontally - 1] - particle_old[j])*((norm(particle_old[j - nrOfParticlesHorizontally - 1] - particle_old[j]) - oaSh) / norm(particle_old[j - nrOfParticlesHorizontally - 1] - particle_old[j])));
		cUpLeft = vec3(0,0,0);//velocity_old[j - nrOfParticlesHorizontally - 1] - velocity_old[j];
		



		//calculate the new velosity
		NewVelocity = velocity + (timestep / particleMass)*(particleMass*g + kSt*(kUp +kLeft + kRight + kDown) );// + kSh*(kUpLeft + kUpRight + kDownLeft + kDownRight) + kB*(k2Up + k2Right + k2Down + k2Left) + cSt*(cUp + cLeft + cRight + cDown) + cSh*(cUpLeft + cUpRight + cDownLeft + cDownRight) + cB*(c2Up + c2Right + c2Down + c2Left));
		//NewVelocity = kUp;
		vel.r = NewVelocity.r;
		vel.g = NewVelocity.g;
		vel.b = NewVelocity.b;
	}
	else
	{
		/*c.r = c.r;
		c.g = c.g;
		c.b = c.b;
		c.a = c.a;*/
	}
	Out_Color = vel;
}
