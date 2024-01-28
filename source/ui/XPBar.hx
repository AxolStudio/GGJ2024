package ui;

import flixel.ui.FlxBar;
import ui.GameText;

class XPBar extends FlxTypedGroup<FlxSprite>
{
	var _bar:FlxBar;
	var currentXP:Int = 0;
	var currentLevel:Int = 1;
	
	public var playerLevelText:GameText;
	
	public function new():Void
	{
		super();
		
		_bar = new FlxBar(FlxG.width/2+80, 25, LEFT_TO_RIGHT, 200, 25, null, "", 0, 100, true);
		
		playerLevelText = new GameText("1");
		playerLevelText.alignment = "center";
		playerLevelText.x = FlxG.width/2+180 - playerLevelText.width / 2;
		playerLevelText.y = 25+25+4;
		
		add(_bar);
		add(playerLevelText);
		
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
		
		playerLevelText.text = Std.string(currentLevel);
		playerLevelText.x = FlxG.width/2+180 - playerLevelText.width / 2;
	}
}