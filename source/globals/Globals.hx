package globals;

class Globals
{
	public static var initialized:Bool = false;

	public static function initGame():Void
	{
		if (initialized)
			return;

		Actions.init();

		initialized = true;
	}
}