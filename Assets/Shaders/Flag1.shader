// nome do shader que aparece no material
Shader "Unlit/Flag1"
{
    Properties
    {
        /*Textura que aparece no material _nome nome da variavel
        ("coisa", tipo) nome que aparece no editor, tipo da variavel = inicialização*/
        _MainTex ("Texture", 2D) = "white" {}
    }
    
    // bloco de codigo que define o comportamento do shader
    SubShader
    {
        //Tags que definem o comportamento do shader
        Tags { "RenderType"="Opaque" }
        //define o lod deste shader para posterior uso(muito raro)
        LOD 100
        Cull off
        //Pass é uma instancia do shader (pode ter mais de uma)
        Pass
        {
            //Inicio do codigo do shader em CGPROGRAM(parecido com HLSL)
            CGPROGRAM
            //Vertex se refere a função que processa os vertices
            #pragma vertex vert
            //fragment se refere a função que processa os fragmentos
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                //variaveis de entrada da placa (semantica)
                // os tipos de semantica podem ser: POSITION, NORMAL, TEXTCOORD0, TEXTCOORD1, TEXTCOORD2, TEXTCOORD3, COLOR, TANGENT
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            /*struct que define os dados de saida do vertex shader e entrada do fragment shader. 
            TEXTCOORD0 é a semanticada variavel uv. 
            OS tipos podem ser TEXTCOORD0, TEXTCOORD1, TEXTCOORD2, TEXTCOORD3, COLOR, SV_POSITION, POSITION OU NORMAL*/
            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };
            // Define a textura do material
            //na unity o nome ser o msm do shader lab referencia a variavel automaticamente
            sampler2D _MainTex; 
            //variavek que define a transformação da textura
            //na unity o _ST referencia automaticamente ao parametro de Tiling e Offset do material
            float4 _MainTex_ST; 

            v2f vert (appdata vEnter)
            {
                v2f output;
               //output.vertex = UnityObjectToClipPos(v.vertex);
               float wave = _Time.y + vEnter.vertex.x;
               float4 flagOndulation = float4(0.0,cos(wave) * 0.5,0.0,0.0);
               float4 posPosition = vEnter.vertex + flagOndulation;
                output.vertex = UnityObjectToClipPos(posPosition);
                output.uv = TRANSFORM_TEX(vEnter.uv, _MainTex);
                UNITY_TRANSFER_FOG(output, output.vertex);
                return output;
            }

            fixed4 frag (v2f input) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, input.uv);
                
                // apply fog
                UNITY_APPLY_FOG(input.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
