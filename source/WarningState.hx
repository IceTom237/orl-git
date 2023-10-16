package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class WarningState extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Hello Player,\nOur mod One Ring Left is an official mod directed by Tommy K., Tyler does stuff, and MDRtheWolf.\nIf you are making a fan mod on One Ring Left please read the following:
			\nPlease note that you MUST direct message the MAIN director of ORL.\nTo contact the main director, please contact him on discord
			\nformallyicetom\nYoutubers if your recording this video,\nHi YouTube :D\nIf you do not want to see this menu again disable the warning screen option in the options menu.\n(Press Enter To Leave This Menu.)",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
