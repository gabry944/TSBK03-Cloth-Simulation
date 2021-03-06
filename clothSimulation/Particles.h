#include <stdio.h>
#include <stdlib.h>
#include <glm/glm.hpp>
#include <vector>
#include <math.h>
#include <iostream>

using namespace std;

//-----------------------
// global constants 
//-----------------------

const int nrOfParticlesHorizontally = 16;
const int nrOfParticlesVertically = 16;
const float springRestLenght = 0.1f;
const float timestep = 0.0014f;
const float particleMass = 0.0005f;//0.011
const float k = 1000.0f;						 // spring konstant
const float c =5.0f;							 // damper constant
const glm::vec3 g = glm::vec3(0.f, -9.82f, 0.f); // gravity

const float kSt = 5;//80
const float kSh = 2;//60
const float kB = 1;//20
const float oaSt = springRestLenght;
const float oaSh = sqrt(2 * pow(oaSt, 2.0));
const float oaB = 2 * oaSt;
const float cSt = 0.05;//0.8
const float cSh = 0.02;//0.7
const float cB = 0.01;//0.6

//-----------------------
// function declarations 
//-----------------------

//Calculate the cloths position in the next frame using Eulermethod. Input is the cloths position in the current frame
void Euler(vector<glm::vec3> &particle, vector<glm::vec3> &particle_old, vector<glm::vec3> &velocity, vector<glm::vec3> &velocity_old, vector<int> staticParticles);

//Place a vector whith zeros, cloth velosity in its initial state.
vector<glm::vec3> placeZeros();

// Place the particles in a coordinate system, cloth in its initial state, the first particle in origo.
void placeParticles(vector<glm::vec3> &coordinates);

// Takes in a vector of Coordinates for each mass in the cloth and stores them in a new vector in the order they should be used as triangle corners when drawing the cloth.
vector<glm::vec3> MakeTriangles(vector<glm::vec3> C);

//norm = sqrt(x^2+y^2+x^2) 
float norm(glm::vec3 vec);

// add two coners to static points
void initializeStaticParticles(vector<int> &staticParticles);
