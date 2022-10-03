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


vec3 shade(
  vec3 normal, vec3 lightDir, vec3 viewDir,
  vec3 powerDensity, vec3 materialColor, vec3 specularColor, float shininess) {

  float cosa = clamp( dot(lightDir, normal), 0.0, 1.0);
  float cosb = clamp(dot(viewDir, normal), 0.0, 1.0);

  vec3 halfway = normalize(viewDir + lightDir);
  float cosDelta = clamp(dot(halfway, normal), 0.0, 1.0);

  return
    powerDensity * materialColor * cosa 
  + powerDensity * specularColor * pow(cosDelta, shininess) 
  * cosa / max(cosb, cosa);
}



void main(void) {
  
  vec3 normal = normalize(worldNormal.xyz);
  vec3 viewDir = camera.worldPosition - worldPosition.xyz/worldPosition.w;

  /*
  vec3 radience = vec3(0,0,0);
  for(int iLight = 0; iLight < 1; iLight++){
    vec3 lightDir = lights[iLight].position.xyz;
    vec3 powerDensity = lights[iLight].powerDensity;
    float cosa = clamp(dot(normal, lightDir), 0.0, 1.0);
    radience += texture(material.colorTexture, texCoord.xy/texCoord.w).rgb * cosa * powerDensity;
  }
  fragmentColor = vec4(radience, 1.0);
  */
  

  // SPECULAR 
  
  vec3 materialColor = texture(material.colorTexture, texCoord.xy/texCoord.w).rgb;
  vec3 specularColor = vec3(1.0f, 1.0f, 1.0f);
  float shininess = 10.0;


  vec3 radience = vec3(0.0,0.0,0.0);

  // point light enabled
  for(int i = 0; i < 1; i++){
   vec3 lightDiff = lights[i].position.xyz - worldPosition.xyz * lights[i].position.w;
   vec3 lightDir = normalize(lightDiff);
   float distanceSquared = dot(lightDiff, lightDiff);
   vec3 powerDensity = lights[i].powerDensity / distanceSquared;
    

    float cosa = clamp(dot(lightDir, normal), 0.0, 1.0);
    float cosb = clamp(dot(viewDir, normal), 0.0, 1.0);

    vec3 halfway = normalize(viewDir + lightDir);
    float cosDelta = clamp(dot(halfway, normal), 0.0, 1.0);
    
    radience += powerDensity * materialColor * cosa + powerDensity * specularColor * pow(cosDelta, shininess) * cosa / max(cosb, cosa);
  }
  fragmentColor = vec4(radience, 1.0);

  

}

