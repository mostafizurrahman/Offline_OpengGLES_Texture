# Offscreen_OpengGLES_Texture
Offscreen texture is used to create large texture and render small or scaled texture to screen. Screen resulotion
may not represent actual texture hence textures are needed to scale down.

Main theme of offline texture is to draw texture using glshader into a global texture. then render the final scene to the 
mobile screen. A frame buffer should create to back the offscreen texture. before drawing offcreen, default frame buffer 
should store and use it later for rendering the final scene.
