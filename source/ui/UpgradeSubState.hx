package ui;

import flixel.util.FlxAxes;
import flixel.ui.FlxButton;
import flixel.FlxSubState;

class UpgradeSubState extends FlxSubState
{
	public var frame:Frame;

	public var titleText:GameText;

	public var upgrades:Array<UpgradeButton>;

	public function new():Void
	{
		super();
		add(frame = new Frame(FlxG.width * .8, FlxG.height * .8, BROWN));
		frame.scrollFactor.set();
		frame.screenCenter();
		add(titleText = new GameText("Upgrade Shop"));
		titleText.alignment = "center";
		titleText.screenCenter(FlxAxes.X);
		titleText.y = frame.y + 16;
		titleText.scrollFactor.set();
	}
}

class UpgradeButton extends FlxButton {}