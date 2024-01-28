package objects;

import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import objects.Player;
import interfaces.ICollider;
import interfaces.IShip;

class Enemy extends FlxSprite
{
	public static inline var STATUS_WHOLE:String = "whole";
	public static inline var STATUS_DEAD:String = "dead";

	public static inline var SPEED_PER_RANK:Int = 100;
	public static inline var SIGHT_PER_RANK:Int = 100;

	public var speed:Float = 0;
	public var sightRange:Float = 0;

	public var state:EnemyState = EnemyState.Idle;

	public var plunder:Plunder = new Plunder(3, 2, 1, 0);

	public var fireFrom:Array<FlxPoint> = [];

	public var status(default, set):String = STATUS_WHOLE;

	public var whichEnemyType:Int = -1;

	public var randomAngleDir:Float = 0;
	public var randomAngleChangeTimer:Float = 0;
	
	public var fireTimer:FlxTimer;
	public var fireRate:Float = 3.0;
	public var defaultFireDirection:EnemyFireDirections = EnemyFireDirections.FORE;

	public function new():Void
	{
		super();

		GraphicsCache.loadAtlasGraphic(this, "enemies");

		sightRange = FlxG.width * .6;
		
		angularDrag = 100;
		
		fireTimer = new FlxTimer();
	}

	private function set_status(Value:String):String
	{
		status = Value;
		animation.frameName = "enemy-" + whichEnemyType + "-" + status;
		
		return status;
	}

	public function spawn(X:Float, Y:Float, Which:Int):Void
	{
		reset(X, Y);

		whichEnemyType = Which;

		var minSpeed = -1;
		var maxSpeed = -1;

		moves = true;
		immovable = false;
		allowCollisions = ANY;


		switch (Which)
		{
			case 1:
				
				speed = 150;
				maxAngular = 120;
				plunder.copper = FlxG.random.int(2, 5);
				plunder.silver = FlxG.random.int(0, 1);
				plunder.gold = 0;
				plunder.xp = 10;
				health = 5;
				defaultFireDirection = EnemyFireDirections.FORE;
			case 2:

				speed = 120;
				maxAngular = 80;
				plunder.copper = FlxG.random.int(4, 7);
				plunder.silver = FlxG.random.int(2, 5);
				plunder.gold = FlxG.random.int(0, 1);
				plunder.xp = 25;
				health = 10;
				defaultFireDirection = EnemyFireDirections.PORT_AND_STARBOARD;
				
			case 3:
				speed = 90;
				maxAngular = 50;
				plunder.copper = FlxG.random.int(6, 9);
				plunder.silver = FlxG.random.int(4, 7);
				plunder.gold = FlxG.random.int(2, 5);
				plunder.xp = 45;
				health = 15;
				defaultFireDirection = EnemyFireDirections.CONE;
				
			case 4:
				speed = 60;
				maxAngular = 20;
				plunder.copper = FlxG.random.int(10, 15);
				plunder.silver = FlxG.random.int(8, 14);
				plunder.gold = FlxG.random.int(5, 12);
				plunder.xp = 70;
				health = 20;
				defaultFireDirection = EnemyFireDirections.BROADSIDE;
		}

		status = STATUS_WHOLE;

		updateHitbox();
		centerOrigin();
		centerOffsets();
	}

	override public function kill():Void
	{
		plunder.Drop(x + width / 2, y + height / 2);
		alive = false;
		exists = true;
		status = STATUS_DEAD;
		state = EnemyState.Dead;
		fireTimer.cancel();
		velocity.set();
		angularVelocity = 0;
		angularAcceleration = 0;
		angularDrag = 0;
		allowCollisions = NONE;
		moves = false;
		immovable = true;
		FlxFlicker.flicker(this, 3, 0.1, false, false, (_) ->
		{
			exists = false;
		});
	}

	public function IsPlayerInSight():Bool
	{
		// Todo, just do a distance check for now.
		// In the future use ray-casting to see if there's an island in the way.

		return FlxMath.distanceBetween(this, Globals.PlayState.player) < sightRange;
	}

	public function SetState(newState:EnemyState)
	{
		
		state = newState;
		switch (state)
		{
			case EnemyState.Idle:
				randomAngleChangeTimer = FlxG.random.float(0.5, 3);
			case EnemyState.Chasing:
				fireTimer.start(fireRate, this.fireTimerTimeout);
				
			case EnemyState.Dead:
				// Todo, enter dead state
		}
	}

	public function HandleIdle()
	{
		// Todo, move to random areas?

		if (IsPlayerInSight())
		{
			SetState(EnemyState.Chasing);
		}
		else
		{
			randomAngleChangeTimer -= FlxG.elapsed;
			if (randomAngleChangeTimer <= 0)
			{
				randomAngleDir = FlxG.random.bool(50) ? 0 : FlxG.random.sign();
				randomAngleChangeTimer = FlxG.random.float(0.5, 3);
			}
			angularAcceleration = randomAngleDir * 100;
			FlxVelocity.accelerateFromAngle(this, FlxAngle.asRadians(this.angle), 60 + (10 * (5 - whichEnemyType)), speed * .6, false);
		}
	}

	public function HandleChasing()
	{
		// Todo, remove, just for testing.
		// plunder.Drop(x, y);

		if (IsPlayerInSight() == false)
		{
			SetState(EnemyState.Idle);
		}
		else
		{
			// enemies should only rotate a small amount at a time, towards the player
			var targetAngle:Float = FlxAngle.angleBetween(this, Globals.PlayState.player, true);
			var dir:Float = angle > targetAngle ? -1 : 1;
			angularAcceleration = dir * 100;
			FlxVelocity.accelerateFromAngle(this, FlxAngle.asRadians(this.angle), 60 + (10 * (5 - whichEnemyType)), speed, false);
			// angle = FlxAngle.angleBetween(this, Globals.PlayState.player, true);
			// FlxVelocity.moveTowardsObject(this, Globals.PlayState.player, speed, 0);
		}
	}

	public function ProcessState()
	{
		switch (state)
		{
			case EnemyState.Idle:
				HandleIdle();
				velocity.set();
				angularVelocity = 0;
				angularAcceleration = 0;
				angularDrag = 0;

			case EnemyState.Chasing:
				HandleChasing();
			case EnemyState.Dead:
		}
	}

	override public function update(elapsed:Float)
	{
		if (checkWorldBounds())
			return;
		super.update(elapsed);
		ProcessState();
	}

	private function checkWorldBounds():Bool
	{
		if (x < -(PlayState.WORLD_WIDTH / 2))
			x += PlayState.WORLD_WIDTH;
		else if (x > PlayState.WORLD_WIDTH / 2)
			x -= PlayState.WORLD_WIDTH;

		if (y < -(PlayState.WORLD_HEIGHT / 2))
			y += PlayState.WORLD_HEIGHT;
		else if (y > PlayState.WORLD_HEIGHT / 2)
			y -= PlayState.WORLD_HEIGHT;

		return !inWorldBounds();
		
	}
	
	public function fire(Direction:EnemyFireDirections):Void
	{
		var p:FlxPoint = FlxPoint.get();
		p = getPosition() + origin;
		
		switch(Direction)
		{
			case EnemyFireDirections.FORE:
				Globals.PlayState.fireCannon( p.x, p.y, angle, 1);
			
			case EnemyFireDirections.PORT_AND_STARBOARD:
				Globals.PlayState.fireCannon( p.x, p.y, angle-90, 1);
				Globals.PlayState.fireCannon( p.x, p.y, angle+90, 1);
			
			case EnemyFireDirections.CONE:
				Globals.PlayState.fireCannon(p.x, p.y, angle, 3);
			
			case EnemyFireDirections.BROADSIDE:
				Globals.PlayState.fireCannon(p.x, p.y, angle - 90, 3);
				Globals.PlayState.fireCannon(p.x, p.y, angle, 3);
				Globals.PlayState.fireCannon(p.x, p.y, angle + 90, 3);
			
		}
		
		p.put();
		//var p:FlxPoint = FlxPoint.get();
		//if ((Direction == FireDirections.FORE || Direction == FireDirections.ALL) && cooldowns[0] <= 0)
		//{
		//	p.copyFrom(gunBarrels[0]);
		//	p.degrees += hull.angle;
		//	p += hull.origin + hull.getPosition();
		//	Globals.PlayState.firePies(p.x, p.y, hull.angle, gunLevel);
		//	cooldowns[0] = gunCooldown;
		//}
		//if ((Direction == FireDirections.PORT || Direction == FireDirections.ALL) && cooldowns[1] <= 0)
		//{
		//	p.copyFrom(gunBarrels[1]);
		//	p.degrees += hull.angle;
		//	p += hull.origin + hull.getPosition();
		//	Globals.PlayState.firePies(p.x, p.y, hull.angle - 90, gunLevel);
		//	cooldowns[1] = gunCooldown;
		//}
		//if ((Direction == FireDirections.STARBOARD || Direction == FireDirections.ALL) && cooldowns[2] <= 0)
		//{
		//	p.copyFrom(gunBarrels[2]);
		//	p.degrees += hull.angle;
		//	p += hull.origin + hull.getPosition();
		//	Globals.PlayState.firePies(p.x, p.y, hull.angle + 90, gunLevel);
		//	cooldowns[2] = gunCooldown;
		//}
		//
		//p.put();
	}
	
	public function fireDefault():Void
	{
		fire(defaultFireDirection);
	}
	
	public function fireTimerTimeout(timer:FlxTimer):Void
	{
		fireDefault();
		if (state == EnemyState.Chasing)
		{
			fireTimer.start(fireRate, this.fireTimerTimeout);
		}
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
	var Dead = "dead";
}

enum abstract EnemyFireDirections(String)
{
	var FORE = "fore";
	var PORT_AND_STARBOARD = "port and starboard";
	var CONE = "cone";
	var BROADSIDE = "broadside";
}
