package objects;

import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxVelocity;

class Player extends FlxSprite
{
	public static inline var SPEED_PER_RANK:Int = 100;

	public var speedLevel:Int = 0;
	public var speedChangeDelay:Float = -1;

	public function new():Void
	{
		super();
		loadGraphic(GraphicsCache.loadGraphic("assets/images/player-ship.png"), false, 113, 66, false, "player-ship");

		maxVelocity.x = maxVelocity.y = SPEED_PER_RANK * 3;
		drag.x = drag.y = 100;

		angle = -90;

		FlxG.watch.add(this, "speedLevel");
		FlxG.watch.add(this, "angle");
		FlxG.watch.add(this.velocity, "x");
		FlxG.watch.add(this.velocity, "y");
	}

	public function movement():Void
	{
		var up:Bool = Actions.up.triggered && !Actions.down.triggered;
		var down:Bool = Actions.down.triggered && !Actions.up.triggered;
		var left:Bool = Actions.left.triggered && !Actions.right.triggered;
		var right:Bool = Actions.right.triggered && !Actions.left.triggered;

		if (left)
		{
			angularVelocity = -300;
		}
		else if (right)
		{
			angularVelocity = 300;
		}
		else
		{
			angularVelocity = 0;
		}

		if (speedChangeDelay <= 0)
		{
			if (up && speedLevel < 3)
			{
				speedLevel++;
				speedChangeDelay = 0.1;
			}
			else if (down && speedLevel > -1)
			{
				speedLevel--;
				speedChangeDelay = 0.1;
			}
		}

		if (speedLevel == 0)
			acceleration.x = acceleration.y = 0;
		else
			FlxVelocity.accelerateFromAngle(this, FlxAngle.asRadians(angle), 100, SPEED_PER_RANK * speedLevel, false);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (speedChangeDelay > 0)
		{
			speedChangeDelay -= elapsed;
		}
	}
}