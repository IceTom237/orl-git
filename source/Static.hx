package;

import flixel.system.FlxAssets;
import flixel.FlxG;

class StaticShader extends FlxShader{
    @:glFragmentSource("
        #pragma header
        const float e = 2.7182818284590452353602874713527;

        uniform float iTime;

        vec4 noise()
        {
            float G = e + (iTime * 0.1);
            vec2 r = (G * sin(G * openfl_TextureCoordv));
            // still a noob in GLSL :(
            vec4 col = flixel_texture2D(bitmap, vec4(fract(r.x * r.y * (1.0 + openfl_TextureCoordv.x))));
            col.r = flixel_texture2D(bitmap, vec4(0.89, 0.35, 0.35, 1.0));

            return col;
        }

        void main()
        {
            // vec2 uv = openfl_TextureCoordv*openfl_TextureSize;
            gl_FragColor = noise();
        }
    ")
    public function new(){
        super();
    }
}

class StaticEffect extends StaticShader{
    public var shader(default, null):StaticShader = new StaticShader();
    public var time(default, set):Float = 0;
    inline function set_time(value:Float){
        shader.iTime.value = [value];
        return time = value;
    }

    public function new(){
        super();
    }
}