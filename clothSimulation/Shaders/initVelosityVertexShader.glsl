#version 150

in vec3 in_Position;
in vec2 in_TexCoord;

out vec3 Position;
out vec2 texCoord;

void main(void) {
    Position = in_Position;
    texCoord = in_TexCoord;

    gl_Position = vec4(Position, 1.0f);
	
}