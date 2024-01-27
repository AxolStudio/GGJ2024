package objects;

import flixel.util.FlxDirectionFlags;



class Player extends FlxTypedSpriteGroup<FlxSprite>
{
	public static inline var SPEED_PER_RANK:Int = 100;

	public var speedLevel:Int = 0;
	public var speedChangeDelay:Float = -1;

	public var hull:FlxSprite;
	public var sail:FlxSprite;
	public var nest:FlxSprite;

	public var collider:ShipCollider;
	
	public var wallet:Wallet;
	public var upgradeHandler:UpgradeHandler;

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

		sail.x = hull.origin.x - sail.origin.x;
		sail.y = hull.origin.y - sail.origin.y;

		nest.x = hull.origin.x - nest.origin.x;
		nest.y = hull.origin.y - nest.origin.y;

		hull.allowCollisions = nest.allowCollisions = sail.allowCollisions = FlxDirectionFlags.NONE;

		collider = new ShipCollider(this);

		// add(collider);
		add(hull);
		add(sail);
		add(nest);

		// width = hull.width;
		// height = hull.height;

		// origin.x = hull.width / 2;
		// origin.y = hull.height / 2;
		

		sail.animation.frameIndex = 3;
		
		wallet = new Wallet();


		collider.maxVelocity.x = collider.maxVelocity.y = SPEED_PER_RANK * 3;
		collider.drag.x = collider.drag.y = 10;

		collider.angle = -90;
	}

	public function spawn(X:Float, Y:Float):Void
	{
		collider.x = X;
		collider.y = Y;
	}

	public function movement():Void
	{
		var up:Bool = Actions.up.triggered && !Actions.down.triggered;
		var down:Bool = Actions.down.triggered && !Actions.up.triggered;
		var left:Bool = Actions.left.triggered && !Actions.right.triggered;
		var right:Bool = Actions.right.triggered && !Actions.left.triggered;

		if (left)
		{
			collider.angularVelocity = 20 * (4 - Math.abs(speedLevel)) * -1; // * FlxG.elapsed;
		}
		else if (right)
		{
			collider.angularVelocity = 20 * (4 - Math.abs(speedLevel)); // * FlxG.elapsed;
		}
		else
		{
			collider.angularVelocity = 0;
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
			collider.acceleration.x = collider.acceleration.y = 0;
		else
			FlxVelocity.accelerateFromAngle(collider, FlxAngle.asRadians(collider.angle), 100, SPEED_PER_RANK * speedLevel, false);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (speedChangeDelay > 0)
		{
			speedChangeDelay -= elapsed;
		}
		angle = collider.angle;

		trace(width, height, origin.x, origin.y);
		x = collider.x + collider.width / 2 - hull.origin.x;
		y = collider.y + collider.height / 2 - hull.origin.y;
	}
}

class ShipCollider extends FlxSprite
{
	public var parent:Player;

	public function new(Parent:Player):Void
	{
		super();
		parent = Parent;
		makeGraphic(Std.int(parent.hull.width) + 30, Std.int(parent.hull.width) + 30, 0xff000000);

		centerOrigin();
		centerOffsets();

		// Globals.PlayState.add(this);
	}
}