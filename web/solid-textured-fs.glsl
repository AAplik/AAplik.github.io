#version 300 es

precision highp float;

in vec4 texCoord;
in vec4 worldNormal;
in vec4 worldPosition;
in vec4 modelPosition;

uniform struct {
  sampler2D colorTexture; 
  samplerCube envTexture;
  vec3 lightWoodColor;
  vec3 darkWoodColor;
  float freq;
  float noiseFreq;
  float noiseExp;
  float noiseAmp;
} material;

uniform struct{
  mat4 viewProjMatrix; 	
  vec3 worldPosition; 
} camera;

out vec4 fragmentColor;

float snoise(vec3 r) {
  vec3 s = vec3(7502, 22777, 4767);
  float f = 0.0;
  for(int i=0; i<16; i++) {
    f += sin( dot(s - vec3(32768, 32768, 32768), r)
                                 / 65536.0);
    s = mod(s, 32768.0) * 2.0 + floor(s / 32768.0);
  }
  return f / 32.0 + 0.5;
}

void main(void) {
  //fragmentColor = texture(material.colorTexture, texCoord.xy/texCoord.w);
   float w = fract( modelPosition.x * material.freq
   		+ pow(snoise(modelPosition.xyz * material.noiseFreq), material.noiseExp)
   		* material.noiseAmp);

  vec3 color = mix( material.lightWoodColor,
			    					material.darkWoodColor, w);
  fragmentColor = vec4(color, 1.0);
}


