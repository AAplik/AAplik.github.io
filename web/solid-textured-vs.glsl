 #version 300 es

in vec4 vertexPosition; //#vec4# A four-element vector [x,y,z,w].; We leave z and w alone.; They will be useful later for 3D graphics and transformations. #vertexPosition# attribute fetched from vertex buffer according to input layout spec
in vec4 vertexTexCoord;
in vec3 vertexNormal;

uniform struct{
  mat4 modelMatrix;
  mat4 modelMatrixInverse;  
} gameObject;

uniform struct{
  mat4 viewProjMatrix; 	
  vec3 worldPosition; 
} camera;

uniform struct {
  float time;
} scene;

out vec4 modelPosition;
out vec4 worldPosition;
out vec4 worldNormal;
out vec4 texCoord;

vec3 noiseGrad(vec3 r) {
  uvec3 s = uvec3(
    0x1D4E1D4E,
    0x58F958F9,
    0x129F129F);
  vec3 f = vec3(0, 0, 0);
  for(int i=0; i<16; i++) {
    vec3 sf = vec3(s & uvec3(0xFFFF)) / 65536.0 - vec3(0.5, 0.5, 0.5);
    
    f += cos(dot(sf, r)) * sf;
    s = s >> 1;
  }
  return f;
}


void main(void) {
  modelPosition = vertexPosition;
  worldPosition = vertexPosition * gameObject.modelMatrix;
  worldNormal = gameObject.modelMatrixInverse * vec4(vertexNormal, 0);
  gl_Position = worldPosition * camera.viewProjMatrix;
  texCoord = vertexTexCoord;
}