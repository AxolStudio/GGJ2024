package ui;

import flixel.ui.FlxBar;

class XPBar extends FlxTypedGroup<FlxSprite>
{
	var _bar:FlxBar;
	var currentXP:Int = 0;
	var currentLevel:Int = 1;
	
	public function new():Void
	{
		super();
		
		_bar = new FlxBar(FlxG.width/2+80, 25, LEFT_TO_RIGHT, 200, 25, null, "", 0, 100, true);
		
		add(_bar);
		
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}
	
	public function updateBar():Void
	{
		_bar.value = (currentXP / XPNeeded()) * 100;
	}
	
	public function AddXP(amount:Int)
	{
		currentXP += amount;
		
		if (EnoughForNextLevel())
		{
			LevelUp();
		}
		
		updateBar();
	}
	
	public function XPNeeded():Int
	{
		return currentLevel * 100;
	}
	
	public function EnoughForNextLevel():Bool
	{
		return currentXP >= XPNeeded();
	}
	
	public function LevelUp()
	{
		currentXP -= XPNeeded();
		
		currentLevel += 1;
	}
}