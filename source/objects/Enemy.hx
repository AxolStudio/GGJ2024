package objects;

//import flixel.Math;

// TODO: Change into a FlxSpriteGroup object and load different ship compponents
//      set them up similar to the player's ship - add some randomization elements etc
//      movement can use `FlxVelocity.moveTowardsObject` to move towards the player and
//      `FlxAngle.angleTowardsObject` to rotate towards the player
//     `Globals.PlayState.player to get the player object

enum EnemyState
{
	Idle;
	Chasing;
}

class Enemy extends FlxTypedSpriteGroup<FlxSprite>
{
	public static inline var SPEED_PER_RANK:Int = 100;
	public static inline var SIGHT_PER_RANK:Int = 100;

	public var speedLevel:Int = 0;
	public var speedChangeDelay:Float = -1;
	
	public var speed:Float = 100.0;
	public var sightRange:Int = 1000;
	
	public var state:EnemyState = EnemyState.Idle;

	public var hull:FlxSprite;
	public var sail:FlxSprite;
	public var nest:FlxSprite;
	
	
	public function new(x:Float, y:Float):Void
	{
		super();
		this.x = x;
		this.y = y;
		
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
	
	public static function GenerateSloop(x:Float, y:Float):Enemy
	{
		var newEnemy = new Enemy(x, y);
		return newEnemy;
	}
	
	public static function GenerateFrigate(x:Float, y:Float):Enemy
	{
		var newEnemy = new Enemy(x, y);
		return newEnemy;
	}
	
	public static function GenerateShipOfLine(x:Float, y:Float):Enemy
	{
		var newEnemy = new Enemy(x, y);
		return newEnemy;
	}
	
	
	public function IsPlayerInSight():Bool
	{
		// Todo, just do a distance check for now.
		// In the future use ray-casting to see if there's an island in the way.
		
		return FlxMath.distanceBetween(this, Globals.PlayState.player) < sightRange;
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
		if (IsPlayerInSight() == false)
		{
			SetState(EnemyState.Idle);
		}
		else
		{
			this.angle = FlxAngle.angleBetween(this, Globals.PlayState.player, true);
			FlxVelocity.moveTowardsObject(this, Globals.PlayState.player, this.speed, 0);
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
	} 
}