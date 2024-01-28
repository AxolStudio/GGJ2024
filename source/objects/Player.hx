package objects;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.util.FlxDirectionFlags;
import interfaces.ICollider;
import interfaces.IShip;

class Player extends FlxTypedSpriteGroup<FlxSprite> implements IShip
{
	public static inline var SPEED_PER_RANK:Int = 100;

	public var speedLevel:Int = 0;
	public var speedChangeDelay:Float = -1;

	public var hull:FlxSprite;
	public var sail:FlxSprite;
	public var nest:FlxSprite;

	public var collider:ShipCollider;

	public var gunBarrels:Array<FlxPoint> = [];
	public var gunCooldown:Float = .5;
	public var cooldowns:Array<Float> = [0, 0, 0];

	public var gunLevel:Int = 1;

	public var maxHealth:Int = 100;
	public var pullPower:Float = 192;

	public var hornReady:Bool = true;

	public function new():Void
	{
		super();

		hull = new FlxSprite();
		hull.loadGraphic(GraphicsCache.loadGraphic("assets/images/ship-base.png"), false, 108, 58, false, "ship-base");
		sail = new FlxSprite();
		sail.loadGraphic(GraphicsCache.loadGraphic("assets/images/sail.png"), true, 46, 66, false, "sail");
		nest = new FlxSprite();
		nest.loadGraphic(GraphicsCache.loadGraphic("assets/images/ship-nest.png"), false, 18, 20, false, "ship-nest");

		hull.origin.x = 44;
		hull.origin.y = 28;

		sail.origin.x = 35;
		sail.origin.y = 33;

		nest.origin.x = 49;
		nest.origin.y = 10;

		sail.x = hull.origin.x - sail.origin.x;
		sail.y = hull.origin.y - sail.origin.y;

		nest.x = hull.origin.x - nest.origin.x;
		nest.y = hull.origin.y - nest.origin.y;

		hull.allowCollisions = nest.allowCollisions = sail.allowCollisions = FlxDirectionFlags.NONE;

		add(hull);

		add(sail);
		add(nest);

		collider = new ShipCollider(this);

		sail.animation.frameIndex = 3;

		collider.maxVelocity.x = collider.maxVelocity.y = SPEED_PER_RANK * 3;
		collider.drag.x = collider.drag.y = 10;

		collider.angle = -90;
		collider.angularDrag = 100;
		gunBarrels = [FlxPoint.get(57, 0), FlxPoint.get(12, -29), FlxPoint.get(12, 29)];
		immovable = true;

		health = maxHealth;
	}

	override public function kill():Void
	{
		alive = false;
		exists = true;
		velocity.set();
	}

	public function repair(Amount:Int):Void
	{
		health += Amount;
		if (health > maxHealth)
		{
			health = maxHealth;
		}
		
		Globals.PlayState.healthBar.updateBar();
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

		collider.maxAngular = 30 * (4 - Math.abs(speedLevel));

		if (left)
		{
			collider.angularAcceleration = 300 * -1; // * FlxG.elapsed;
		}
		else if (right)
		{
			collider.angularAcceleration = 300; // * FlxG.elapsed;
		}
		else
		{
			collider.angularAcceleration = 0;
		}

		if (speedLevel == 0)
		{
			collider.acceleration.x = collider.acceleration.y = 0;
			collider.angularAcceleration = 0;
		}
		else
			FlxVelocity.accelerateFromAngle(collider, FlxAngle.asRadians(collider.angle), 100, SPEED_PER_RANK * speedLevel, false);

		var fore:Bool = Actions.fireFore.triggered || Actions.fireAll.triggered;
		var port:Bool = Actions.firePort.triggered || Actions.fireAll.triggered;
		var star:Bool = Actions.fireStar.triggered || Actions.fireAll.triggered;

		if (fore)
		{
			fire(FireDirections.FORE);
		}
		if (port)
		{
			fire(FireDirections.PORT);
		}
		if (star)
		{
			fire(FireDirections.STARBOARD);
		}
		if (hornReady && (Globals.PlayState.PlayerUpgrades.contains("Clown Horn") #if debug || true #end))
		{
			if (Actions.honk.triggered)
			{
				hornReady = false;
				Sounds.playSound("honk");
				FlxTween.tween(scale, {x: 1.2, y: 1.2}, 0.25, {
					ease: FlxEase.backIn,
					type: FlxTweenType.ONESHOT,
					onComplete: (_) ->
					{
						FlxTween.tween(scale, {x: 1, y: 1}, 0.25, {
							type: FlxTweenType.ONESHOT,
							ease: FlxEase.backOut,
							onComplete: (_) ->
							{
								hornReady = true;
							}
						});
					}
				});
			}
		}
	}

	public function fire(Direction:FireDirections):Void
	{
		var p:FlxPoint = FlxPoint.get();
		if ((Direction == FireDirections.FORE || Direction == FireDirections.ALL) && cooldowns[0] <= 0)
		{
			p.copyFrom(gunBarrels[0]);
			p.degrees += hull.angle;
			p += hull.origin + hull.getPosition();
			Globals.PlayState.firePies(p.x, p.y, hull.angle, gunLevel);
			cooldowns[0] = gunCooldown;
		}
		if ((Direction == FireDirections.PORT || Direction == FireDirections.ALL) && cooldowns[1] <= 0)
		{
			p.copyFrom(gunBarrels[1]);
			p.degrees += hull.angle;
			p += hull.origin + hull.getPosition();
			Globals.PlayState.firePies(p.x, p.y, hull.angle - 90, gunLevel);
			cooldowns[1] = gunCooldown;
		}
		if ((Direction == FireDirections.STARBOARD || Direction == FireDirections.ALL) && cooldowns[2] <= 0)
		{
			p.copyFrom(gunBarrels[2]);
			p.degrees += hull.angle;
			p += hull.origin + hull.getPosition();
			Globals.PlayState.firePies(p.x, p.y, hull.angle + 90, gunLevel);
			cooldowns[2] = gunCooldown;
		}
		Sounds.playSound(Sounds.shots[Std.random(Sounds.shots.length)]);

		p.put();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!alive)
			return;

		if (speedChangeDelay > 0)
		{
			speedChangeDelay -= elapsed;
		}
		angle = collider.angle;

		x = collider.x + collider.width / 2 - hull.origin.x;
		y = collider.y + collider.height / 2 - hull.origin.y;

		for (i in 0...cooldowns.length)
		{
			if (cooldowns[i] > 0)
			{
				cooldowns[i] -= elapsed;
			}
		}
	}
}

class ShipCollider extends FlxSprite implements ICollider
{
	public var parent:IShip;

	public function new(Parent:IShip):Void
	{
		super();
		parent = Parent;
		makeGraphic(Std.int(parent.hull.width) + 30, Std.int(parent.hull.width) + 30, 0xff000000);

		centerOrigin();
		centerOffsets();

		Globals.PlayState.colliders.add(this);
	}
}

enum abstract FireDirections(String)
{
	var FORE = "fore";
	var PORT = "port";
	var STARBOARD = "starboard";
	var ALL = "all";
}
