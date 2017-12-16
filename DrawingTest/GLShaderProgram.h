//
//  GLShaderProgram.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 12/16/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLShaderProgram : NSObject
-(instancetype)initWithVS:(NSString *)vs FS:(NSString *)fs;
@property (readwrite) GLuint shaderHandle;
@property (readwrite) GLuint u_BaseTextureRGB;
@property (readwrite) GLuint u_BackgroundTextureRGB;
@property (readwrite) GLuint u_FrameTextureRGB;

@property (readwrite) GLuint a_TexturePosition;
@property (readwrite) GLuint a_TextureCoordinate;

@end
