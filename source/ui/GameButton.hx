package ui;

import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.ui.FlxButton;

class GameButton extends FlxGroup
{
	public var x(get, set):Float;
	public var y(get, set):Float;

	public var width(get, never):Float;
	public var height(get, never):Float;

	public var text(get, set):String;
	public var button:GameUIButton;
	public var label:GameText;
	public var alpha(default, set):Float = 1;

	public function new(Text:String, X:Float, Y:Float, Width:Float, Height:Float, ?Callback:Void->Void):Void
	{
		super(4);

		button = new GameUIButton(0, 0, "", Callback);
		loadButtonGraphic(Width, Height);
		button.labelDownOffset = 4;
		button.scrollFactor.set();
		add(button);

		label = new GameText(Text);

		text = Text;

		label.scrollFactor.set();

		add(label);

		set_x(X);
		set_y(Y);
	}

	private function loadButtonGraphic(Width:Float, Height:Float):Void
	{
		button.loadGraphicSlice9([GraphicsCache.loadGraphic("assets/images/button_white.png")], Std.int(Width), Std.int(Height),
			[[8, 8, 37, 37], [8, 8, 37, 37], [8, 12, 37, 41]], FlxUI9SliceSprite.TILE_BOTH, -1, false, 45, 49);

	}

	private function set_alpha(Value:Float):Float
	{
		alpha = Value;
		button.alpha = label.alpha = alpha;
		return alpha;
	}

	private function set_x(Value:Float):Float
	{
		button.x = Std.int(Value);
		return button.x;
	}

	private function get_x():Float
	{
		return button.x;
	}

	private function set_y(Value:Float):Float
	{
		button.y = Std.int(Value);
		//
		return button.y;
	}

	private function get_y():Float
	{
		return button.y;
	}

	private function set_text(Value:String):String
	{
		label.text = Value;
		//
		return label.text;
	}

	private function get_text():String
	{
		return label.text;
	}

	private function get_width():Float
	{
		return button.width;
	}

	private function get_height():Float
	{
		return button.height;
	}

	override public function draw():Void
	{
		if (!visible)
			return;

		label.x = Std.int(button.x + button.width / 2 - label.width / 2);
		label.y = Std.int(button.y + 8);
		if (button.status == FlxButton.PRESSED)
		{
			label.y += button.labelDownOffset;
		}
		//

		super.draw();
	}
}

class GameUIButton extends FlxUIButton
{
	public var enabled(default, set):Bool = true;
	public var labelDownOffset:Float = 0;

	override public function updateButton():Void
	{
		if (!enabled)
			return;
		#if FLX_MOUSE
		if (FlxG.mouse.visible)
			super.updateButton();
		#end
	}

	override private function onOverHandler():Void
	{
		if (!enabled)
			return;
		super.onOverHandler();

		// Sounds.play("cursor_over", 0.1);
	}

	override private function onUpHandler():Void
	{
		if (!enabled)
			return;
		super.onUpHandler();

		// Sounds.play("click", 0.1);
	}

	override private function onOutHandler():Void
	{
		super.onOutHandler();
	}

	private function set_enabled(Value:Bool):Bool
	{
		enabled = Value;
		if (!enabled)
			onOutHandler();
		return enabled;
	}
}

class GameTogglableButton extends GameButton
{
	override private function loadButtonGraphic(Width:Float, Height:Float):Void
	{
		button.loadGraphicSlice9([GraphicsCache.loadGraphic("assets/images/button_white_toggle.png")], Std.int(Width), Std.int(Height),
			[[8, 8, 37, 37], [8, 8, 37, 37], [8, 12, 37, 41]], FlxUI9SliceSprite.TILE_BOTH, -1, true, 45, 49);
	}
}