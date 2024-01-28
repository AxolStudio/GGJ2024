package ui;

import flash.geom.Rectangle;
import flixel.addons.ui.FlxUI9SliceSprite;

class Frame extends FlxUI9SliceSprite
{
	public function new(Width:Float, Height:Float, Color:FrameColor = BROWN):Void
	{
		super(0, 0, GraphicsCache.loadGraphic("assets/images/panel_" + Color + ".png"), new Rectangle(0, 0, Width, Height), [8, 8, 84, 84],
			FlxUI9SliceSprite.TILE_BOTH);
	}
}

enum abstract FrameColor(String) to String
{
	var BROWN = "brown";
	var BLUE = "blue";
	var BEIGE = "beige";
	var LIGHT = "light";
}