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

class FreeplayState extends MusicBeatState
{
	public static var songs:Array<String> = ['foraging', 'torn apart', 'blood thirsty'];
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

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/backgrounds/week_inflamed/forest'));
		bg.scrollFactor.set();
		add(bg);

		char = new FlxSprite(600, -300).loadGraphic(Paths.image('freeplay/chars/week_inflamed/foraging'));
		char.scrollFactor.set();
		char.scale.set(0.3, 0.3);
		char.antialiasing = ClientPrefs.globalAntialiasing;
		add(char);

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

		var navigation:FlxText = new FlxText(12, FlxG.height - 44, 0, "Press CTRL to navigate", 12);
		navigation.scrollFactor.set();
		navigation.setFormat("NiseSegaSonic", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(navigation);

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

		if (FlxG.keys.justPressed.CONTROL)
		{
			MusicBeatState.switchState(new FreeplayPage2State());
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			MusicBeatState.switchState(new FreeplayPage11State());
			FlxG.sound.music.volume = 0;
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

class FreeplayPage2State extends MusicBeatState
{
	public static var songs:Array<String> = ['too late', 'kill streak'];
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

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/backgrounds/week_kill_streak/hill'));
		bg.scrollFactor.set();
		add(bg);

		char = new FlxSprite(600, -300).loadGraphic(Paths.image('freeplay/chars/week_kill_streak/kill_streak'));
		char.scrollFactor.set();
		char.scale.set(0.3, 0.3);
		char.antialiasing = ClientPrefs.globalAntialiasing;
		add(char);

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

		var navigation:FlxText = new FlxText(12, FlxG.height - 44, 0, "Press CTRL to navigate", 12);
		navigation.scrollFactor.set();
		navigation.setFormat("NiseSegaSonic", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(navigation);

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

		if (FlxG.keys.justPressed.CONTROL)
		{
			MusicBeatState.switchState(new FreeplayPage3State());
		}

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch(songs[curSelected]) {
				case 'kill streak':
					PlayState.SONG = Song.loadFromJson('kill-streak', 'kill-streak');
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

class FreeplayPage3State extends MusicBeatState
{
	public static var songs:Array<String> = ['perfection'];
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

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/backgrounds/placeholder/placeholder'));
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

		var navigation:FlxText = new FlxText(12, FlxG.height - 44, 0, "Press CTRL to navigate", 12);
		navigation.scrollFactor.set();
		navigation.setFormat("NiseSegaSonic", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(navigation);

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

		if (FlxG.keys.justPressed.CONTROL)
		{
			MusicBeatState.switchState(new FreeplayState());
		}

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch(songs[curSelected]) {
				case 'perfection':
					PlayState.SONG = Song.loadFromJson('perfection', 'perfection');
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

class FreeplayPage11State extends MusicBeatState
{
	public static var songs:Array<String> = ['foraging', 'torn apart', 'blood thirsty'];
	private var grpTexts:FlxTypedGroup<Alphabet>;

	private var curSelected = 0;

	var char:FlxSprite;
	var shader:FlxSprite;

	override function create()
	{
		Lib.application.window.title = "you are a thief";

		FlxG.camera.bgColor = FlxColor.BLACK;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/backgrounds/week_inflamed/...'));
		bg.scrollFactor.set();
		add(bg);

		char = new FlxSprite(600, -300).loadGraphic(Paths.image('freeplay/chars/week_inflamed/foraging'));
		char.scrollFactor.set();
		char.scale.set(0.3, 0.3);
		char.antialiasing = ClientPrefs.globalAntialiasing;
		add(char);

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

		var navigation:FlxText = new FlxText(12, FlxG.height - 44, 0, "You are slowly removing features", 12);
		navigation.scrollFactor.set();
		navigation.setFormat("NiseSegaSonic", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(navigation);

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

		if (controls.ACCEPT)
		{
			MusicBeatState.switchState(new FreeplayPage111State());
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

class FreeplayPage111State extends MusicBeatState
{
	public static var songs:Array<String> = ['stop removing everything'];
	private var grpTexts:FlxTypedGroup<Alphabet>;

	private var curSelected = 0;

	var char:FlxSprite;
	var shader:FlxSprite;

	override function create()
	{
		Lib.application.window.title = "you are a thief";

		FlxG.camera.bgColor = FlxColor.BLACK;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/backgrounds/week_inflamed/...'));
		bg.scrollFactor.set();
		add(bg);

		char = new FlxSprite(600, -300).loadGraphic(Paths.image('freeplay/chars/week_inflamed/...'));
		char.scrollFactor.set();
		char.scale.set(0.3, 0.3);
		char.antialiasing = ClientPrefs.globalAntialiasing;
		add(char);

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

		var navigation:FlxText = new FlxText(12, FlxG.height - 44, 0, "error404", 12);
		navigation.scrollFactor.set();
		navigation.setFormat("NiseSegaSonic", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(navigation);

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

		if (controls.ACCEPT)
		{
			MusicBeatState.switchState(new FreeplayPage1111State());
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

class FreeplayPage1111State extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"you have pirated this game",
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

			PlayState.SONG = Song.loadFromJson('unwanted-pirate', 'unwanted-pirate');
			LoadingState.loadAndSwitchState(new PlayState());
		}
		super.update(elapsed);
	}
}
