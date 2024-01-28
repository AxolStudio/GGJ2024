package globals;

import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import flixel.input.actions.FlxActionInput.FlxInputDeviceID;
import flixel.input.actions.FlxActionSet;

class Actions
{
	public static var actions:FlxActionManager;

	public static var gameplayIndex:Int = -1;

	public static var up:FlxActionDigital;
	public static var down:FlxActionDigital;
	public static var left:FlxActionDigital;
	public static var right:FlxActionDigital;

	public static var pause:FlxActionDigital;
	public static var fireFore:FlxActionDigital;
	public static var firePort:FlxActionDigital;
	public static var fireStar:FlxActionDigital;
	public static var fireAll:FlxActionDigital;

	public static var openShop:FlxActionDigital;
	public static var honk:FlxActionDigital;

	public static function init():Void
	{
		if (Actions.actions != null)
			return;
		Actions.actions = FlxG.inputs.add(new FlxActionManager());
		Actions.actions.resetOnStateSwitch = ResetPolicy.NONE;

		Actions.up = new FlxActionDigital();
		Actions.down = new FlxActionDigital();
		Actions.left = new FlxActionDigital();
		Actions.right = new FlxActionDigital();

		Actions.pause = new FlxActionDigital();
		Actions.fireFore = new FlxActionDigital();
		Actions.firePort = new FlxActionDigital();
		Actions.fireStar = new FlxActionDigital();
		Actions.fireAll = new FlxActionDigital();

		Actions.openShop = new FlxActionDigital();
		Actions.honk = new FlxActionDigital();

		var gameSet:FlxActionSet = new FlxActionSet("GameControls", [
			Actions.up,
			Actions.down,
			Actions.left,
			Actions.right,
			Actions.pause,
			Actions.fireFore,
			Actions.firePort,
			Actions.fireStar,
			Actions.fireAll,
			Actions.openShop, Actions.honk
		]);

		gameplayIndex = Actions.actions.addSet(gameSet);

		Actions.up.addKey(UP, PRESSED);
		Actions.up.addKey(W, PRESSED);
		Actions.down.addKey(DOWN, PRESSED);
		Actions.down.addKey(S, PRESSED);
		Actions.left.addKey(LEFT, PRESSED);
		Actions.left.addKey(A, PRESSED);
		Actions.right.addKey(RIGHT, PRESSED);
		Actions.right.addKey(D, PRESSED);

		Actions.pause.addKey(P, JUST_PRESSED);
		Actions.pause.addKey(ESCAPE, JUST_PRESSED);

		Actions.up.addGamepad(DPAD_UP, PRESSED);
		Actions.down.addGamepad(DPAD_DOWN, PRESSED);
		Actions.left.addGamepad(DPAD_LEFT, PRESSED);
		Actions.right.addGamepad(DPAD_RIGHT, PRESSED);

		Actions.pause.addGamepad(START, JUST_PRESSED);

		Actions.fireFore.addKey(I, PRESSED);
		Actions.fireFore.addKey(NUMPADEIGHT, PRESSED);
		Actions.firePort.addKey(J, PRESSED);
		Actions.firePort.addKey(NUMPADFOUR, PRESSED);
		Actions.fireStar.addKey(L, PRESSED);
		Actions.fireStar.addKey(NUMPADSIX, PRESSED);
		Actions.fireAll.addKey(K, PRESSED);
		Actions.fireAll.addKey(NUMPADFIVE, PRESSED);

		Actions.fireFore.addGamepad(X, PRESSED);
		Actions.firePort.addGamepad(Y, PRESSED);
		Actions.fireStar.addGamepad(A, PRESSED);
		Actions.fireAll.addGamepad(B, PRESSED);

		Actions.openShop.addKey(SPACE, JUST_PRESSED);
		Actions.openShop.addGamepad(GUIDE, JUST_PRESSED);

		Actions.honk.addKey(H, JUST_PRESSED);
		Actions.honk.addGamepad(RIGHT_SHOULDER, JUST_PRESSED);

		Actions.actions.activateSet(Actions.gameplayIndex, FlxInputDevice.ALL, FlxInputDeviceID.ALL);
	}
}