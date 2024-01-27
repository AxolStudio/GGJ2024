package objects;

import flixel.tile.FlxBaseTilemap;
import flixel.tile.FlxTilemap;

/// make a random island
class Island extends FlxGroup
{
	public var x(get, set):Float;
	public var y(get, set):Float;

	public var width(get, never):Float;
	public var height(get, never):Float;

	// temporary just have a shape for now
	private var landshape:Array<Int> = [
		0, 0, 0, 0, 0, 0, 0,
		0, 0, 1, 1, 1, 0, 0,
		0, 1, 1, 1, 1, 1, 0,
		0, 1, 1, 1, 1, 1, 0,
		0, 1, 1, 1, 1, 0, 0,
		0, 0, 1, 1, 1, 0, 0,
		0, 0, 0, 0, 0, 0, 0,
	];

	// TODO: random island shapes - can we also create 'shore' tiles to go under the island?
	public var base:FlxTilemap;
	public var stuff:Array<IslandStuff> = [];

	@:access(flixel.tile.FlxBaseTilemap._data)
	@:access(flixel.tile.FlxTilemap.updateMap)
	public function new():Void
	{
		super();
		base = new FlxTilemap();
		base.loadMapFromArray(landshape, 7, 7, GraphicsCache.loadGraphic("assets/images/island-tiles.png"), 64, 64, FlxTilemapAutoTiling.ALT, 0, 1, 1);
		add(base);

		for (i in 0...landshape.length)
		{
			if (landshape[i] == 1)
			{
				var density:Float = FlxG.random.int(1, 5) * 5;
				if (FlxG.random.bool(density))
				{
					var s = new IslandStuff(i % 7 * 64, i / 7 * 64);
					stuff.push(s);
					add(s);
				}
			}
		}
	}

	private function get_x():Float
	{
		return base.x;
	}

	private function set_x(value:Float):Float
	{
		base.x = value;
		for (s in stuff)
		{
			s.x = s.baseX + value;
		}
		return value;
	}

	private function get_y():Float
	{
		return base.y;
	}

	private function set_y(value:Float):Float
	{
		base.y = value;
		for (s in stuff)
		{
			s.y = s.baseY + value;
		}
		return value;
	}

	private function get_width():Float
	{
		return base.width;
	}

	private function get_height():Float
	{
		return base.height;
	}
}

class IslandStuff extends FlxSprite
{
	public var baseX:Float;
	public var baseY:Float;

	public function new(X:Float, Y:Float):Void
	{
		super();

		GraphicsCache.loadAtlasGraphic(this, "island-stuff");

		animation.randomFrame();

		angle = FlxG.random.float(0, 360);

		baseX = X + FlxG.random.float(-16, 16);
		baseY = Y + FlxG.random.float(-16, 16);

		x = baseX;
		y = baseY;
	}
}