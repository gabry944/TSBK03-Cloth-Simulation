#version 150

in vec3 Position;
in vec2 texCoord;

uniform sampler2D tex;

uniform float height;
uniform float width;
uniform float springRestLenght;

out vec4 Out_Color;

/***********************************************
 * Place the particles in a coordinate system, *
 * cloth in its initial state,                 *
 * the first particle in origo.                *
 ***********************************************/
void main(void) {
	vec2 cord = texCoord;
	vec4 c = texture(tex, cord);
	float step =  1/(height*width);
	
	//check witch number we are at in the array (texture)
	int i = int(cord[0] / step);

	//check witch row the partical is on 
	int row = int(floor(texCoord[0]/(width*step)));

	c.r = springRestLenght * (i - width*row); // X-coordinate
	c.g = 0;								  // y-coordinate
	c.b = springRestLenght * row;			  // z-coordinate
	
	//tell if ther is a special case point here
	if(texCoord[0]< step)																	//top left corner
		c.a = 1;
	else if(texCoord[0] - (width-1)*step< step && texCoord[0] - (width-1)*step > 0)			// top right corner
		c.a = 2;	
	else if(1 - step*width < texCoord[0] && texCoord[0] + step*(width-1) < 1)				// bottom left corner
		c.a = 3;	
	else if(1 - step < texCoord[0])															// bottom right corner
		c.a = 4;
	else if(texCoord[0] - (width-1)*step< step)												// top row
		c.a = 5;	
	else if(mod(texCoord[0],width*step) < step)												// left row
		c.a = 6;			
	else if(mod(texCoord[0]+step,width*step) < step)										// right row
		c.a = 7;	
	else if(1 - step*width < texCoord[0])													// bottom row
		c.a = 8;	
	else if(texCoord[0] - (width+1)* step < step)											// second top left corner
		c.a = 9;
	else if(texCoord[0] - (2*width-2)* step < step && texCoord[0] - (2*width-2)* step > 0)	// second top right corner
		c.a = 10;	
	else if(1 - step*(2*width-1) < texCoord[0] && texCoord[0] + step*(2*width-2) < 1)		// second bottom left corner
		c.a = 11;
	else if(1 - step*(width+2) < texCoord[0] && texCoord[0] + step*(width+1) < 1)			// second bottom right corner
		c.a = 12;
	else if(texCoord[0] - (2*width-1)*step< step)											//second top row
		c.a = 13;	
	else if(mod(texCoord[0]-step,width*step) < step)											// second left row
		c.a = 14;			
	else if(mod(texCoord[0]+2*step,width*step) < step)										// second right row
		c.a = 15;	
	else if(1 - step*2*width < texCoord[0])													//second bottom row
		c.a = 16;
	else																					//middel points (will have all springs/dampers)
		c.a = 0;

	Out_Color = c;
}