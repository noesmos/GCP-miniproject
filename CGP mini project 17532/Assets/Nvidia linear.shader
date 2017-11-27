Shader "Custom/Nvidia linear" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		//_SpecColor("Specular Color", Color) = (1,1,1,1)
		//_Shininess("Shininess", Float) = 10
		_WaveLenght("Wave Lenght", float) = 1
		_Speed("Speed", float) = 1
		_Amplitude("amplitude", float) = 1
		_Steepness("steepness", range(0,1)) = 1
	}
		SubShader{

		Pass{
		Tags{ "LightMode" = "ForwardBase" }

		CGPROGRAM

#pragma vertex vert
#pragma fragment frag
		//user defined
		uniform float4 _Color;
	//uniform float4 _SpecColor;
	//uniform float _Shininess;
	uniform float _WaveLenght;
	uniform float _Speed;
	uniform float _Amplitude;
	uniform float _Steepness;
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
		float4 col : COLOR;
	};

	vertexOutput vert(vertexInput input)
	{
		vertexOutput output;

		float4 posWorld = mul(unity_ObjectToWorld, input.vertex); //maybe wrong

		float2 pos2d = float2	(posWorld.x, posWorld.z);

		float2 direc = normalize(float2(posWorld.x,posWorld.z));

		direc = normalize(float2(1, 1));

		//float dist = distance(posWorld, float4(0.0, 0.0, 0.0, 0.0));

		float  w = 2.0 * 3.1415 / _WaveLenght;

		float phase = _Speed * 2.0 * 3.1415 / _WaveLenght;

		//position vertices of waves
		float3 P = float3(posWorld.x,0.0,posWorld.z);

		P.x += _Steepness * _Amplitude * direc.x * cos(w * dot(direc, pos2d) + phase * _Time);
		P.y = _Amplitude * sin(w * dot(direc, pos2d) + phase * _Time);
		P.z += _Steepness * _Amplitude * direc.y * cos(w * dot(direc, pos2d) + phase * _Time);

		//normal vector
		float3 normalVector = float3(0, 0, 0);

		normalVector.x = -direc.x * w *_Amplitude * cos(w * dot(direc, pos2d) + phase * _Time);
		normalVector.y = 1 - _Steepness * w * _Amplitude * sin(w * dot(direc, pos2d) + phase * _Time);
		normalVector.z = -direc.y * w *_Amplitude * cos(w * dot(direc, pos2d) + phase * _Time);


		//diffuse lighting
		float4x4 modelMatrix = unity_ObjectToWorld;
		float4x4 modelMatrixInverse = unity_WorldToObject;

		float3 normalDirection = normalize(normalVector);
		float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

		float3 diffuseReflection = _LightColor0.rgb * _Color.rgb
			* max(0.0, dot(normalDirection, lightDirection));

		output.col = float4(diffuseReflection, 1.0);
		output.pos = mul(UNITY_MATRIX_VP, float4(P, 1));
		//UnityObjectToClipPos(float4(P,1));
		return output;
	}

	//fragment function
	float4 frag(vertexOutput i) : COLOR
	{
		return i.col;
	}


		ENDCG
	}

		Pass{
		Tags{ "LightMode" = "ForwardAdd" }
		Blend One One


		CGPROGRAM

#pragma vertex vert
#pragma fragment frag
		//user defined
		uniform float4 _Color;
	uniform float4 _SpecColor;
	uniform float _Shininess;
	uniform float _WaveLenght;
	uniform float _Speed;
	uniform float _Amplitude;
	uniform float _Steepness;
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
		float4 col : COLOR;
	};

	vertexOutput vert(vertexInput input)
	{
		vertexOutput output;

		float4 posWorld = mul(unity_ObjectToWorld, input.vertex); //maybe wrong

		float2 pos2d = float2(posWorld.x, posWorld.z);

		float2 direc = normalize(float2(posWorld.x,posWorld.z));

		direc = normalize(float2(1,1));

		//float dist = distance(posWorld, float4(0.0, 0.0, 0.0, 0.0));

		float  w = 2.0 * 3.1415 / _WaveLenght;

		float phase = _Speed * 2.0 * 3.1415 / _WaveLenght;

		//position vertices of waves
		float3 P = float3(posWorld.x,0.0,posWorld.z);

		P.x += _Steepness * _Amplitude * direc.x * cos(w * dot(direc, pos2d) + phase * _Time);
		P.y = _Amplitude * sin(w * dot(direc, pos2d) + phase * _Time);
		P.z += _Steepness * _Amplitude * direc.y * cos(w * dot(direc, pos2d) + phase * _Time);

		//normal vector
		float3 normalVector = float3(0, 0, 0);

		normalVector.x = -direc.x * w *_Amplitude * cos(w * dot(direc, pos2d) + phase * _Time);
		normalVector.y = 1 - _Steepness * w * _Amplitude * sin(w * dot(direc, pos2d) + phase * _Time);
		normalVector.z = -direc.y * w *_Amplitude * cos(w * dot(direc, pos2d) + phase * _Time);


		//diffuse lighting
		float4x4 modelMatrix = unity_ObjectToWorld;
		float4x4 modelMatrixInverse = unity_WorldToObject;

		float3 normalDirection = normalize(normalVector);
		float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

		float3 diffuseReflection = _LightColor0.rgb * _Color.rgb
			* max(0.0, dot(normalDirection, lightDirection));

		output.col = float4(diffuseReflection, 1.0);
		output.pos = mul(UNITY_MATRIX_VP, float4(P, 1));
		//UnityObjectToClipPos(float4(P,1));
		return output;
	}

	//fragment function
	float4 frag(vertexOutput i) : COLOR
	{
		return i.col;
	}


		ENDCG
	}

	}
		FallBack "Diffuse"
}
