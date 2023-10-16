package;

import flixel.ui.FlxBar;
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

typedef SongData = {
	var songName:String;
	var songChar:String;
}
class ExtrasState extends MusicBeatState
{
	public static var songs:Array<SongData> = [{
		songName: 'animation error',
		songChar: 'bobbie'
	}, {
		songName: 'lost control',
		songChar: 'face'
	}, {
		songName: 'slices',
		songChar: 'face'
	}];
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<HealthIcon> = [];
	private var curSelected = 0;

	var char:FlxSprite;
	var staticSpr:FlxSprite;

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

		staticSpr = new FlxSprite(0, 0).loadGraphic(Paths.image('effects/static'));
		staticSpr.frames = Paths.getSparrowAtlas('effects/static');
		staticSpr.animation.addByPrefix('idleIDFK', 'static idle', 24, true);
		staticSpr.animation.play('idleIDFK');
		staticSpr.scrollFactor.set();
		staticSpr.antialiasing = ClientPrefs.globalAntialiasing;
		staticSpr.visible = ClientPrefs.flashing;
		add(staticSpr);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...songs.length)
		{
			var leText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			leText.isMenuItem = true;
			leText.targetY = i;
			grpTexts.add(leText);

			var icon:HealthIcon = new HealthIcon(songs[i].songChar);
			icon.sprTracker = leText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
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
			switch(songs[curSelected].songName) {
				case 'animation error':
					MusicBeatState.switchState(new AnimationErrorState());
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

class AnimationErrorState extends MusicBeatState
{
	public static var options:Array<String> = ['easy', 'normal', 'hard', 'expert'];
	private var grpTexts:FlxTypedGroup<Alphabet>;

    var level:Array<String>;
    var currentLevel:Int = 0;
    var threatLevel:FlxText;
	var threatBar:FlxBar;
	var threatBarProg = 0;

    var iconList:Array<String>;
    var currentIcon:Int = 0;
    var icon:FlxSprite;

	private var curSelected = 0;

	var staticSpr:FlxSprite;

	override function create()
	{
		Lib.application.window.title = "One Ring Left";

		FlxG.camera.bgColor = FlxColor.GRAY;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		iconList = ["extras/animation-error/icon-easy", "extras/animation-error/icon-normal", "extras/animation-error/icon-hard", "extras/animation-error/icon-expert"];

        icon = new FlxSprite().loadGraphic(Paths.image("extras/animation-error/icon-easy"));
		icon.screenCenter();
        add(icon);

        threatLevel = new FlxText(45, 600, 902, 'Threat Level:', 40);
		threatLevel.setFormat('assets/fonts/schluber.ttf', 80, FlxColor.BLACK, LEFT);
        add(threatLevel);

		threatBar = new FlxBar((threatLevel.width/2)+45 , 600, LEFT_TO_RIGHT, 805, 75, this, 'threatBarProg', 0, 100, false); // = threatBar.createColoredEmptyBar(FlxColor.TRANSPARENT, false, FlxColor.WHITE);
		threatBar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.WHITE, false, FlxColor.WHITE);
		threatBar.numDivisions = 1000;
		//threatBar.color = FlxColor.BLACK;
		add(threatBar);


		staticSpr = new FlxSprite(0, 0).loadGraphic(Paths.image('effects/static'));
		staticSpr.frames = Paths.getSparrowAtlas('effects/static');
		staticSpr.animation.addByPrefix('idleIDFK', 'static idle', 24, true);
		staticSpr.animation.play('idleIDFK');
		staticSpr.scrollFactor.set();
		staticSpr.antialiasing = ClientPrefs.globalAntialiasing;
		staticSpr.visible = ClientPrefs.flashing;
		add(staticSpr);

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
                currentLevel = options.length - 1;
            }
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
            if (currentLevel >= options.length)
            {
                currentLevel = 0;
            }
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

		if (options[curSelected] == 'easy'){
			threatBarProg = Std.int(FlxMath.lerp(threatBarProg, 20, 0.1));
			threatBar.color = FlxColor.interpolate(threatBar.color, 0xFFFFFFFF, 0.1);
			threatLevel.color = FlxColor.interpolate(threatLevel.color, 0xFFFFFFFF, 0.1);
		}
		if (options[curSelected] == 'normal'){
			threatBarProg = Std.int(FlxMath.lerp(threatBarProg, 45, 0.1));
			threatBar.color = FlxColor.interpolate(threatBar.color, 0xFFFFFFFF, 0.1);
			threatLevel.color = FlxColor.interpolate(threatLevel.color, 0xFFFFFFFF, 0.1);
		}
		if (options[curSelected] == 'hard'){
			threatBarProg = Std.int(FlxMath.lerp(threatBarProg, 70, 0.1));
			threatBar.color = FlxColor.interpolate(threatBar.color, 0xFFFFFFFF, 0.1);
			threatLevel.color = FlxColor.interpolate(threatLevel.color, 0xFFFFFFFF, 0.1);
		}
		if (options[curSelected] == 'expert'){
			threatBarProg = Std.int(FlxMath.lerp(threatBarProg, 100, 0.1));
			threatBar.color = FlxColor.interpolate(threatBar.color, 0xFFB83CDD, 0.1);
			threatLevel.color = FlxColor.interpolate(threatLevel.color, 0xFFFF0000, 0.1);
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