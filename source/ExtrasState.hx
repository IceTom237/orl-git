package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.Lib;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class ExtrasState extends MusicBeatState
{
	public static var songs:Array<String> = ['animation error', 'lost control', 'slices'];
	private var grpTexts:FlxTypedGroup<Alphabet>;

	private var curSelected = 0;

	var char:FlxSprite;
	var shader:FlxSprite;

	override function create()
	{
		Lib.application.window.title = "One Ring Left";

		FlxG.camera.bgColor = FlxColor.BLACK;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/backgrounds/placeholder'));
		bg.scrollFactor.set();
		add(bg);

		shader = new FlxSprite(0, 0).loadGraphic(Paths.image('shaders/static'));
		shader.frames = Paths.getSparrowAtlas('shaders/static');
		shader.animation.addByPrefix('idleIDFK', 'static idle', 24, true);
		shader.animation.play('idleIDFK');
		shader.scrollFactor.set();
		shader.antialiasing = ClientPrefs.globalAntialiasing;
		shader.visible = ClientPrefs.flashing;
		add(shader);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...songs.length)
		{
			var leText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i], true, false);
			leText.isMenuItem = true;
			leText.targetY = i;
			grpTexts.add(leText);
		}
		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch(songs[curSelected]) {
				case 'animation error':
					MusicBeatState.switchState(new AnimationErrorSubstate());
				case 'lost control':
					PlayState.SONG = Song.loadFromJson('lost-control', 'lost-control');
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.volume = 0;
					FreeplayState.destroyFreeplayVocals();
				case 'slices':
					PlayState.SONG = Song.loadFromJson('slices', 'slices');
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.volume = 0;
					FreeplayState.destroyFreeplayVocals();
			}
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

		PlayState.isExtrasMenu = true;

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

class AnimationErrorSubstate extends MusicBeatState
{
	public static var options:Array<String> = ['easy', 'normal', 'hard', 'expert'];
	private var grpTexts:FlxTypedGroup<Alphabet>;

    var level:Array<String>;
    var currentLevel:Int = 0;
    var threatLevel:FlxSprite;

    var iconList:Array<String>;
    var currentIcon:Int = 0;
    var icon:FlxSprite;

	private var curSelected = 0;

	var shader:FlxSprite;

	override function create()
	{
		Lib.application.window.title = "One Ring Left";

		FlxG.camera.bgColor = FlxColor.GRAY;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		iconList = ["extras/animation-error/icon-easy", "extras/animation-error/icon-normal", "extras/animation-error/icon-hard", "extras/animation-error/icon-expert"];
		level = ["extras/animation-error/threat-easy", "extras/animation-error/threat-normal", "extras/animation-error/threat-hard", "extras/animation-error/threat-expert"];

        icon = new FlxSprite().loadGraphic(Paths.image("extras/animation-error/icon-easy"));
		icon.screenCenter();
        add(icon);

        threatLevel = new FlxSprite(0, 550).loadGraphic(Paths.image("extras/animation-error/threat-easy"));
        add(threatLevel);

		shader = new FlxSprite(0, 0).loadGraphic(Paths.image('shaders/static'));
		shader.frames = Paths.getSparrowAtlas('shaders/static');
		shader.animation.addByPrefix('idleIDFK', 'static idle', 24, true);
		shader.animation.play('idleIDFK');
		shader.scrollFactor.set();
		shader.antialiasing = ClientPrefs.globalAntialiasing;
		shader.visible = ClientPrefs.flashing;
		add(shader);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var leText:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true, false);
			leText.visible = false;
			leText.isMenuItem = true;
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

			currentIcon--;
            if (currentIcon < 0)
            {
                currentIcon = iconList.length - 1;
            }
            remove(icon);
            icon = new FlxSprite().loadGraphic(Paths.image(iconList[currentIcon]));
			icon.screenCenter();
            add(icon);

			currentLevel--;
            if (currentLevel < 0)
            {
                currentLevel = level.length - 1;
            }
            remove(threatLevel);
            threatLevel = new FlxSprite(0, 550).loadGraphic(Paths.image(level[currentLevel]));
            add(threatLevel);
		}
		if (controls.UI_RIGHT_P)
		{
			changeSelection(1);

			currentIcon++;
            if (currentIcon >= iconList.length)
            {
                currentIcon = 0;
            }
            remove(icon);
            icon = new FlxSprite().loadGraphic(Paths.image(iconList[currentIcon]));
			icon.screenCenter();
            add(icon);

			currentLevel++;
            if (currentLevel >= level.length)
            {
                currentLevel = 0;
            }
            remove(threatLevel);
            threatLevel = new FlxSprite(0, 550).loadGraphic(Paths.image(level[currentLevel]));
            add(threatLevel);
		}

		if (controls.BACK)
		{
			MusicBeatState.switchState(new ExtrasState());
		}

		if (controls.ACCEPT)
		{
			switch(options[curSelected]) {
				case 'easy':
					PlayState.SONG = Song.loadFromJson('animation-error-easy', 'animation-error');
					LoadingState.loadAndSwitchState(new PlayState());
				case 'normal':
					PlayState.SONG = Song.loadFromJson('animation-error', 'animation-error');
					LoadingState.loadAndSwitchState(new PlayState());
				case 'hard':
					PlayState.SONG = Song.loadFromJson('animation-error-hard', 'animation-error');
					LoadingState.loadAndSwitchState(new PlayState());
				case 'expert':
					PlayState.SONG = Song.loadFromJson('animation-error-expert', 'animation-error');
					LoadingState.loadAndSwitchState(new PlayState());
			}
			FlxG.sound.music.volume = 0;
			FreeplayState.destroyFreeplayVocals();
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
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;
	}
}