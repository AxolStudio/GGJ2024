package objects;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Explosion extends FlxSprite
{
	public function new():Void
	{
		super();
		loadGraphic(GraphicsCache.loadGraphic("assets/images/explosion.png"), false, 74, 75, "explosion");
		kill();
	}

	public function spawn(X:Float, Y:Float):Void
	{
		reset(X - (width / 2), Y - (height / 2));
		scale.set(0.001, 0.001);
		FlxTween.tween(scale, {x: 1, y: 1}, 0.33, {
			ease: FlxEase.quadOut,
			type: FlxTweenType.ONESHOT,
			onComplete: (_) ->
			{
				FlxTween.tween(scale, {x: 0.001, y: 0.001}, 0.33, {
					ease: FlxEase.quadIn,
					type: FlxTweenType.ONESHOT,
					onComplete: (_) ->
					{
						kill();
					}
				});
			}
		});
	}
}