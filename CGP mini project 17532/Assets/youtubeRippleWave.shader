Shader "Custom/youtubeRippleWave" {
	properties{
	_Color("Color", Color) = (1, 1, 1, 1)
		_SpecColor("Specular Color", Color) = (1, 1, 1, 1)
		_Shininess("Shininess", Float) = 10
		_Speed("Speed", float) = 1
		_Frequency("Frequency", float) = 1
		_Amplitude("amplitude", float) = 1
}
SubShader{
	Pass{
	CGPROGRAM

#pragma vertex vert
#pragma fragment frag
	//user defined
	uniform float4 _Color;
uniform float4 _SpecColor;
uniform float _Shininess;
uniform float _Speed;
uniform float _Frequency;
uniform float _Amplitude;
//unity defined
uniform float4 _LightColor0;

struct vertexInput {
	float4 vertex : POSITION;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;

};
struct vertexOutput {
	float4 pos : SV_POSITION;
	float4 posWorld : TEXCOORD0;
	float3 normalDir : TEXCOORD1;
	float4 tangentDir : TEXCOORD2;
	float4 col : Color;
};

vertexOutput vert(vertexInput v)
{
	vertexOutput o;

	float offset = ((v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z));
	float sinWave = _Amplitude * sin(_Time.w *_Speed + offset * _Frequency);

	v.vertex.y += sinWave;
	v.normal.y += sinWave;

	o.posWorld = mul(unity_ObjectToWorld, v.vertex);
	o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
	o.pos = UnityObjectToClipPos(v.vertex);

	o.col = float4(v.vertex.y, v.vertex.y, v.vertex.y, v.vertex.y);

	return o;
}

//fragment function
float4 frag(vertexOutput i) : COLOR
{
	float3 normalDirection = i.normalDir;
	float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
	float3 lightDirection;
	float atten = 1.0;

	//lighting
	lightDirection = normalize(_WorldSpaceLightPos0.xyz);
	float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
	float3 specularReflection = atten * _SpecColor.rgb * max(0.0, dot(normalDirection, lightDirection)) * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
	float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;

	return float4(lightFinal * _Color.rgb, 1.0);

}


ENDCG
}

}
FallBack "Diffuse"
}
