package objects;



class Player extends FlxTypedSpriteGroup<FlxSprite>
{
	public static inline var SPEED_PER_RANK:Int = 100;

	public var speedLevel:Int = 0;
	public var speedChangeDelay:Float = -1;

	public var hull:FlxSprite;
	public var sail:FlxSprite;
	public var nest:FlxSprite;

	// public var cannons:Array<FlxSprite>; // eventually

	public function new():Void
	{
		super();
		hull = new FlxSprite();
		hull.loadGraphic(GraphicsCache.loadGraphic("assets/images/ship-base.png"), false, 108, 40, false, "ship-base");
		sail = new FlxSprite();
		sail.loadGraphic(GraphicsCache.loadGraphic("assets/images/sail.png"), true, 46, 66, false, "sail");
		nest = new FlxSprite();
		nest.loadGraphic(GraphicsCache.loadGraphic("assets/images/ship-nest.png"), false, 18, 20, false, "ship-nest");

		hull.origin.x = 44;
		hull.origin.y = 19;

		sail.origin.x = 35;
		sail.origin.y = 33;

		nest.origin.x = 49;
		nest.origin.y = 10;

		sail.x = hull.x + 9;
		sail.y = hull.y + (hull.height / 2) - (sail.height / 2);

		nest.x = hull.x - 5;
		nest.y = hull.y + (hull.height / 2) - (nest.height / 2);

		add(hull);
		add(sail);
		add(nest);

		sail.animation.frameIndex = 3;

		maxVelocity.x = maxVelocity.y = SPEED_PER_RANK * 3;
		drag.x = drag.y = 10;

		angle = -90;

		// FlxG.watch.add(this, "speedLevel");
		// FlxG.watch.add(this, "angle");
		// FlxG.watch.add(this.velocity, "x");
		// FlxG.watch.add(this.velocity, "y");

		FlxG.watch.add(this, "x");
		FlxG.watch.add(this, "y");
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
				sail.animation.frameIndex = Std.int(Math.min(3, 3 - speedLevel));
			}
			else if (down && speedLevel > -1)
			{
				speedLevel--;
				speedChangeDelay = 0.1;
				sail.animation.frameIndex = Std.int(Math.min(3, 3 - speedLevel));
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