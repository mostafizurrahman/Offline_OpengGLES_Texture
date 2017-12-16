
#import "OpenGLView.h"
#import "GLShaderProgram.h"

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

@interface OpenGLView(){
    GLShaderProgram *shaderProgram;
}
@end

@implementation OpenGLView

const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 0.5}, {1, 1}},
    {{1, 1, 0}, {0, 1, 0, 0.4}, {1, 0}},
    {{-1, 1, 0}, {0, 0, 1, 0.3}, {0, 0}},
    {{-1, -1, 0}, {0, 0, 0, 0.2}, {0, 1}},
};
const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        shaderProgram = [[GLShaderProgram alloc] initWithVS:@"QuadVProgram" FS:@"QuadFProgram"];
        [self setupVBOs];
        texture1 = [self setupTexture:@"cat.png"];
        texture2 = [self setupTexture:@"img.png"];
        texture3 = [self setupTexture:@"bw.jpg"];
        [self renderTexture];
        
    }
    return self;
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = NO;
    _eaglLayer.drawableProperties =
    [NSDictionary dictionaryWithObjectsAndKeys: kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    self.context = _context;
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    self.opaque = NO;
}

- (void)setupVBOs {
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupFrameBuffer {
    
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
}

- (GLuint)setupTexture:(NSString *)fileName {
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

-(void)renderTexture{
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    glUseProgram(shaderProgram.shaderHandle);
    
    glViewport(0, 0, 1080, 1822);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);
    glClearColor(0, 0.0, 0.0, 0.0);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glEnableVertexAttribArray(shaderProgram.a_TexturePosition);
    glVertexAttribPointer(shaderProgram.a_TexturePosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) offsetof(Vertex, Position));
    glEnableVertexAttribArray(shaderProgram.a_TextureCoordinate);
    glVertexAttribPointer(shaderProgram.a_TextureCoordinate, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) offsetof(Vertex, TexCoord));
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture1);
    glUniform1i(shaderProgram.u_BackgroundTextureRGB, 0);
    
    glActiveTexture(GL_TEXTURE0 + 1);
    glBindTexture(GL_TEXTURE_2D, texture2);
    glUniform1i(shaderProgram.u_FrameTextureRGB, 1);
    
    glActiveTexture(GL_TEXTURE0 + 2);
    glBindTexture(GL_TEXTURE_2D, texture3);
    glUniform1i(shaderProgram.u_BaseTextureRGB, 2);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    
    [self getImage:CGSizeMake(1080, 1822)];
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
}

-(UIImage *)getImage:(CGSize)imageSize{
    NSUInteger length = imageSize.width * imageSize.height * 4;
    GLubyte * buffer = (GLubyte *)malloc(length * sizeof(GLubyte));
    if(buffer == NULL)
        return nil;
    glReadPixels(0, 0, imageSize.width, imageSize.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, length, NULL);
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * imageSize.width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageSize.width, imageSize.height, bitsPerComponent,
                                        bitsPerPixel, bytesPerRow, colorSpaceRef,
                                        bitmapInfo, provider, NULL, NO, renderingIntent);
    UIGraphicsBeginImageContext(imageSize);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(0.0, 0.0, imageSize.width, imageSize.height), imageRef);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    free(buffer);
    return image;
}
@end
