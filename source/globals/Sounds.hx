package globals;

import flixel.system.FlxSound;

class Sounds
{
	public static var SoundList:Map<String, FlxSound> = [];

	public static var impacts:Array<String> = [];
	public static var shots:Array<String> = [];
	public static var coins:Array<String> = [];

	public static function loadSounds():Void
	{
		addSound("Cannon impact 1");
		addSound("Cannon impact 2");
		addSound("Cannon impact 3");
		addSound("Cannon impact 4");
		addSound("Cannon impact 5");
		addSound("Cannon shots 1");
		addSound("Cannon shots 2");
		addSound("Cannon shots 3");
		addSound("Cannon shots 4");
		addSound("honk");
		addSound("Map close 1");
		addSound("Map open 1");
		addSound("Coins 1");
		addSound("Coins 2");
		addSound("Coins 3");
		addSound("Coins 4");
		addSound("Upgrade purchase");

		impacts = [
			"Cannon impact 1",
			"Cannon impact 2",
			"Cannon impact 3",
			"Cannon impact 4",
			"Cannon impact 5"
		];
		shots = ["Cannon shots 1", "Cannon shots 2", "Cannon shots 3", "Cannon shots 4"];
		coins = ["Coins 1", "Coins 2", "Coins 3", "Coins 4"];
	}

	public static function playSound(Name:String):Void
	{
		var sound:FlxSound = SoundList.get(Name);
		sound.play();
	}

	private static function addSound(Name:String):Void
	{
		var sound:FlxSound = new FlxSound();
		sound.loadEmbedded("assets/sounds/" + Name + ".wav", false, false);
		SoundList.set(Name, sound);
	}
}