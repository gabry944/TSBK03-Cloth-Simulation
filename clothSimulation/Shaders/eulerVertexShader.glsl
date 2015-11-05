# version 150

attribute vec3 coord3d;
attribute vec3 v_color;
varying vec3 f_color; // for sending color from vertexshader to fragmentshader
uniform mat4 mvp; //  global transformation matrix

void main(void) {

	// Phong
	//exNormal = inverse(transpose(mat3(modelviewMatrix))) * in_Normal; // Phong, "fake" normal transformation
	//exSurface = vec3(modelviewMatrix * vec4(in_Position, 1.0)); // Don't include projection here - we only want to go to view coordinates
	//gl_Position = projectionMatrix * modelviewMatrix * vec4(in_Position, 1.0); // This should include projection


	// Synligt
	gl_Position = mvp * vec4(coord3d, 1.0);
	f_color = v_color; // send the color to the fragmentshader
}