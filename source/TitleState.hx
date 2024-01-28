package;

import flixel.util.FlxAxes;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import ui.GameText;
import flixel.util.FlxColor;
import flixel.FlxState;

class TitleState extends FlxState
{
	public var ready:Bool = false;

	override public function create():Void
	{
		var title:FlxSprite = new FlxSprite();
		title.loadGraphic(GraphicsCache.loadGraphic("assets/images/title.png"), false, 1600, 900, false, "title");
		add(title);

		var pressAny:GameText = new GameText("Press Any Key to Send in the Clowns!");
		pressAny.screenCenter(FlxAxes.X);
		pressAny.y = FlxG.height;
		add(pressAny);

		FlxG.sound.playMusic("assets/music/clowning-around.ogg", .5);

		FlxG.camera.fade(FlxColor.BLACK, 1, true, () ->
		{
			FlxTween.tween(pressAny, {y: FlxG.height - pressAny.height - 10}, 1, {
				ease: FlxEase.quadOut,
				onComplete: (_) ->
				{
					FlxTween.tween(pressAny, {y: FlxG.height - pressAny.height - 20}, 1, {
						ease: FlxEase.quadInOut,
						type: FlxTweenType.PINGPONG
					});
				}
			});
			ready = true;
		});
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (ready && FlxG.keys.anyJustPressed(["ANY"]))
		{
			FlxG.camera.fade(FlxColor.BLACK, 1, false, () ->
			{
				FlxG.switchState(new PlayState());
			});
		}
		super.update(elapsed);
	}
}