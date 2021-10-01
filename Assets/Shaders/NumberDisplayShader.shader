Shader "Custom/NumberDisplayShader"
{
    Properties {
        _MainTex("Texture", 2D) = "white" {}
        [HideInInspector]_MousePos("Mouse Position", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Pass
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "CharDisplayCommon.hlsl"
            #pragma target 4.0

            struct input
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            float2 _MousePos;

            v2f vert(input v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = v.uv;
                return o;
            } 

            float4 frag(v2f i) : SV_Target
            {
                float screenAspect = _MainTex_TexelSize.w / _MainTex_TexelSize.z;

                PRINT_NUMBER(_Time.y, i.uv, float2(0, 0), 0.03, screenAspect);
                PRINT_NUMBER(_MousePos, i.uv, _MousePos, 0.03, screenAspect);

                return float4(i.uv, 0, 1);
            }

            ENDHLSL
        }
    }
}
