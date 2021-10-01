// Font (Teeny Tiny Pixls) Reference: https://chequered.ink/july-round-up/
// This font is for personal use only!

static const uint _FontChar[128] = 
{
        0,     0,     0,     0,     0,     0,     0,     0,
        0,     0,     0,     0,     0,     0,     0,     0,
        0,     0,     0,     0,     0,     0,     0,     0,
        0,     0,     0,     0,     0,     0,     0,     0,
        0,  9346, 23040, 24445, 14478, 21157, 27111,  9216,
    10530, 17556, 11944,  1488,    18,   448,     2,  5284,
    31599, 25751, 29671, 29647, 23497, 31183, 31215, 31305,
    31727, 31689,  1040,  1042,  5393,  3640, 17492, 29378,
    31591, 31725, 31663, 31015, 27502, 31207, 31204, 31087,
    23533, 29847,  4719, 23469, 18727, 24429, 31597,  31599,
    31716, 31605, 31661, 31183, 29842, 23407, 23402, 23421,
    23213, 23506, 29351, 26918, 17545, 25750, 10752,     7,
    17408,  1899, 20335,  3879,  8047,  1907,  5586,  3422,
    20333,  8343,  8342, 19373, 25747,  3053,  3949,  3951,
     3964,  3961,  3876,  1950,  1491,  2927,  2922,  2941,
     2733,  2937,  3815, 13715,  9362, 25814,   992,     0
};


#define PRINT_CHAR(ch, uv, uvMins, size, screenAspect) {\
float __CHAR_TMP__ = print_char(ch, uv, uvMins, size, screenAspect); \
if (__CHAR_TMP__ > 0.01) return __CHAR_TMP__; }

#define PRINT_NUMBER_FLOAT(num, uv, uvMins, size, screenAspect) {\
float __NUM_TMP__ = print_number_float(num, uv, uvMins, size, screenAspect); \
if (__NUM_TMP__ > 0.01) return __NUM_TMP__; }

#define PRINT_NUMBER(num, uv, uvMins, size, screenAspect) {\
float __NUM_TMP__ = print_number(num, uv, uvMins, size, screenAspect); \
if (__NUM_TMP__ > 0.01) return __NUM_TMP__; }


#define SHIFT_UV(xx) uvMins += float2(size * 0.8f * screenAspect * xx, 0);

float print_char(int char, float2 uv, float2 uvMins, float size, float screenAspect)
{
    if (char < 0 || char > 128)
        return 0;
    int2 idxP = floor((uv - uvMins) / float2(size * 0.6f * screenAspect, size) * float2(3, 5));
    if (idxP.x >= 0 && idxP.x < 3 && idxP.y >= 0 && idxP.y < 5)
    {
        int idx = (2 - idxP.x) + idxP.y * 3;
        return (_FontChar[char] >> idx) % 2;
    }
    return 0;
}

float print_string(int char[32], float2 uv, int strLength, float2 uvMins, float size, float screenAspect)
{
    for (int i = 0; i < strLength; i++)
    {
        PRINT_CHAR(char[i], uv, uvMins, size, screenAspect);
        SHIFT_UV(1);
    }
    return 0;
}

float print_number_int(int num, float2 uv, float2 uvMins, float size, float screenAspect)
{
    if (num < 0)
    {
        PRINT_CHAR('-', uv, uvMins, size, screenAspect);
        SHIFT_UV(1);
        num = -num;
    }
    int digits = 0, num2 = num;
    [unroll(32)]
    while (num2 > 0)
    {
        digits++;
        num2 /= 10;
    }

    int k = 1;
    if (num == 0)
        digits = 1;
    
    SHIFT_UV((digits - 1));
    [unroll(32)]
    for (int i = 0; i < digits; i++)
    {
        int d = (num / k) % 10;
        PRINT_CHAR(d + '0', uv, uvMins, size, screenAspect);
        SHIFT_UV(-1);
        k*=10;
    }
    return 0;
}

// default to 2 decimals
float print_number_float(float num, float2 uv, float2 uvMins, float size, float screenAspect)
{
    int num_int = (int)num;

    // int section
    if (num < 0)
    {
        PRINT_CHAR('-', uv, uvMins, size, screenAspect);
        SHIFT_UV(1);
        num_int = -num_int;
        num = -num;
    }
    int digits = 0, num2 = num_int;
    [unroll(32)]
    while (num2 > 0)
    {
        digits++;
        num2 /= 10;
    }

    int k = 1;
    if (num_int == 0)
        digits = 1;

    
    SHIFT_UV((digits - 1));
    [unroll(32)]
    for (int i = 0; i < digits; i++)
    {
        int d = (num_int / k) % 10;
        PRINT_CHAR(d + '0', uv, uvMins, size, screenAspect);
        SHIFT_UV(-1);
        k*=10;
    }

    SHIFT_UV((digits + 1));
    PRINT_CHAR('.', uv, uvMins, size, screenAspect);
    SHIFT_UV(1);

    float num_decimal = frac(num);
    [unroll(32)]
    for (int i2 = 0; i2 < 2; i2++)
    {
        int d = (int)(num_decimal * 10);
        num_decimal = frac(num_decimal * 10);
        PRINT_CHAR(d + '0', uv, uvMins, size, screenAspect);
        SHIFT_UV(1);
    }
    return 0;
    // float section
}

int get_length_int(int num)
{
    int digits = 0;
    if (num == 0)
        return 1;
    if (num < 0)
    {
        digits++;
        num = -num;
    }
    while (num > 0)
    {
        digits++;
        num /= 10;
    }
    return digits;
}

int get_length_float(float num)
{
    int k = (int)num;
    if (num > -1 && num < 0)
    {
        return get_length_int(k) + 4;
    }
    return get_length_int(k) + 3;
}

float print_number_float2(float2 v, float2 uv, float2 uvMins, float size, float screenAspect)
{
    PRINT_CHAR('(', uv, uvMins, size, screenAspect);
    SHIFT_UV(1);

    PRINT_NUMBER_FLOAT(v.x, uv, uvMins, size, screenAspect);
    SHIFT_UV(get_length_float(v.x));
    
    PRINT_CHAR(',', uv, uvMins, size, screenAspect);
    SHIFT_UV(1);
    
    PRINT_NUMBER_FLOAT(v.y, uv, uvMins, size, screenAspect);
    SHIFT_UV(get_length_float(v.y));
    
    PRINT_CHAR(')', uv, uvMins, size, screenAspect);
    
    return 0;
}

float print_number_float3(float3 v, float2 uv, float2 uvMins, float size, float screenAspect)
{
    PRINT_CHAR('(', uv, uvMins, size, screenAspect);
    SHIFT_UV(1);

    PRINT_NUMBER_FLOAT(v.x, uv, uvMins, size, screenAspect);
    SHIFT_UV(get_length_float(v.x));
    
    PRINT_CHAR(',', uv, uvMins, size, screenAspect);
    SHIFT_UV(1);
    
    PRINT_NUMBER_FLOAT(v.y, uv, uvMins, size, screenAspect);
    SHIFT_UV(get_length_float(v.y));
    
    PRINT_CHAR(',', uv, uvMins, size, screenAspect);
    SHIFT_UV(1);
    
    PRINT_NUMBER_FLOAT(v.z, uv, uvMins, size, screenAspect);
    SHIFT_UV(get_length_float(v.z));
    
    PRINT_CHAR(')', uv, uvMins, size, screenAspect);
    
    return 0;
}

float print_number_float4(float4 v, float2 uv, float2 uvMins, float size, float screenAspect)
{
    PRINT_CHAR('(', uv, uvMins, size, screenAspect);
    SHIFT_UV(1);

    PRINT_NUMBER_FLOAT(v.x, uv, uvMins, size, screenAspect);
    SHIFT_UV(get_length_float(v.x));
    
    PRINT_CHAR(',', uv, uvMins, size, screenAspect);
    SHIFT_UV(1);
    
    PRINT_NUMBER_FLOAT(v.y, uv, uvMins, size, screenAspect);
    SHIFT_UV(get_length_float(v.y));
    
    PRINT_CHAR(',', uv, uvMins, size, screenAspect);
    SHIFT_UV(1);
    
    PRINT_NUMBER_FLOAT(v.z, uv, uvMins, size, screenAspect);
    SHIFT_UV(get_length_float(v.z));

    PRINT_CHAR(',', uv, uvMins, size, screenAspect);
    SHIFT_UV(1);
    
    PRINT_NUMBER_FLOAT(v.w, uv, uvMins, size, screenAspect);
    SHIFT_UV(get_length_float(v.w));
    
    PRINT_CHAR(')', uv, uvMins, size, screenAspect);
    return 0;
}

float print_number(float num, float2 uv, float2 uvMins, float size, float screenAspect)
{
    return print_number_float(num, uv, uvMins, size, screenAspect);
}

float2 print_number(float2 num, float2 uv, float2 uvMins, float size, float screenAspect)
{
    return print_number_float2(num, uv, uvMins, size, screenAspect);
}

float3 print_number(float3 num, float2 uv, float2 uvMins, float size, float screenAspect)
{
    return print_number_float3(num, uv, uvMins, size, screenAspect);
}

float4 print_number(float4 num, float2 uv, float2 uvMins, float size, float screenAspect)
{
    return print_number_float4(num, uv, uvMins, size, screenAspect);
}