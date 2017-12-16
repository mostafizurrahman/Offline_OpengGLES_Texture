//
//  OpenGLView.h
//  DrawingTest
//
//  Created by Mostafizur Rahman on 10/25/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import <GLKit/GLKit.h>


@interface OpenGLView : GLKView{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    
    GLuint programHandle;
    
    GLuint _textureUniform;
    
    GLuint _positionSlot;
    GLuint _texCoordSlot;
    
    GLuint _floorTexture;
    
    GLuint resolution;
    GLuint blur_radius;
    GLuint direction;
    
    GLuint vertexBuffer;
    GLuint indexBuffer;
    
    GLuint frameBuffer;
    GLuint texture1;
    GLuint texture2;
    GLuint texture3;
    GLuint renderBuffer;
    GLuint depthBuffer;
    
    GLuint quadProgram;
    GLuint u_BaseTextureRGB;
    GLuint u_TextureBackground;
    GLuint u_TextureFrame;
    GLuint a_TexturePosition;
    GLuint a_TextureCoordinate;
    
    
}

@end
