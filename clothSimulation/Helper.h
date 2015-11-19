#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp> // incude frustum
#include <glm/gtc/type_ptr.hpp> 

void printError(const char *functionName);
GLuint loadShaders(const char *vertFileName, const char *fragFileName);
GLuint loadShadersG(const char *vertFileName, const char *fragFileName, const char *geomFileName);
GLuint loadShadersGT(const char *vertFileName, const char *fragFileName, const char *geomFileName,
	const char *tcFileName, const char *teFileName);
void dumpInfo(void);


typedef struct
{
	GLuint texid;
	GLuint fb;
	GLuint rb;
	GLuint depth;
	int width, height;
} FBOstruct;

FBOstruct *initFBO(int width, int height, int int_method);
FBOstruct *initFBO(int width, int height, int int_method, float* textureArray);
void useFBO(FBOstruct *out, FBOstruct *in1, FBOstruct *in2);



//loadobj
typedef struct
{
	GLfloat* vertexArray;
	GLfloat* normalArray;
	GLfloat* texCoordArray;
	GLfloat* colorArray; // Rarely used
	GLuint* indexArray;
	int numVertices;
	int numIndices;

	// Space for saving VBO and VAO IDs
	GLuint vao; // VAO
	GLuint vb, ib, nb, tb; // VBOs
} Model;

void DrawModel(Model *m, GLuint program, char* vertexVariableName, char* normalVariableName, char* texCoordVariableName);
Model* LoadDataToModel(
	GLfloat *vertices,
	GLfloat *normals,
	GLfloat *texCoords,
	GLfloat *colors,
	GLuint *indices,
	int numVert,
	int numInd);


