extern float iTime;
extern float intensity;
extern float speed;
extern float size;

float PHI = 1.61803398874989484820459;

float rand(vec2 co)
{
    float t = floor(iTime * speed);
    return fract(tan(distance(co*PHI, co)*t)*co.x);
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);

    vec2 quantized = floor(screen_coords / size);

    float noise = rand(quantized);
    vec4 staticColor = vec4(vec3(noise), 1.0);

    tex.rgb = mix(tex.rgb, staticColor.rgb, intensity);
    

    return tex * colour;
}


//necessary to prevent crashes i believe
#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    return transform_projection * vertex_position;
    
}
#endif