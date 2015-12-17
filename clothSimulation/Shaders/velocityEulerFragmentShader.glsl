#version 150

in vec3 Position2;
in vec2 texCoord;

uniform sampler2D VelocityOld;
uniform sampler2D PositionOld;

uniform float nrOfParticlesVertically;
uniform float nrOfParticlesHorizontally;
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
		
	float step =  1/(nrOfParticlesVertically*nrOfParticlesHorizontally); 

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
		vec2 cord2= vec2(cord.x - step * nrOfParticlesHorizontally, cord.y);
		vec4 temp = texture(PositionOld, cord2); 
		vec3 posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		vec3 velTemp = vec3(temp);
		cUp = velTemp - velocity;	
		vec3 diff = posTemp - position;
		float ndiff =abs(length(diff));
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 1 || vel.a == 5 || vel.a == 2)
			kUp = vec3(0,0,0);
		else
			kUp = (diff)* ((ndiff - oaSt)/ndiff);		
	
		//streatch spring to the right
		cord2= vec2(cord.x + step , cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);			
		diff = posTemp - position;
		ndiff =abs(length(diff));
		cRight = velTemp - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 2 || vel.a == 7 || vel.a == 4)
			kRight = vec3(0,0,0);
		else
			kRight = (diff)* ((ndiff - oaSt)/ndiff);
		
		//streatch spring downwards
		cord2= vec2(cord.x + step * nrOfParticlesHorizontally, cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);
		diff = posTemp - position;
		ndiff =abs(length(diff));
		cDown = velTemp - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 3 || vel.a == 8 || vel.a == 4)
			kDown = vec3(0,0,0);
		else
			kDown = (diff)* ((ndiff - oaSt)/ndiff);
		
		//streatch spring to the left
		cord2= vec2(cord.x - step, cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);
		diff = posTemp - position;
		ndiff =abs(length(diff));
		cLeft = velTemp - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 1 || vel.a == 6 || vel.a == 3)
			kLeft = vec3(0,0,0);
		else
			kLeft = (diff)* ((ndiff - oaSt)/ndiff);
		

		//bend spring upwards
		cord2 = vec2(cord.x - step * 2*nrOfParticlesHorizontally, cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);
		diff = posTemp - position;
		ndiff =abs(length(diff));
		c2Up = velTemp - velocity;	
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 1 || vel.a == 5 || vel.a == 2 
			|| cord.x - (2*nrOfParticlesHorizontally-1)*step< step )
			k2Up = vec3(0,0,0);
		else
			k2Up = (diff)* ((ndiff - oaB)/ndiff);
		
		//bend spring to the right
		cord2= vec2(cord.x + step * 2, cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);
		diff = posTemp - position;
		ndiff =abs(length(diff));
		c2Right = velTemp - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 2 || vel.a == 7 || vel.a == 4 
			|| mod(cord.x+2*step,nrOfParticlesHorizontally*step) < step)
			k2Right = vec3(0,0,0);
		else
			k2Right = (diff)* ((ndiff - oaB)/ndiff);
		
		//bend spring downwards
		cord2= vec2(cord.x + step * 2*nrOfParticlesHorizontally, cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);
		diff = posTemp - position;
		ndiff =abs(length(diff));
		c2Down = velTemp - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 3 || vel.a == 8 || vel.a == 4 
			|| 1 - step*2*nrOfParticlesHorizontally < cord.x)
			k2Down = vec3(0,0,0);
		else
			k2Down = (diff)* ((ndiff - oaB)/ndiff);

		//bend spring to the left
		cord2= vec2(cord.x - step * 2, cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);
		diff = posTemp - position;
		ndiff =abs(length(diff));
		c2Left = velTemp - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 1 || vel.a == 6 || vel.a == 3 
			|| mod(cord.x-step,nrOfParticlesHorizontally*step) < step)
			k2Left = vec3(0,0,0);
		else
			k2Left = (diff)* ((ndiff - oaB)/ndiff);		

		
		//shear spring to the right and Upwards	
		cord2= vec2(cord.x - step * (nrOfParticlesHorizontally - 1), cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);
		diff = posTemp - position;
		ndiff =abs(length(diff));
		cUpRight = velTemp - velocity;
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 5 || vel.a == 2 || vel.a == 7 || vel.a == 1 || vel.a == 4 )
			kUpRight = vec3(0,0,0);
		else
			kUpRight = (diff)*((ndiff - oaSh) / ndiff);

		//shear spring to the right and downwards	
		cord2= vec2(cord.x + step * (nrOfParticlesHorizontally + 1), cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);
		cDownRight = velTemp - velocity;
		diff = posTemp - position;
		ndiff =abs(length(diff));
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 7 || vel.a == 4 || vel.a == 8 || vel.a == 2 || vel.a == 3 )
			kDownRight = vec3(0,0,0);
		else
			kDownRight = (diff)*((ndiff - oaSh) / ndiff);
										
		//shear spring to the left and Upwards
		cord2= vec2(cord.x - step * (nrOfParticlesHorizontally + 1), cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);
		cUpLeft = velTemp - velocity;
		diff = posTemp - position;
		ndiff =abs(length(diff));
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 5 || vel.a == 1 || vel.a == 6 || vel.a == 2 || vel.a == 3 )
			kUpLeft = vec3(0,0,0);
		else
			kUpLeft = (diff)*((ndiff - oaSh) / ndiff);
			
		//shear spring to the left and downwards	
		cord2= vec2(cord.x + step * (nrOfParticlesHorizontally - 1), cord.y);
		temp = texture(PositionOld, cord2); 
		posTemp = vec3(temp);
		temp = texture(VelocityOld, cord2); 
		velTemp = vec3(temp);
		cDownLeft = velTemp - velocity;
		diff = posTemp - position;
		ndiff =abs(length(diff));
		//check for devison by zero and normalisation of zero vector
		if (diff == vec3(0,0,0) || ndiff == 0
			|| vel.a == 6 || vel.a == 3 || vel.a == 8 || vel.a == 1 || vel.a == 4 )
			kDownLeft = vec3(0,0,0);
		else
			kDownLeft = (diff)*((ndiff - oaSh) / ndiff);


	//calculate the new velosity
	NewVelocity = velocity + (timestep / particleMass) * (particleMass*g + kSt*(kUp +kLeft + kRight + kDown) + kSh*(kUpLeft + kUpRight + kDownLeft + kDownRight) + kB*(k2Up + k2Right + k2Down + k2Left) + cSt*(cUp + cLeft + cRight + cDown) + cSh*(cUpLeft + cUpRight + cDownLeft + cDownRight) + cB*(c2Up + c2Right + c2Down + c2Left));
	//NewVelocity = diff;
	vel.r = NewVelocity.r;
	vel.g = NewVelocity.g;
	vel.b = NewVelocity.b;

	if(vel.a == 3 || vel.a == 4 )
	{
		vel.r = 0;
		vel.g = 0;
		vel.b = 0;
	}
	Out_Color = vel;
}
