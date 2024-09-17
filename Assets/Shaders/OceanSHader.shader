Shader "Unlit/OceanSHader"
{
    Properties
    {
        _Color ("Color",color) = (1,1,1,1)
        _Normal ("Normal", 2D) = "white" {}
        _Strength ("Strength", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal: NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal: NORMAL;
            };

            sampler2D _Normal;
            float4 _Normal_ST;
            float4 _Color;
            float _Strength;

            v2f vert (appdata vEnter)
            {
                v2f o;
                _Strength = _Strength / 10;
               float wave = _Time.y + vEnter.vertex.x;
               float wave1 = _Time.y + vEnter.vertex.z;
               float4 flagOndulation = float4(0.0,cos(wave) * _Strength,0.0,0.0);
               float4 flagOndulation1 = float4(0.0,cos(wave1) * _Strength,0.0,0.0);
               float4 posPosition = vEnter.vertex + flagOndulation * flagOndulation1;
                o.vertex = UnityObjectToClipPos(posPosition);
                o.uv = TRANSFORM_TEX(vEnter.uv, _Normal);
                o.normal = vEnter.normal.xyz;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 lightDir = _WorldSpaceLightPos0.xyz;

                fixed4 norm = tex2D(_Normal,i.uv + _Time.xx);
                fixed4 norm2 = tex2D(_Normal,i.uv * 0.3 - _Time.xx);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, _Color);

                float bright = dot(i.normal * norm * norm2, lightDir);
               
                return _Color * bright * 10;
            }
            ENDCG
        }
    }
}
