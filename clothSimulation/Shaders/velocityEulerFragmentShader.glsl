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


		//streatch spring upwards
		vec4 temp = texture(PositionOld, cord - nrOfParticlesHorizontally); 
		vec3 posUp = vec3(temp);
		temp = texture(VelocityOld, cord - nrOfParticlesHorizontally); 
		vec3 velUp = vec3(temp);
		vec3 diff = posUp - position;
		vec3 ndiff = normalize(diff);
		cUp = velUp - velocity;	
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z ==0 
			|| vel.a == 1 || vel.a == 5 || vel.a == 2)
			kUp = vec3(0,0,0);
		else
			kUp = (diff)* ((ndiff - oaSt)/ndiff);		
	
		//streatch spring to the right
		temp = texture(PositionOld, cord + 1); 
		vec3 posRight = vec3(temp);
		temp = texture(VelocityOld, cord + 1); 
		vec3 velRight = vec3(temp);			
		diff = posRight - position;
		ndiff = normalize(diff);
		cRight = velRight - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0
			|| vel.a == 2 || vel.a == 7 || vel.a == 4)
			kRight = vec3(0,0,0);
		else
			kRight = (diff)* ((ndiff - oaSt)/ndiff);
		
		//streatch spring downwards
		temp = texture(PositionOld, cord + nrOfParticlesHorizontally); 
		vec3 posDown = vec3(temp);
		temp = texture(VelocityOld, cord + nrOfParticlesHorizontally); 
		vec3 velDown = vec3(temp);
		diff = posDown - position;
		ndiff = normalize(diff);
		cDown = velDown - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0
			|| vel.a == 3 || vel.a == 8 || vel.a == 4)
			kDown = vec3(0,0,0);
		else
			kDown = (diff)* ((ndiff - oaSt)/ndiff);
		
		//streatch spring to the left
		temp = texture(PositionOld, cord - 1); 
		vec3 posLeft = vec3(temp);
		temp = texture(VelocityOld, cord - 1); 
		vec3 velLeft = vec3(temp);
		diff = posLeft - position;
		ndiff = normalize(diff);
		cLeft = velLeft - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0
			|| vel.a == 1 || vel.a == 6 || vel.a == 3)
			kLeft = vec3(0,0,0);
		else
			kLeft = (diff)* ((ndiff - oaSt)/ndiff);
		

		//bend spring upwards
		temp = texture(PositionOld, cord - 2*nrOfParticlesHorizontally); 
		vec3 pos2Up = vec3(temp);
		temp = texture(VelocityOld, cord - 2*nrOfParticlesHorizontally); 
		vec3 vel2Up = vec3(temp);
		diff = pos2Up - position;
		ndiff = normalize(diff);
		c2Up = vel2Up - velocity;	
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z ==0
			|| vel.a == 1 || vel.a == 5 || vel.a == 2 
			|| vel.a == 9 || vel.a == 13 || vel.a == 10
			|| vel.a == 6 || vel.a == 7 )
			k2Up = vec3(0,0,0);
		else
			k2Up = (diff)* ((ndiff - oaB)/ndiff);
		
		//bend spring to the right
		temp = texture(PositionOld, cord + 2); 
		vec3 pos2Right = vec3(temp);
		temp = texture(VelocityOld, cord + 2); 
		vec3 vel2Right = vec3(temp);
		diff = pos2Right - position;
		ndiff = normalize(diff);
		c2Right = vel2Right - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0
			|| vel.a == 2 || vel.a == 7 || vel.a == 4 
			|| vel.a == 10 || vel.a == 15 || vel.a == 12
			|| vel.a == 5 || vel.a == 8 )
			k2Right = vec3(0,0,0);
		else
			k2Right = (diff)* ((ndiff - oaB)/ndiff);
		
		//bend spring downwards
		temp = texture(PositionOld, cord + 2*nrOfParticlesHorizontally); 
		vec3 pos2Down = vec3(temp);
		temp = texture(VelocityOld, cord + 2*nrOfParticlesHorizontally); 
		vec3 vel2Down = vec3(temp);
		diff = pos2Down - position;
		ndiff = normalize(diff);
		c2Down = vel2Down - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0
			|| vel.a == 3 || vel.a == 8 || vel.a == 4 
			|| vel.a == 11 || vel.a == 16 || vel.a == 12
			|| vel.a == 6 || vel.a == 7 )
			k2Down = vec3(0,0,0);
		else
			k2Down = (diff)* ((ndiff - oaB)/ndiff);

		//bend spring to the left
		temp = texture(PositionOld, cord + 2); 
		vec3 pos2Left = vec3(temp);
		temp = texture(VelocityOld, cord + 2); 
		vec3 vel2Left = vec3(temp);
		diff = pos2Left - position;
		ndiff = normalize(diff);
		c2Left = vel2Left - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0
			|| vel.a == 1 || vel.a == 6 || vel.a == 3 
			|| vel.a == 9 || vel.a == 14 || vel.a == 11
			|| vel.a == 8 || vel.a == 5)
			k2Left = vec3(0,0,0);
		else
			k2Left = (diff)* ((ndiff - oaB)/ndiff);		

		
		//shear spring to the right and Upwards	
		temp = texture(PositionOld, cord - nrOfParticlesHorizontally + 1); 
		vec3 posUpRight = vec3(temp);
		temp = texture(VelocityOld, cord - nrOfParticlesHorizontally + 1); 
		vec3 velUpRight = vec3(temp);
		diff = posUpRight - position;
		ndiff = normalize(diff);
		cUpRight = velUpRight - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0
			|| vel.a == 5 || vel.a == 2 || vel.a == 7 || vel.a == 1 || vel.a == 4 )
			kUpRight = vec3(0,0,0);
		else
			kUpRight = (diff)*((ndiff - oaSh) / ndiff);

		//shear spring to the right and downwards	
		temp = texture(PositionOld, cord + nrOfParticlesHorizontally + 1); 
		vec3 posDownRight = vec3(temp);
		temp = texture(VelocityOld, cord + nrOfParticlesHorizontally + 1); 
		vec3 velDownRight = vec3(temp);
		cDownRight = velDownRight - velocity;
		diff = posDownRight - position;
		ndiff = normalize(diff);
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0
			|| vel.a == 7 || vel.a == 4 || vel.a == 8 || vel.a == 2 || vel.a == 3 )
			kDownRight = vec3(0,0,0);
		else
			kDownRight = (diff)*((ndiff - oaSh) / ndiff);

		//shear spring to the left and downwards	
		temp = texture(PositionOld, cord + nrOfParticlesHorizontally - 1); 
		vec3 posDownLeft = vec3(temp);
		temp = texture(VelocityOld, cord + nrOfParticlesHorizontally - 1); 
		vec3 velDownLeft = vec3(temp);
		cDownLeft = velDownLeft - velocity;
		diff = posDownLeft - position;
		ndiff = normalize(diff);
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0
			|| vel.a == 6 || vel.a == 3 || vel.a == 8 || vel.a == 1 || vel.a == 4 )
			kDownLeft = vec3(0,0,0);
		else
			kDownLeft = (diff)*((ndiff - oaSh) / ndiff);
							
		//shear spring to the left and Upwards
		temp = texture(PositionOld, cord - nrOfParticlesHorizontally - 1); 
		vec3 posUpLeft = vec3(temp);
		temp = texture(VelocityOld, cord - nrOfParticlesHorizontally - 1); 
		vec3 velUpLeft = vec3(temp);
		cUpLeft = velUpLeft - velocity;
		diff = posUpLeft - position;
		ndiff = normalize(diff);
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0
			|| vel.a == 5 || vel.a == 1 || vel.a == 6 || vel.a == 2 || vel.a == 3 )
			kUpLeft = vec3(0,0,0);
		else
			kUpLeft = (diff)*((ndiff - oaSh) / ndiff);



		//calculate the new velosity
		NewVelocity = velocity + (timestep / particleMass)*(particleMass*g + kSt*(kUp +kLeft + kRight + kDown) + kSh*(kUpLeft + kUpRight + kDownLeft + kDownRight) + kB*(k2Up + k2Right + k2Down + k2Left) + cSt*(cUp + cLeft + cRight + cDown) + cSh*(cUpLeft + cUpRight + cDownLeft + cDownRight) + cB*(c2Up + c2Right + c2Down + c2Left));
		//NewVelocity = kUp;
		vel.r = NewVelocity.r;
		vel.g = NewVelocity.g;
		vel.b = NewVelocity.b;
	
	Out_Color = vel;
}
