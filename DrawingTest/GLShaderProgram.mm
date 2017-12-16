//
//  GLShaderProgram.m
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/16/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "GLShaderProgram.h"

@interface GLShaderProgram(){
    NSString *_vs;
    NSString *_fs;
}
@end

@implementation GLShaderProgram
@synthesize shaderHandle;
@synthesize u_BaseTextureRGB;
@synthesize u_FrameTextureRGB;
@synthesize u_BackgroundTextureRGB;
@synthesize a_TexturePosition;
@synthesize a_TextureCoordinate;

-(instancetype)initWithVS:(NSString *)vs FS:(NSString *)fs{
    self = [super init];
    _vs =  vs;
    _fs = fs;
    [self compileQuadShaders];
    return self;
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint programHandler = glCreateShader(shaderType);
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    glShaderSource(programHandler, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(programHandler);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(programHandler, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(programHandler, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return programHandler;
    
}

- (void)compileQuadShaders {
    
    // 1
    GLuint vertexShader = [self compileShader:_vs
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:_fs
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2
    shaderHandle = glCreateProgram();
    glAttachShader(shaderHandle, vertexShader);
    glAttachShader(shaderHandle, fragmentShader);
    glLinkProgram(shaderHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(shaderHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    glUseProgram(shaderHandle);
    
    u_BaseTextureRGB = glGetUniformLocation(shaderHandle, "u_TextureBaseRGB");
    u_BackgroundTextureRGB = glGetUniformLocation(shaderHandle, "u_BackgroundTextureRGB");
    u_FrameTextureRGB = glGetUniformLocation(shaderHandle, "u_FrameTextureRGB");
    
    a_TexturePosition = glGetAttribLocation(shaderHandle, "a_TexturePosition");
    a_TextureCoordinate = glGetAttribLocation(shaderHandle, "a_TextureCoordinate");
}


@end
