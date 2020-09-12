Shader "Unlit/Outline"
{
    Properties
    {
        _Color("Main Color",Color)=(1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor("Outline color",Color) = (0,0,0,1)
        _OutlineThickness("Outline thickness",Range(1.0,5.0)) = 1.01
        _OutlineAlphaMin("Minimum outline alpha",Range(0.0,1.0)) = 0
        _OutlineAlphaMax("Maximum outline alpha",Range(0.0,1.0)) = 1
        _OutlineAlphaLerp("Outline alpha lerp",Range(0.0,1.0)) = 1
        [Toggle]_OutlineUseFrequency("Use Frequency",Float) = 1
        _OutlineAlphaFrequency("Outline alpha frequency",Float) = 100
    }

    CGINCLUDE
    #include "UnityCG.cginc"
    
    struct appdata 
    {
        float4 vertex:POSITION;
        float3 normal:NORMAL;
    };

    struct v2f
    {
        float4 position:POSITION;
        float3 normal:NORMAL;
    };
    
    float4 _OutlineColor;
    float _OutlineThickness;
    float _OutlineAlphaLerp;
    float _OutlineAlphaFrequency;
    float _OutlineAlphaMin;
    float _OutlineAlphaMax;
    float _OutlineUseFrequency;

    v2f vert(appdata v)
    {
        v.vertex.xyz *= _OutlineThickness;

        v2f o;
        o.position = UnityObjectToClipPos(v.vertex);
        return o;
    }
    ENDCG

    SubShader
    {
        Tags {"Queue" = "Transparent+1" }
        Pass // RENDER THE OUTLINE FIRST
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            half4 frag(v2f i) :COLOR
            {
                float4 c =_OutlineColor;
                float lerp = abs(_OutlineAlphaMax - _OutlineAlphaMin) * _OutlineAlphaLerp + _OutlineAlphaMin;
                c.a = (1-_OutlineUseFrequency)*lerp + _OutlineUseFrequency*abs(abs(_OutlineAlphaMax - _OutlineAlphaMin)*cos(_OutlineAlphaFrequency * _Time));
                c.a = max(c.a, _OutlineAlphaMin);
                c.a = min(c.a, _OutlineAlphaMax);
                return c;
            }

            ENDCG
        }

        Pass //NORMAL RENDER
        {
            ZWrite On
            Material
            {
                Diffuse[_Color]
                Ambient[_Color]
            }

            Lighting On

            SetTexture[_MainTex]
            {
                ConstantColor[_Color]
            }

            SetTexture[_MainTex]
            {
                Combine previous * primary DOUBLE
            }
            
        }
    }
}
