//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float tt;

void main()
{
    vec4 col_m, col;
	
	col_m = texture2D( gm_BaseTexture, v_vTexcoord);
	col   = vec4((col_m.rgb) * (1. - tt) + v_vColour.rgb * tt, col_m.a * v_vColour.a);
	
	gl_FragColor = col;
}
