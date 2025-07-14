varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;
uniform float u_intensity; // 0.0 to 1.0

void main()
{
    vec2 uv = v_vTexcoord;

    // horizontal wave distortion
    uv.x += sin(uv.y * 20.0 + u_time * 3.0) * 0.01 * u_intensity;
    
    // vertical wave distortion
    uv.y += cos(uv.x * 25.0 + u_time * 2.0) * 0.01 * u_intensity;

    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, uv);
}