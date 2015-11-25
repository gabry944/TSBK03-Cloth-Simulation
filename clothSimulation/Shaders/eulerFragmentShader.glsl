#version 150

in vec3 Position;
in vec2 texCoord;

uniform sampler2D tex;

out vec4 Out_Color;

void main(void) {
  
  vec2 cord = texCoord;
  vec4 c = texture(tex, cord);
  /*c.r = 1337;
  c.g = 1337;
  c.b = 1337;*/
  //Out_Color = c;

  
  float value = clamp(texture(tex, texCoord).r, 1.0, 10.0);
  Out_Color = vec4(value, value, value, 1.0);


/*
  float texStep = 1.0 / 512.0;
  vec2 cord = texCoord;

  vec4 c = texture(tex, cord);
  cord.y = cord.y + texStep;
  vec4 l = texture(tex, cord);
  cord.y = cord.y - 2.0* texStep;
  vec4 r = texture(tex, cord);
  cord.y = cord.y - texStep;
  vec4 k = texture(tex, cord);

  Out_Color = ( c + l + r + k) * 0.30;
  /*
  /*
  float texStep = 1.0 / 512.0;

  vec3 filter = vec3(1.0, 2.0, 1.0);

  float value = (texture(tex, vec2(texCoord.s, texCoord.t - texStep)) * filter.x +
		 texture(tex, vec2(texCoord.s , texCoord.t)) * filter.y + 
		 texture(tex, vec2(texCoord.s, texCoord.t + texStep)) * filter.z) / 3.8;

  //filtrera med lågpassfilter
  Out_Color = vec4(value, value, value, 1.0) ;*/

}