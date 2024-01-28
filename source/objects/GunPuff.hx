package objects;

import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter;

class GunPuff extends FlxTypedEmitter<Poof>
{
	public function new():Void
	{
		super();
		solid = false;
		scale.start.set(FlxPoint.weak(0.5, 0.5), FlxPoint.weak(1.0, 1.0));
		scale.end.set(FlxPoint.weak(0.01, 0.01), FlxPoint.weak(0.05, 0.05));
		speed.start.set(120, 240);
		speed.end.set(0, 20);
		drag.start.set(FlxPoint.weak(100, 100), FlxPoint.weak(100, 100));
		drag.end.set(FlxPoint.weak(1000, 1000), FlxPoint.weak(1000, 1000));
		lifespan.set(0.2, 0.25);
		for (i in 0...20)
		{
			add(new Poof());
		}
		kill();
	}

	public function spawn(X:Float, Y:Float, Angle:Float):Void
	{
		setPosition(X, Y);
		launchAngle.set(Angle - 30, Angle + 30);
		start(true);
	}
}

class Poof extends FlxParticle
{
	public function new():Void
	{
		super();
		loadGraphic(GraphicsCache.loadGraphic("assets/images/poof.png"), false, 40, 40, false, "poof");
	}
}