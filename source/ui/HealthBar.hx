package ui;

import flixel.ui.FlxBar;

class HealthBar extends FlxTypedGroup<FlxSprite>
{
	var _bar:FlxBar;
	
	public function new():Void
	{
		super();
		
		_bar = new FlxBar(FlxG.width/2-200-80, 25, LEFT_TO_RIGHT, 200, 25, null, "", 0, 100, true);
		_bar.createColoredFilledBar(0xFFbf2e2e, true);
		
		add(_bar);
		
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}
	
	public function updateBar():Void
	{
		_bar.value = (Globals.PlayState.player.health / Globals.PlayState.player.maxHealth) * 100;
	}
}