#version 300 es

precision highp float;

in vec4 texCoord;
in vec4 worldNormal;
in vec4 worldPosition;

uniform struct {
  sampler2D colorTexture; 
  samplerCube envTexture;
} material;

uniform struct{
  mat4 viewProjMatrix; 
  vec3 worldPosition; 
} camera;

uniform struct{
  vec4 position;
  vec3 powerDensity;
} lights[8];

out vec4 fragmentColor;


void main(void) {
  vec3 normal = normalize(worldNormal.xyz);
  fragmentColor = texture(material.colorTexture, texCoord.xy/texCoord.w);
  vec3 viewDir = camera.worldPosition - worldPosition.xyz/worldPosition.w;
  vec3 reflDir = refract(-viewDir, normal, 0.15f);
  fragmentColor = texture(material.envTexture, reflDir);


  //MIRROR
  //vec3 normal = normalize(worldNormal.xyz);
  //fragmentColor = texture(material.colorTexture, texCoord.xy/texCoord.w); //UNCOMMENT
  //vec3 viewDir = camera.position - worldPosition.xyz/worldPosition.w;
  //vec3 reflDir = reflect(-viewDir, normal);
  //fragmentColor = texture(material.envTexture, reflDir);
}

