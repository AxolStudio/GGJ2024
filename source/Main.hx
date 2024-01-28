package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		AxolAPI.firstState = TitleState;
		AxolAPI.init = Globals.initGame;
		addChild(new FlxGame(0, 0, DissolveState));
	
	}
}
