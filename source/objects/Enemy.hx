package objects;

import objects.Player;
import interfaces.ICollider;
import interfaces.IShip;

// TODO: Change into a FlxSpriteGroup object and load different ship compponents
//      set them up similar to the player's ship - add some randomization elements etc
//      movement can use `FlxVelocity.moveTowardsObject` to move towards the player and
//      `FlxAngle.angleTowardsObject` to rotate towards the player
//     `Globals.PlayState.player to get the player object



class Enemy extends FlxTypedSpriteGroup<FlxSprite> implements IShip
{
	public static inline var SPEED_PER_RANK:Int = 100;
	public static inline var SIGHT_PER_RANK:Int = 100;

	public var speedLevel:Int = 0;
	public var speedChangeDelay:Float = -1;

	public var speed:Float = 100.0;
	public var sightRange:Int = 1000;

	public var state:EnemyState = EnemyState.Idle;

	public var plunder:Plunder = new Plunder(3, 2, 1);

	public var hull:FlxSprite;
	public var sail:FlxSprite;
	public var nest:FlxSprite;

	public var collider:EnemyShipCollider;

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

		hull.allowCollisions = nest.allowCollisions = sail.allowCollisions = FlxDirectionFlags.NONE;

		collider = new EnemyShipCollider(this);

		add(hull);
		add(sail);
		add(nest);

		sail.animation.frameIndex = 0;

		collider.maxVelocity.x = collider.maxVelocity.y = SPEED_PER_RANK * 3;
		collider.drag.x = collider.drag.y = 10;

		collider.angle = -90;
	}

	public function spawn(X:Float, Y:Float, Which:ShipType):Void
	{
		collider.x = X;
		collider.y = Y;

		revive();

		var minSpeed = -1;
		var maxSpeed = -1;

		switch (Which)
		{
			case ShipType.SLOOP:
				scale.set(.5, .5);
				// hull.scale.set(.5, .5);
				// sail.scale.set(.5, .5);
				// nest.scale.set(.5, .5);

				minSpeed = 235;
				maxSpeed = 265;
				speed = FlxG.random.int(minSpeed, maxSpeed);
				plunder.copper = FlxG.random.int(2, 5);
				plunder.silver = FlxG.random.int(0, 1);
				plunder.gold = 0;

			case ShipType.FRIGATE:
				scale.set(1, 1);
				minSpeed = 165;
				maxSpeed = 195;
				speed = FlxG.random.int(minSpeed, maxSpeed);
				plunder.copper = FlxG.random.int(4, 7);
				plunder.silver = FlxG.random.int(2, 5);
				plunder.gold = FlxG.random.int(0, 1);
			case ShipType.SHIPOFLINE:
				scale.set(2, 2);
				minSpeed = 105;
				maxSpeed = 135;
				speed = FlxG.random.int(minSpeed, maxSpeed);
				plunder.copper = FlxG.random.int(6, 9);
				plunder.silver = FlxG.random.int(4, 7);
				plunder.gold = FlxG.random.int(2, 5);
		}

		updateHitbox();
	}

	public function IsPlayerInSight():Bool
	{
		// Todo, just do a distance check for now.
		// In the future use ray-casting to see if there's an island in the way.

		return FlxMath.distanceBetween(collider, Globals.PlayState.player) < sightRange;
	}

	public function SetState(newState:EnemyState)
	{
		// Todo, do enter/leave state processing (if any)
		state = newState;
	}

	public function HandleIdle()
	{
		// Todo, move to random areas?

		if (IsPlayerInSight())
		{
			SetState(EnemyState.Chasing);
		}
	}

	public function HandleChasing()
	{
		// Todo, remove, just for testing.
		plunder.Drop(x, y);

		if (IsPlayerInSight() == false)
		{
			SetState(EnemyState.Idle);
		}
		else
		{
			collider.angle = FlxAngle.angleBetween(collider, Globals.PlayState.player, true);
			FlxVelocity.moveTowardsObject(collider, Globals.PlayState.player, speed, 0);
		}
	}

	public function ProcessState()
	{
		switch (state)
		{
			case EnemyState.Idle:
				HandleIdle();

			case EnemyState.Chasing:
				HandleChasing();
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		ProcessState();
		if (speedChangeDelay > 0)
		{
			speedChangeDelay -= elapsed;
		}
		angle = collider.angle;

		x = collider.x + collider.width / 2 - hull.origin.x;
		y = collider.y + collider.height / 2 - hull.origin.y;
	}
}

enum abstract ShipType(String)
{
	var SLOOP = "sloop";
	var FRIGATE = "frigate";
	var SHIPOFLINE = "shipofline";
}

enum abstract EnemyState(String)
{
	var Idle = "idle";
	var Chasing = "chasing";
}



class EnemyShipCollider extends FlxSprite implements ICollider
{
	public var parent:IShip;

	public function new(Parent:IShip):Void
	{
		super();
		parent = Parent;
		makeGraphic(Std.int(parent.hull.width) + 30, Std.int(parent.hull.width) + 30, 0xff000000);
		scale.set(parent.scale.x, parent.scale.y);
		updateHitbox();
		centerOrigin();
		centerOffsets();

		Globals.PlayState.colliders.add(this);
	}
}
