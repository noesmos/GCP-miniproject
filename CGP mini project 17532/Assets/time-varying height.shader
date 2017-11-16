Shader "Custom/time-varying height" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_SpecColor("Specular Color", Color) = (1,1,1,1)
		_Shininess("Shininess", Float) = 10
		_WaveLenght("Wave Lenght", float) = 1
		_Period("Period", float) = 1
		_Amplitude("amplitude", float) = 1
		_RunTime("RunTime", float)= 0
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
	uniform float _WaveLenght;
	uniform float _Period;
	uniform float _Amplitude;
	uniform float _RunTime;
	//unity defined
	uniform float4 _LightColor0;

	struct vertexInput {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 posWorld : TEXCOORD0;
		float3 normalDir : TEXCOORD1;
		float4 col : Color;
	};

	vertexOutput vert(vertexInput v)
	{
		vertexOutput o;

		float dist = distance(mul(unity_ObjectToWorld, v.vertex), float4(0.0, 0.0, 0.0, 1.0));

		//time-varying

		float waterHeight = _Amplitude * cos((2 * 3.14f * _CosTime) / _Period);
		float symmetricWave = _Amplitude * cos((dist * 2 * _CosTime) / _WaveLenght);
		
		v.vertex.y += waterHeight + symmetricWave;
		v.normal.y += waterHeight + symmetricWave;


		////attempt to change normal vectors
		//float calculation = ((dist / _WaveLenght) + (_Time / _Period)) * 2 * 3.14f;

		//float hpst = _Amplitude * cos(calculation);
		//float ddshpst = -(_Amplitude * 2 * (3.14f / _WaveLenght) * sin(calculation));
		//v.normal = normalize(float3(-ddshpst, hpst, 0));


		o.posWorld = mul(unity_ObjectToWorld, v.vertex);
		o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
		o.pos = UnityObjectToClipPos(v.vertex);

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
		//float3 specularReflection = atten * _SpecColor.rgb * max(0.0, dot(normalDirection, lightDirection)) * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
		float3 lightFinal = diffuseReflection +  UNITY_LIGHTMODEL_AMBIENT;

		return float4(lightFinal * _Color.rgb, 1.0);

		return _Color;

	}


		ENDCG
	}

	}
		FallBack "Diffuse"
}
