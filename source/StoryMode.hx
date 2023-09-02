package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

using StringTools;

class StoryMode extends MusicBeatState
{
	var songs:Array<String> = ['inflamed'];
	private var grpTexts:FlxTypedGroup<Alphabet>;

	private var curSelected = 0;

	override function create()
	{
		FlxG.camera.bgColor = FlxColor.BLACK;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In The Menus", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('storymenu/white'));
		bg.scrollFactor.set();
		add(bg);

        var momitor:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("storymenu/momitor/inflamed"));
        momitor.screenCenter();
        add(momitor);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...songs.length)
		{
			var leText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i], true, false);
			leText.isMenuItemCenter = true;
			leText.visible = false;
			leText.targetY = i;
			grpTexts.add(leText);
		}

		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch(songs[curSelected]) {
				case 'inflamed':
					//insert code here memehoover
			}
			FlxG.sound.music.volume = 0;
		}
		
		var bullShit:Int = 0;
		for (item in grpTexts.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		PlayState.isStoryMode = true;

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
	}
}