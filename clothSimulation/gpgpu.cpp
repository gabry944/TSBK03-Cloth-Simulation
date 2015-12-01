#include "Helper.h"

/*************************
* Use the GPGPU Shader  *
*************************/
void calculateNextPos(vector<glm::vec3> &particle, vector<glm::vec3> &particle_old, vector<glm::vec3> &velocity, vector<glm::vec3> &velocity_old, vector<int> staticParticles, GLuint EulerShader, FBOstruct *fboPos, FBOstruct *fboOldPos, FBOstruct *fboVel, FBOstruct *fboOldVel)
{
	// en enkel fyrkant att rita på
	GLfloat square[] = { -1, -1, 0,
		-1, 1, 0,
		1, 1, 0,
		1, -1, 0 };
	GLfloat squareTexCoord[] = { 0, 0,
		0, 1,
		1, 1,
		1, 0 };
	GLuint squareIndices[] = { 0, 1, 2, 0, 2, 3 };
	Model* squareModel = LoadDataToModel(
		square, NULL, squareTexCoord, NULL,
		squareIndices, 4, 6);

	//useFBO(fboVel, fboOldVel, fboOldPos);
	useFBO(fboVel, 0L, fboPos);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	// Activate shader program
	glUseProgram(EulerShader);
	DrawModel(squareModel, EulerShader, "in_Position", NULL, "in_TexCoord");

	/*  glReadPixels(GLint  x, GLint  y, GLsizei  width, GLsizei  height, GLenum  format, GLenum  type, GLvoid *  data);
		x, y : Specify the window coordinates of the first pixel that is read from the frame buffer. This location is the lower left corner of a rectangular block of pixels.
		width, height :	Specify the dimensions of the pixel rectangle. width and height of one correspond to a single pixel.
		format : Specifies the format of the pixel data. The following symbolic values are accepted :GL_COLOR_INDEX,GL_STENCIL_INDEX,GL_DEPTH_COMPONENT,GL_RED,GL_GREEN,GL_BLUE,GL_ALPHA,GL_RGB,GL_BGR,GL_RGBA,GL_BGRA,GL_LUMINANCE, and GL_LUMINANCE_ALPHA.
		type : Specifies the data type of the pixel data. Must be one of GL_UNSIGNED_BYTE,GL_BYTE,GL_BITMAP,GL_UNSIGNED_SHORT,GL_SHORT,GL_UNSIGNED_INT,GL_INT,GL_FLOAT,GL_UNSIGNED_BYTE_3_3_2,GL_UNSIGNED_BYTE_2_3_3_REV,GL_UNSIGNED_SHORT_5_6_5,GL_UNSIGNED_SHORT_5_6_5_REV,GL_UNSIGNED_SHORT_4_4_4_4,GL_UNSIGNED_SHORT_4_4_4_4_REV,GL_UNSIGNED_SHORT_5_5_5_1,GL_UNSIGNED_SHORT_1_5_5_5_REV,GL_UNSIGNED_INT_8_8_8_8,GL_UNSIGNED_INT_8_8_8_8_REV,GL_UNSIGNED_INT_10_10_10_2, or GL_UNSIGNED_INT_2_10_10_10_REV.
		data : Returns the pixel data.
	*/
	const size_t SIZE = nrOfParticlesVertically*nrOfParticlesHorizontally * 4;
	float particlePixels[SIZE];
	/*for (unsigned int i = 0, j = 0; i < particle.size() && j < SIZE; i++, j += 4)
	{
		/*particlePixels[j] = particle.at(i).x;
		particlePixels[j + 1] = particle.at(i).y;
		particlePixels[j + 2] = particle.at(i).z;*
		particlePixels[j] = 2;
		particlePixels[j + 1] = 2;
		particlePixels[j + 2] = 2;
		particlePixels[j + 3] = 2;
	};*/
	//cout << "innan: " << particlePixels[0] << " " << particlePixels[1] << " " << particlePixels[2] << " " << particlePixels[3] << " " << particlePixels[4] << endl;
	glReadPixels(0, 0, nrOfParticlesVertically*nrOfParticlesHorizontally, 1, GL_RGBA, GL_FLOAT, particlePixels);
	cout << " efter: " << particlePixels[0] << " " << particlePixels[1] << " " << particlePixels[2] << " " << particlePixels[3] << " " << particlePixels[4] << endl;


	
	glDisable(GL_CULL_FACE);
	glDisable(GL_DEPTH_TEST); 
	GLuint pass = loadShaders("Shaders/passVertexShader.glsl", "Shaders/passFragmentShader.glsl");
	useFBO(fboOldVel, fboVel, 0L);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glUseProgram(pass);
	DrawModel(squareModel, pass, "in_Position", NULL, "in_TexCoord");
	cout << "nästa Pass, innan: " << particlePixels[0] << " " << particlePixels[1] << " " << particlePixels[2] << " " << particlePixels[3] << " " << particlePixels[4] << endl;
	glReadPixels(0, 0, nrOfParticlesVertically*nrOfParticlesHorizontally, 1, GL_RGBA, GL_FLOAT, particlePixels);
	cout << " efter: " << particlePixels[0] << " " << particlePixels[1] << " " << particlePixels[2] << " " << particlePixels[3] << " " << particlePixels[4] << endl;




	/*for (int i = 0, j = 0; i < particle.size(); i++, j += 4)
	{
		/*cout << particlePixels[j];
		cout << particlePixels[j + 1];
		cout << particlePixels[j + 2];*
		particle.at(i).x = particlePixels[j];
		particle.at(i).y = particlePixels[j + 1];
		particle.at(i).z = particlePixels[j + 2];
	};*/
}


/**************************************
 * Create initial textures on the FBOs*
 **************************************/
void initGPGPU(FBOstruct *fboPos, FBOstruct *fboOldPos, FBOstruct *fboVel, FBOstruct *fboOldVel)
{
	// en enkel fyrkant att rita på
	GLfloat square[] = {-1, -1, 0,
						-1,  1, 0,
						 1,  1, 0,
						 1, -1, 0 };
	GLfloat squareTexCoord[] = {0, 0,
								0, 1,
								1, 1,
								1, 0 };
	GLuint squareIndices[] = { 0, 1, 2, 0, 2, 3 };
	Model* squareModel = LoadDataToModel(square, NULL, squareTexCoord, NULL,squareIndices, 4, 6);

	
	
	GLuint initVelosity = loadShaders("Shaders/initVelosityVertexShader.glsl", "Shaders/initVelosityFragmentShader.glsl");
	GLuint passOverValues = loadShaders("Shaders/passVertexShader.glsl", "Shaders/passFragmentShader.glsl");

	/****************
	 * Velosity FBO *
	 ****************/
	useFBO(fboVel, 0L, 0L);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glUseProgram(initVelosity);

	GLint locHeight = glGetUniformLocation(initVelosity, "height");
	GLint locWidth = glGetUniformLocation(initVelosity, "width");
	if (locHeight != -1 && locWidth != -1)
	{
		glUniform1f(locWidth, nrOfParticlesHorizontally);
		glUniform1f(locHeight, nrOfParticlesVertically);
	}

	DrawModel(squareModel, initVelosity, "in_Position", NULL, "in_TexCoord");

	/******************************************************
	 * Old velosity                                       *
	 * The same sa velosity, so just pass over the values *
	 ******************************************************/

	useFBO(fboOldVel, fboVel, 0L);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glUseProgram(passOverValues);

	DrawModel(squareModel, passOverValues, "in_Position", NULL, "in_TexCoord");

	const size_t SIZE = nrOfParticlesVertically*nrOfParticlesHorizontally * 4;
	float particlePixels[SIZE];
	glReadPixels(0, 0, nrOfParticlesVertically*nrOfParticlesHorizontally, 1, GL_RGBA, GL_FLOAT, particlePixels);
	
	for (int j = 0; j < SIZE; j += 4)
	{
		cout << " Init velosity: " << particlePixels[j] << " " << particlePixels[j+1] << " " << particlePixels[j+2] << " " << particlePixels[j+3] << endl;
	}

	/*GLuint initPosition = loadShaders("Shaders/initPositionVertexShader.glsl", "Shaders/initPositionFragmentShader.glsl");
	useFBO(fboPos, 0L, 0L);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glUseProgram(initPosition);
	DrawModel(squareModel, initVelosity, "in_Position", NULL, "in_TexCoord");

	useFBO(fboOldPos, 0L, 0L);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	DrawModel(squareModel, initVelosity, "in_Position", NULL, "in_TexCoord"); */
}

//gammla sättet med att försöka på på en färdigskapad texture
//void initGPGPU(vector<glm::vec3> &particle, vector<glm::vec3> &particle_old, vector<glm::vec3> &velocity, vector<glm::vec3> &velocity_old, FBOstruct *fboPos1, FBOstruct *fboPos2, FBOstruct *fboVel1, FBOstruct *fboVel2)
//{
	//Create initial textures of the array

	/* Black/white checkerboard
	float pixels[] = {
	0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f,
	1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f
	};
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 2, 2, 0, GL_RGB, GL_FLOAT, pixels); *

	// Particle texture(Array)
	const size_t size = nrOfParticlesVertically*nrOfParticlesHorizontally * 3;//particle.size() * 3;
	float particlePixels[size];
	for (int i = 0, j = 0; i < particle.size(); i++, j += 3)
	{
		particlePixels[j] = particle.at(i).x;
		particlePixels[j + 1] = particle.at(i).y;
		particlePixels[j + 2] = particle.at(i).z;
	};
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, nrOfParticlesVertically*nrOfParticlesHorizontally, 1, 0, GL_RGB, GL_FLOAT, particlePixels);

	float oldParticlePixels[size];
	for (int i = 0, j = 0; i < particle_old.size(); i++, j += 3)
	{
		oldParticlePixels[j] = particle_old.at(i).x;
		oldParticlePixels[j + 1] = particle_old.at(i).y;
		oldParticlePixels[j + 2] = particle_old.at(i).z;
	};
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, nrOfParticlesVertically*nrOfParticlesHorizontally, 1, 0, GL_RGB, GL_FLOAT, oldParticlePixels);

	// Velosity texture(Array)
	float velocityPixels[size];
	for (int i = 0, j = 0; i < velocity.size(); i++, j += 3)
	{
		velocityPixels[j] = velocity.at(i).x;
		velocityPixels[j + 1] = velocity.at(i).y;
		velocityPixels[j + 2] = velocity.at(i).z;
	};
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, nrOfParticlesVertically*nrOfParticlesHorizontally, 1, 0, GL_RGB, GL_FLOAT, velocityPixels);

	// Velosity texture(Array)
	float oldVelocityPixels[size];
	for (int i = 0, j = 0; i < velocity_old.size(); i++, j += 3)
	{
		oldVelocityPixels[j] = velocity_old.at(i).x;
		oldVelocityPixels[j + 1] = velocity_old.at(i).y;
		oldVelocityPixels[j + 2] = velocity_old.at(i).z;
	};
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, nrOfParticlesVertically*nrOfParticlesHorizontally, 1, 0, GL_RGB, GL_FLOAT, oldVelocityPixels);

	fboPos1 = initFBO(nrOfParticlesHorizontally, nrOfParticlesVertically, 0, particlePixels);
	fboPos2 = initFBO(nrOfParticlesHorizontally, nrOfParticlesVertically, 0, oldParticlePixels);
	fboVel1 = initFBO(nrOfParticlesHorizontally, nrOfParticlesVertically, 0, velocityPixels);
	fboVel2 = initFBO(nrOfParticlesHorizontally, nrOfParticlesVertically, 0, oldVelocityPixels);
	*/
//}

/*
void framebufferFunction()
{
	// Particle texture(Array)
	const size_t size = nrOfParticlesVertically*nrOfParticlesHorizontally ;
	float particlePixels[size];
	for (int i = 0; i < particle.size(); i++)
	{
		particlePixels[j] = particle.at(i);
	};
	/*void glTexImage1D(GLenum  target, GLint  level, GLint  internalFormat, GLsizei  width, GLint  border, GLenum  format, GLenum  type, const GLvoid *  data);
	target : Specifies the target texture. Must be GL_TEXTURE_1D or GL_PROXY_TEXTURE_1D.
	level : Specifies the level-of-detail number. Level 0 is the base image level. Level n is the nth mipmap reduction image.
	internalFormat : Specifies the number of color components in the texture. Must be 1, 2, 3, or 4, or one of the following symbolic constants: GL_ALPHA, GL_ALPHA4, GL_ALPHA8, GL_ALPHA12, GL_ALPHA16, GL_COMPRESSED_ALPHA, GL_COMPRESSED_LUMINANCE, GL_COMPRESSED_LUMINANCE_ALPHA, GL_COMPRESSED_INTENSITY, GL_COMPRESSED_RGB, GL_COMPRESSED_RGBA, GL_DEPTH_COMPONENT, GL_DEPTH_COMPONENT16, GL_DEPTH_COMPONENT24, GL_DEPTH_COMPONENT32, GL_LUMINANCE, GL_LUMINANCE4, GL_LUMINANCE8, GL_LUMINANCE12, GL_LUMINANCE16, GL_LUMINANCE_ALPHA, GL_LUMINANCE4_ALPHA4, GL_LUMINANCE6_ALPHA2, GL_LUMINANCE8_ALPHA8, GL_LUMINANCE12_ALPHA4, GL_LUMINANCE12_ALPHA12, GL_LUMINANCE16_ALPHA16, GL_INTENSITY, GL_INTENSITY4, GL_INTENSITY8, GL_INTENSITY12, GL_INTENSITY16, GL_R3_G3_B2, GL_RGB, GL_RGB4, GL_RGB5, GL_RGB8, GL_RGB10, GL_RGB12,	GL_RGB16, GL_RGBA, GL_RGBA2, GL_RGBA4, GL_RGB5_A1, GL_RGBA8, GL_RGB10_A2, GL_RGBA12, GL_RGBA16, GL_SLUMINANCE, GL_SLUMINANCE8,	GL_SLUMINANCE_ALPHA, GL_SLUMINANCE8_ALPHA8, GL_SRGB, GL_SRGB8, GL_SRGB_ALPHA, or GL_SRGB8_ALPHA8.
	width : Specifies the width of the texture image including the border if any. If the GL version does not support non-power-of-two sizes, this value must be 2^n + 2(border)	for some integer n. All implementations support texture images that are at least 64 texels wide. The height of the 1D texture image is 1.
	border : Specifies the width of the border.	Must be either 0 or 1.
	format : Specifies the format of the pixel data. The following symbolic values are accepted: GL_COLOR_INDEX, GL_RED, GL_GREEN, GL_BLUE, GL_ALPHA, GL_RGB, GL_BGR, GL_RGBA, GL_BGRA, GL_LUMINANCE, and GL_LUMINANCE_ALPHA.
	type : 	Specifies the data type of the pixel data. The following symbolic values are accepted: GL_UNSIGNED_BYTE, GL_BYTE, GL_BITMAP, GL_UNSIGNED_SHORT, GL_SHORT, GL_UNSIGNED_INT, GL_INT, GL_FLOAT, GL_UNSIGNED_BYTE_3_3_2, GL_UNSIGNED_BYTE_2_3_3_REV, GL_UNSIGNED_SHORT_5_6_5, GL_UNSIGNED_SHORT_5_6_5_REV, GL_UNSIGNED_SHORT_4_4_4_4, GL_UNSIGNED_SHORT_4_4_4_4_REV, GL_UNSIGNED_SHORT_5_5_5_1, GL_UNSIGNED_SHORT_1_5_5_5_REV, GL_UNSIGNED_INT_8_8_8_8, GL_UNSIGNED_INT_8_8_8_8_REV, GL_UNSIGNED_INT_10_10_10_2, and GL_UNSIGNED_INT_2_10_10_10_REV.
	data: Specifies a pointer to the image data in memory                
	*/
	/*glTexImage1D(GL_TEXTURE_1D, 0, 1, particle.size(), 0, GLenum  format, GLenum  type, particlePixels);


	//glGenFramebuffers returns n​ framebuffer object names in ids​
	const GLsizei N = 2;
	GLuint ids[] = { 0, 1 };
	glGenFramebuffers(N, ids);*/

	/*
	void glBindFramebuffer(GLenum target​, GLuint framebuffer​);
	target : Specifies the framebuffer target of the binding operation.
	framebuffer : Specifies the name of the framebuffer object to bind.

	glBindFramebuffer binds the framebuffer object with name framebuffer​ to the framebuffer target specified by target​.
	target​ must be either GL_DRAW_FRAMEBUFFER, GL_READ_FRAMEBUFFER or GL_FRAMEBUFFER.
	If a framebuffer object is bound to GL_DRAW_FRAMEBUFFER or GL_READ_FRAMEBUFFER, it becomes the target for rendering or readback operations, respectively, until it is deleted or another framebuffer is bound to the corresponding bind point.
	Calling glBindFramebuffer with target​ set to GL_FRAMEBUFFER binds framebuffer​ to both the read and draw framebuffer targets.
	framebuffer​ is the name of a framebuffer object previously returned from a call to glGenFramebuffers​, or zero to break the existing binding of a framebuffer object to target​.
	*/
	//glBindFramebuffer( GL_FRAMEBUFFER, ids[0]);

	/*
	void glFramebufferTexture1D(GLenum target​, GLenum attachment​, GLenum textarget​, GLuint texture​, GLint level​);
	target : Specifies the framebuffer target. target​ must be GL_DRAW_FRAMEBUFFER, GL_READ_FRAMEBUFFER, or GL_FRAMEBUFFER. GL_FRAMEBUFFER is equivalent to GL_DRAW_FRAMEBUFFER.
	attachment : Specifies the attachment point of the framebuffer. attachment​ must be GL_COLOR_ATTACHMENTi, GL_DEPTH_ATTACHMENT, GL_STENCIL_ATTACHMENT or GL_DEPTH_STENCIL_ATTACHMENT.
	textarget : For glFramebufferTexture1D, glFramebufferTexture2D and glFramebufferTexture3D, specifies what type of texture is expected in the texture​ parameter, or for cube map textures, which face is to be attached.​
	texture : Specifies the texture object to attach to the framebuffer attachment point named by attachment​, texture​ must be zero or the name of an existing texture with a target of textarget
	level : Specifies the mipmap level of texture​ to attach.
	*/
	//glFramebufferTexture1D​(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT1, GL_TEXTURE_1D, GLuint texture​, GLint level​);




	/*
	void glDeleteFramebuffers(GLsizei n​, GLuint *framebuffers​);
	n : Specifies the number of framebuffer objects to be deleted.
	framebuffers : A pointer to an array containing n​ framebuffer objects to be deleted.
	glDeleteFramebuffers deletes the n​ framebuffer objects whose names are stored in the array addressed by framebuffers​.
	*/

//}
