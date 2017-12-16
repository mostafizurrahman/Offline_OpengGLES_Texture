
precision mediump float;

varying vec2 v_TextureCoordinate;
uniform sampler2D u_TextureBaseRGB;
uniform sampler2D u_BackgroundTextureRGB;
uniform sampler2D u_FrameTextureRGB;

void main(void) {
    vec4 t1 = texture2D(u_TextureBaseRGB, v_TextureCoordinate);
    vec4 t2 = texture2D(u_BackgroundTextureRGB, v_TextureCoordinate);
    vec4 t3 = texture2D(u_FrameTextureRGB, v_TextureCoordinate);
    gl_FragColor = t1 * 0.2 + t2 * 0.2 + t3 * 0.5;
}
