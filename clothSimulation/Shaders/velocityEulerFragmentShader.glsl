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
		vec3 posUp = vec3(temp);
		posUp.r = temp.r;
		posUp.g = temp.g;
		posUp.b = temp.b;
		temp = texture(VelocityOld, cord - nrOfParticlesHorizontally); 
		vec3 velUp;
		velUp.r = temp.r;
		velUp.g = temp.g;
		velUp.b = temp.b;
		vec3 diff = posUp - position;
		vec3 ndiff = normalize(diff);
		cUp = velUp - velocity;	
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z ==0)
			kUp = vec3(0,0,0);
		else
			kUp = (diff)* ((ndiff - oaSt)/ndiff);		
	
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
		diff = posRight - position;
		ndiff = normalize(diff);
		cRight = velRight - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			kRight = vec3(0,0,0);
		else
			kRight = (diff)* ((ndiff - oaSt)/ndiff);
		
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
		diff = posDown - position;
		ndiff = normalize(diff);
		cDown = velDown - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			kDown = vec3(0,0,0);
		else
			kDown = (diff)* ((ndiff - oaSt)/ndiff);
		
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
		diff = posLeft - position;
		ndiff = normalize(diff);
		cLeft = velLeft - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			kLeft = vec3(0,0,0);
		else
			kLeft = (diff)* ((ndiff - oaSt)/ndiff);
		

		//bend spring upwards
		temp = texture(PositionOld, cord - 2*nrOfParticlesHorizontally); 
		vec3 pos2Up;
		pos2Up.r = temp.r;
		pos2Up.g = temp.g;
		pos2Up.b = temp.b;
		temp = texture(VelocityOld, cord - 2*nrOfParticlesHorizontally); 
		vec3 vel2Up;
		vel2Up.r = temp.r;
		vel2Up.g = temp.g;
		vel2Up.b = temp.b;
		diff = pos2Up - position;
		ndiff = normalize(diff);
		c2Up = vel2Up - velocity;	
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z ==0)
			k2Up = vec3(0,0,0);
		else
			k2Up = (diff)* ((ndiff - oaB)/ndiff);
		
		//bend spring to the right
		temp = texture(PositionOld, cord + 2); 
		vec3 pos2Right;
		pos2Right.r = temp.r;
		pos2Right.g = temp.g;
		pos2Right.b = temp.b;
		temp = texture(VelocityOld, cord + 2); 
		vec3 vel2Right;
		vel2Right.r = temp.r;
		vel2Right.g = temp.g;
		vel2Right.b = temp.b;
		diff = pos2Right - position;
		ndiff = normalize(diff);
		c2Right = vel2Right - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			k2Right = vec3(0,0,0);
		else
			k2Right = (diff)* ((ndiff - oaB)/ndiff);
		
		//bend spring downwards
		temp = texture(PositionOld, cord + 2*nrOfParticlesHorizontally); 
		vec3 pos2Down;
		pos2Down.r = temp.r;
		pos2Down.g = temp.g;
		pos2Down.b = temp.b;
		temp = texture(VelocityOld, cord + 2*nrOfParticlesHorizontally); 
		vec3 vel2Down;
		vel2Down.r = temp.r;
		vel2Down.g = temp.g;
		vel2Down.b = temp.b;
		diff = pos2Down - position;
		ndiff = normalize(diff);
		c2Down = vel2Down - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			k2Down = vec3(0,0,0);
		else
			k2Down = (diff)* ((ndiff - oaB)/ndiff);

		//bend spring to the left
		temp = texture(PositionOld, cord + 2); 
		vec3 pos2Left;
		pos2Left.r = temp.r;
		pos2Left.g = temp.g;
		pos2Left.b = temp.b;
		temp = texture(VelocityOld, cord + 2); 
		vec3 vel2Left;
		vel2Left.r = temp.r;
		vel2Left.g = temp.g;
		vel2Left.b = temp.b;
		diff = pos2Left - position;
		ndiff = normalize(diff);
		c2Left = vel2Left - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			k2Left = vec3(0,0,0);
		else
			k2Left = (diff)* ((ndiff - oaB)/ndiff);		

		
		//shear spring to the right and Upwards	
		temp = texture(PositionOld, cord - nrOfParticlesHorizontally + 1); 
		vec3 posUpRight;
		posUpRight.r = temp.r;
		posUpRight.g = temp.g;
		posUpRight.b = temp.b;
		temp = texture(VelocityOld, cord - nrOfParticlesHorizontally + 1); 
		vec3 velUpRight;
		velUpRight.r = temp.r;
		velUpRight.g = temp.g;
		velUpRight.b = temp.b;
		diff = posUpRight - position;
		ndiff = normalize(diff);
		cUpRight = velUpRight - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			kUpRight = vec3(0,0,0);
		else
			kUpRight = (diff)*((ndiff - oaSh) / ndiff);

		//shear spring to the right and downwards	
		temp = texture(PositionOld, cord + nrOfParticlesHorizontally + 1); 
		vec3 posDownRight;
		posDownRight.r = temp.r;
		posDownRight.g = temp.g;
		posDownRight.b = temp.b;
		temp = texture(VelocityOld, cord + nrOfParticlesHorizontally + 1); 
		vec3 velDownRight;
		velDownRight.r = temp.r;
		velDownRight.g = temp.g;
		velDownRight.b = temp.b;
		cDownRight = velDownRight - velocity;
		diff = posDownRight - position;
		ndiff = normalize(diff);
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			kDownRight = vec3(0,0,0);
		else
			kDownRight = (diff)*((ndiff - oaSh) / ndiff);

		//shear spring to the left and downwards	
		temp = texture(PositionOld, cord + nrOfParticlesHorizontally - 1); 
		vec3 posDownLeft;
		posDownLeft.r = temp.r;
		posDownLeft.g = temp.g;
		posDownLeft.b = temp.b;
		temp = texture(VelocityOld, cord + nrOfParticlesHorizontally - 1); 
		vec3 velDownLeft;
		velDownLeft.r = temp.r;
		velDownLeft.g = temp.g;
		velDownLeft.b = temp.b;
		cDownLeft = velDownLeft - velocity;
		diff = posDownLeft - position;
		ndiff = normalize(diff);
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			kDownLeft = vec3(0,0,0);
		else
			kDownLeft = (diff)*((ndiff - oaSh) / ndiff);
							
		//shear spring to the left and Upwards
		temp = texture(PositionOld, cord - nrOfParticlesHorizontally - 1); 
		vec3 posUpLeft;
		posUpLeft.r = temp.r;
		posUpLeft.g = temp.g;
		posUpLeft.b = temp.b;
		temp = texture(VelocityOld, cord - nrOfParticlesHorizontally - 1); 
		vec3 velUpLeft;
		velUpLeft.r = temp.r;
		velUpLeft.g = temp.g;
		velUpLeft.b = temp.b;
		cUpLeft = velUpLeft - velocity;
		diff = posUpLeft - position;
		ndiff = normalize(diff);
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff.x == 0 || ndiff.y == 0 || ndiff.z == 0)
			kUpLeft = vec3(0,0,0);
		else
			kUpLeft = (diff)*((ndiff - oaSh) / ndiff);



		//calculate the new velosity
		NewVelocity = velocity + (timestep / particleMass)*(particleMass*g + kSt*(kUp +kLeft + kRight + kDown) );// + kSh*(kUpLeft + kUpRight + kDownLeft + kDownRight) + kB*(k2Up + k2Right + k2Down + k2Left) + cSt*(cUp + cLeft + cRight + cDown) + cSh*(cUpLeft + cUpRight + cDownLeft + cDownRight) + cB*(c2Up + c2Right + c2Down + c2Left));
		//NewVelocity = kUp;
		vel.r = NewVelocity.r;
		vel.g = NewVelocity.g;
		vel.b = NewVelocity.b;
	}

	Out_Color = vel;
}
