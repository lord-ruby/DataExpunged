extern float darkness;
extern float radius;
extern float softness;

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);

    vec2 centered = texture_coords - 0.5;
    float dist = length(centered);
    float vignette = smoothstep(radius, radius + softness, dist);
    float finalIntensity = mix(darkness, 1.0, vignette);

    vec4 blackColor = vec4(vec3(0.0), 1.0);

    tex.rgb = mix(tex.rgb, blackColor.rgb, finalIntensity);
    
    return tex * colour;
}


//necessary to prevent crashes i believe
#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    return transform_projection * vertex_position;
    
}
#endif