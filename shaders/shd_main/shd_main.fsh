varying vec3 v_vPosition;
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_colour;
uniform vec3 u_playerPos;

void main() {
	float dist = 1.0 - (distance(v_vPosition, u_playerPos) / 256.0);
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord) * u_colour;
	gl_FragColor.rgb *= dist;
}
