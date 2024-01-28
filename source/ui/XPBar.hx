package ui;

import flixel.ui.FlxBar;
import ui.GameText;

class XPBar extends FlxTypedGroup<FlxSprite>
{
	var _bar:FlxBar;
	var currentXP:Int = 0;
	var currentLevel:Int = 1;
	
	public var playerLevelText:GameText;
	public var playerLevelTitle:GameText;
	
	public function new():Void
	{
		super();
		
		_bar = new FlxBar(FlxG.width/2+80, 25, LEFT_TO_RIGHT, 200, 25, null, "", 0, 100, true);
		
		playerLevelText = new GameText("1");
		playerLevelText.alignment = "center";
		playerLevelText.x  = FlxG.width/2+180 - playerLevelText.width / 2;
		playerLevelText.y  = 25+25+4;
		
		playerLevelTitle = new GameText(GetRankText());
		playerLevelTitle.alignment = "center";
		playerLevelTitle.x = FlxG.width/2 - playerLevelTitle.width / 2;
		playerLevelTitle.y = FlxG.height - 40;
		
		add(_bar);
		add(playerLevelText);
		add(playerLevelTitle);
		
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
		
		playerLevelTitle.text = GetRankText();
		playerLevelTitle.alignment = "center";
		playerLevelTitle.x = FlxG.width/2 - playerLevelTitle.width / 2;
	}
	
	public function GetRankText():String
	{
		switch (currentLevel)
		{
			case 1:
				return "Juvenile Jokester";
				
			//case 2:
			//	return "Juvenile Jokester II";
			//	
			//case 3:
			//	return "Juvenile Jokester III";
				
				
			case 2:
				return "Apprentice Juggler";
				
			//case 5:
			//	return "Apprentice Juggler II";
			//	
			//case 6:
			//	return "Apprentice Juggler III";
				
				
			case 3:
				return "Adept Pie Thrower";
				
			//case 8:
			//	return "Expert Pie Thrower II";
			//	
			//case 9:
			//	return "Expert Pie Thrower III";
				
				
			case 4:
				return "Expert Clown";
				
			//case 11:
			//	return "Master Clown II";
			//	
			//case 12:
			//	return "Master Clown III";
			//	
			case _:
				return "Endless Prankster";

		}
	}
}