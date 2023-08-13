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
	var songs:Array<String> = ['foraging', 'torn apart', 'blood thirsty'];
	private var grpTexts:FlxTypedGroup<Alphabet>;

    var imagePaths:Array<String>;
    var currentIndex:Int = 0;
    var imageSprite:FlxSprite;

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

        imagePaths = ["storymenu/momitor/foraging", "storymenu/momitor/torn-apart", "storymenu/momitor/blood-thirsty"];

        imageSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("storymenu/momitor/foraging"));
        imageSprite.screenCenter();
        add(imageSprite);

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
		if (controls.UI_LEFT_P)
		{
			changeSelection(-1);

			currentIndex--;
            if (currentIndex < 0)
            {
                currentIndex = imagePaths.length - 1;
            }
            remove(imageSprite);
            imageSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(imagePaths[currentIndex]));
            add(imageSprite);
		}
		if (controls.UI_RIGHT_P)
		{
			changeSelection(1);

			currentIndex++;
            if (currentIndex >= imagePaths.length)
            {
                currentIndex = 0;
            }
            remove(imageSprite);
            imageSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(imagePaths[currentIndex]));
            add(imageSprite);
		}

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch(songs[curSelected]) {
				case 'foraging':
					PlayState.SONG = Song.loadFromJson('foraging', 'foraging');
					LoadingState.loadAndSwitchState(new PlayState());
				case 'torn apart':
					PlayState.SONG = Song.loadFromJson('torn-apart', 'torn-apart');
					LoadingState.loadAndSwitchState(new PlayState());
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