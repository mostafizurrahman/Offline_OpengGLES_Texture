
precision mediump float;

varying vec2 v_TextureCoordinate;
uniform sampler2D u_TextureBaseRGB;

void main(void) {
    vec4 t1 = texture2D(u_TextureBaseRGB, vec2(v_TextureCoordinate.x , 1.0 - v_TextureCoordinate.y ));
    gl_FragColor = t1;//vec4(0.7);
}

