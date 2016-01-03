#include "Helper.h"
#include <chrono>//tidsmätning

/*************************
* Use the GPGPU Shader  *
*************************/
void calculateNextPos(vector<glm::vec3> &particle, FBOstruct *fboPos, FBOstruct *fboOldPos, FBOstruct *fboVel, FBOstruct *fboOldVel, GLuint velocityEulerShader, GLuint pass, GLuint PositionEulerShader)
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

	
	glUseProgram(velocityEulerShader);

	use2FBO(fboVel, fboOldVel, fboOldPos, velocityEulerShader);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	//send shared varible to shader, only need to be done the first time
	glUniform1f(glGetUniformLocation(velocityEulerShader, "nrOfParticlesVertically"), nrOfParticlesVertically);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "nrOfParticlesHorizontally"), nrOfParticlesHorizontally);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "timestep"), timestep);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "particleMass"), particleMass);
	glUniform3f(glGetUniformLocation(velocityEulerShader, "g"), g.x, g.y, g.z);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "kSt"), kSt);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "kSh"), kSh);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "kB"), kB);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "oaSt"), oaSt);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "oaSh"), oaSh);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "oaB"), oaB);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "cSt"), cSt);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "cSh"), cSh);
	glUniform1f(glGetUniformLocation(velocityEulerShader, "cB"), cB);	

	DrawModel(squareModel, velocityEulerShader, "in_Position", NULL, "in_TexCoord");

	
	glUseProgram(pass);
	useFBO(fboOldVel, fboVel, 0L); //MÅSTE VARA PÅ VÄNSTER SIDA!!!!!
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	DrawModel(squareModel, pass, "in_Position", NULL, "in_TexCoord");

	//old position is updated to current position
	useFBO(fboOldPos, fboPos, 0L); 
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	DrawModel(squareModel, pass, "in_Position", NULL, "in_TexCoord");
	
	//current position is updated to new position, need currnt position therfor updated ond position first
	glUseProgram(PositionEulerShader);

	use2FBO(fboPos, fboVel, fboOldPos, PositionEulerShader);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glUniform1f(glGetUniformLocation(PositionEulerShader, "timestep"), timestep);
	DrawModel(squareModel, PositionEulerShader, "in_Position", NULL, "in_TexCoord");

	const size_t SIZE = nrOfParticlesVertically*nrOfParticlesHorizontally * 4;
	float particlePixels[SIZE];
	glReadPixels(0, 0, nrOfParticlesVertically*nrOfParticlesHorizontally, 1, GL_RGBA, GL_FLOAT, particlePixels);


	for (int i = 0, j = 0; i < particle.size(); i++, j += 4)
	{
		//cout << "Position vector: " << particlePixels[j] << " " << particlePixels[j + 1] << " " << particlePixels[j + 2] << endl;
		particle.at(i).x = particlePixels[j];
		particle.at(i).y = particlePixels[j + 1];
		particle.at(i).z = particlePixels[j + 2];
	};
}

void calculateNextPos2(vector<glm::vec3> &particle, FBOstruct *fboPos, FBOstruct *fboOldPos, FBOstruct *fboVel, FBOstruct *fboOldVel, Model* squareModel, GLuint velocityEulerShader, GLuint pass, GLuint PositionEulerShader)
{	
	ReloadModelData(squareModel);
	
	//update old velosity
	glUseProgram(pass);
	useFBO(fboOldVel, fboVel, 0L);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	DrawModel(squareModel, pass, "in_Position", NULL, "in_TexCoord");

	//old position is updated to current position
	glUseProgram(pass);
	useFBO(fboOldPos, fboPos, 0L);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	DrawModel(squareModel, pass, "in_Position", NULL, "in_TexCoord");

	//update velosity
	glUseProgram(velocityEulerShader);
	use2FBO(fboVel, fboOldVel, fboOldPos, velocityEulerShader);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	
	DrawModel(squareModel, velocityEulerShader, "in_Position", NULL, "in_TexCoord");
		
	//current position is updated to new position, need currnt position therfor updated old position first
	glUseProgram(PositionEulerShader);
	use2FBO(fboPos, fboVel, fboOldPos, PositionEulerShader);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	DrawModel(squareModel, PositionEulerShader, "in_Position", NULL, "in_TexCoord");

	// position vector is updated
	const size_t SIZE = nrOfParticlesVertically*nrOfParticlesHorizontally * 4;
	float particlePixels[SIZE];
	glReadPixels(0, 0, nrOfParticlesVertically*nrOfParticlesHorizontally, 1, GL_RGBA, GL_FLOAT, particlePixels);
	for (int i = 0, j = 0; i < particle.size(); i++, j += 4)
	{
		//cout << "Position vector: " << particlePixels[j] << " " << particlePixels[j + 1] << " " << particlePixels[j + 2] << endl;
		particle.at(i).x = particlePixels[j];
		particle.at(i).y = particlePixels[j + 1];
		particle.at(i).z = particlePixels[j + 2];
	};
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


	GLuint initVelosity = loadShaders("Shaders/initVelocityVertexShader.glsl", "Shaders/initVelocityFragmentShader.glsl");
	GLuint passOverValues = loadShaders("Shaders/passVertexShader.glsl", "Shaders/passFragmentShader.glsl");
	GLuint initPosition = loadShaders("Shaders/initPositionVertexShader.glsl", "Shaders/initPositionFragmentShader.glsl");

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

	//test so everything whent fine
	//const size_t SIZE = nrOfParticlesVertically*nrOfParticlesHorizontally * 4;
	//float particlePixels[SIZE];
	/*glReadPixels(0, 0, nrOfParticlesVertically*nrOfParticlesHorizontally, 1, GL_RGBA, GL_FLOAT, particlePixels);
	for (int j = 0; j < SIZE; j += 4)
	{
		cout << " Init velosity: " << particlePixels[j] << "  " << particlePixels[j + 1] << "  " << particlePixels[j + 2] << "  " << particlePixels[j + 3] << endl;
	}*/

	/***************
	* Position FBO *
	****************/
	useFBO(fboPos, 0L, 0L);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glUseProgram(initPosition);

	locHeight = glGetUniformLocation(initPosition, "height");
	locWidth = glGetUniformLocation(initPosition, "width");
	GLint locSpringLenght = glGetUniformLocation(initPosition, "springRestLenght");
	if (locHeight != -1 && locWidth != -1 && locSpringLenght != -1)
	{
		glUniform1f(locWidth, nrOfParticlesHorizontally);
		glUniform1f(locHeight, nrOfParticlesVertically);
		glUniform1f(locSpringLenght, springRestLenght);
	}

	DrawModel(squareModel, initPosition, "in_Position", NULL, "in_TexCoord");

	/******************************************************
	* Old Position                                       *
	* The same sa position, so just pass over the values *
	******************************************************/
	
	useFBO(fboOldPos, fboPos, 0L);
	glClearColor(0.0, 0.0, 0.0, 0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glUseProgram(passOverValues);

	DrawModel(squareModel, passOverValues, "in_Position", NULL, "in_TexCoord");

}

