
precision mediump float;
varying vec2 v_TextureCoordinate;
uniform sampler2D u_TextureBaseRGB;
highp float threshold = 0.5;

const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);

void main()
{
    highp vec4 textureColor = texture2D(u_TextureBaseRGB, v_TextureCoordinate);
    highp float luminance = dot(textureColor.rgb, W);
    highp float thresholdResult = step(threshold, luminance);
    
    gl_FragColor = vec4(vec3(thresholdResult), textureColor.w);
}
