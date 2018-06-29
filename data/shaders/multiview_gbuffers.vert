#version 450

#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable
#extension GL_EXT_multiview : enable

#define MAX_BONES 511

layout (location = 0) in vec3 inPos;
layout (location = 1) in vec3 inNormal;
layout (location = 2) in vec3 inTangent;
layout (location = 3) in vec3 inUV;
layout (location = 4) in float inBoneWeight;
layout (location = 5) in float inBoneIndex;

struct Camera
{
  mat4 viewMatrix;
  mat4 viewMatrixInverse;
  mat4 projectionMatrix;
  vec4 observerPosition;
  vec4 params;
};

struct MaterialTypeDefinition
{
  uint variantFirst;
  uint variantSize;
};

struct MaterialVariantDefinition
{
  uint materialFirst;
  uint materialSize;
};

layout (binding = 0) uniform CameraUbo
{
  Camera cam[2];
} cameras;

layout (binding = 1) uniform PositionSbo
{
  mat4  position;
  mat4  bones[MAX_BONES];
  uint  typeID;
} object;

layout (std430,binding = 2) readonly buffer MaterialTypesSbo
{
  MaterialTypeDefinition materialTypes[];
};

layout (std430,binding = 3) readonly buffer MaterialVariantsSbo
{
  MaterialVariantDefinition materialVariants[];
};

layout (location = 0) out vec3 outNormal;
layout (location = 1) out vec3 outTangent;
layout (location = 2) out vec2 outUV;
layout (location = 3) out vec4 outPosition;
layout (location = 4) flat out uint materialID;

void main() 
{
  mat4 boneTransform = object.bones[int(inBoneIndex)] * inBoneWeight;
  mat4 modelMatrix = object.position * boneTransform;

  outPosition    = modelMatrix * vec4(inPos.xyz, 1.0);
  gl_Position    = cameras.cam[gl_ViewIndex].projectionMatrix * cameras.cam[gl_ViewIndex].viewMatrix * outPosition;
  outPosition    /= outPosition.w;
  mat3 normalMat = mat3(inverse(transpose(modelMatrix)));
  outNormal      = normalize(normalMat * inNormal);
  outTangent     = normalize(normalMat * inTangent);
  outUV          = inUV.xy;
	
  materialID     = materialVariants[materialTypes[object.typeID].variantFirst + 0].materialFirst + uint(inUV.z);
}
