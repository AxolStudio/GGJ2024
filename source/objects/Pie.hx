package objects;

class Pie extends FlxSprite
{
	public var lifespan:Float;
	public var damage:Int = 1;
	public var owner:FlxSprite = null;

	override public function update(elapsed:Float):Void
	{
		lifespan -= FlxG.elapsed;
		if (lifespan <= 0)
		{
			kill();
		}
		super.update(elapsed);
	}

	override public function new():Void
	{
		super();
		loadGraphic(GraphicsCache.loadGraphic("assets/images/pie.png"), false, 10, 10, "pie");
		centerOrigin();
		centerOffsets();
	}

	public function spawn(Owner:FlxSprite, X:Float, Y:Float, Angle:Float, Lifespan:Float, Damage:Int = 1):Void
	{
		reset(X - width / 2, Y - height / 2);
		angle = Angle;
		velocity.x = Math.cos(angle * Math.PI / 180) * 400;
		velocity.y = Math.sin(angle * Math.PI / 180) * 400;
		damage = Damage;
		lifespan = Lifespan;
		owner = Owner;
	}
}