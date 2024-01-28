package ui;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;

class GameText extends FlxBitmapText
{
	public function new(Text:String = ""):Void
	{
		super(FlxBitmapFont.fromAngelCode("assets/images/pirate_font.png", "assets/images/pirate_font.xml"));
		pixelPerfectPosition = pixelPerfectRender = true;

		text = Text;
	}
}