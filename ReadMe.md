# Outline Shader with Transparency

## How does it work:
The shader does its magic in the vertex shader function. where it uses the current vertex positions, multiplies it with a float __OutlineThickness_ and sets these new positions for a dummy object's vertex positions.

This dummy object will have the color mentioned as __OutlineColor_ by the user in the fragment function.

This is for rendering the outline. Another pass is required for the actual object to render. Here the author has taken the surface shader approach and wrote the pass which renderes the actual object on top of it.


## Features Added:
1. Cosine controlled fading alpha animation.
2. Adjustable alpha for the outline.



## Shader Properties:

+ **_MainTex**: Main texture that will be applied to the model;  
+ **_OutlineColor**: Color of the outline. 
    - **Note:** that changing/Animating the color will only change the color to animate the alpha, use the __OutlineAlpha_ property.
+ **_OutlineThickness**: the thickness of the outline to for the object.
+ **_OutlineAlphaMin**: the minimum alpha for the outline.
+ **_OutlineAlphaMax**: the maximum alpha for the outline.
+ **\_OutlineUseFrequency**: this toggles between whether to manually lerp values using the __OutlineAlphaLerp_ or use the frequency for the fade animation
+ **_OutlineAlphaFrequency**: This is the frequency for fading in and out set it to a noz zero number to see the fading in and out animation.
+ **_OutlineAlphaLerp**: the linear interpolation value which goes between minimum alpha and maximum alpha.