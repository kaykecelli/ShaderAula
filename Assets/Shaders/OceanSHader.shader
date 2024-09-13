Shader "Unlit/OceanSHader"
{
    Properties
    {
        _Color ("Color",color) = (1,1,1,1)
        _Normal ("Normal", 2D) = "white" {}
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _Normal);
                o.normal = v.normal.xyz;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 lightDir = _WorldSpaceLightPos0.xyz;

                fixed4 norm = tex2D(_Normal,i.uv + _Time.xx);
                fixed4 norm2 = tex2D(_Normal,i.uv * 0.9 - _Time.xx);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, _Color);

                float bright = dot(i.normal * norm * norm2, lightDir);
               
                return _Color * bright * 10;
            }
            ENDCG
        }
    }
}
