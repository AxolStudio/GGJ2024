package objects;

import js.html.Animation;

class Coin extends FlxSprite
{
	public var coinType:CoinType;

	public var value(get, never):Int;

	public function new():Void
	{
		super();
		GraphicsCache.loadAtlasGraphic(this, "coins");

		animation.addByIndices("copper", "copper_", [1, 2, 3, 4, 3, 2, 1], ".png", 20, true);
		animation.addByIndices("silver", "silver_", [1, 2, 3, 4, 3, 2, 1], ".png", 20, true);
		animation.addByIndices("gold", "gold_", [1, 2, 3, 4, 3, 2, 1], ".png", 20, true);

		scale.set(.33, .33);
		centerOffsets();
		centerOrigin();
		// drag.set(50, 50);
		kill();
	}

	public function spawn(X:Float, Y:Float, CType:CoinType):Void
	{
		reset(X - width / 2, Y - height / 2);
		coinType = CType;
		animation.play(coinType);
	}

	override public function update(elapsed:Float):Void
	{
		var moving:Bool = false;
		if (alive && exists && isOnScreen())
		{
			if (FlxMath.distanceBetween(this, Globals.PlayState.player.collider) < Globals.PlayState.player.pullPower)
			{
				FlxVelocity.moveTowardsObject(this, Globals.PlayState.player.collider, Globals.PlayState.player.pullPower * 2);
				moving = true;
			}
		}

		super.update(elapsed);
	}

	private function get_value():Int
	{
		return switch (coinType)
		{
			case CoinType.COPPER:
				5;
			case CoinType.SILVER:
				10;
			case CoinType.GOLD:
				25;
			default: 0;
		};
	}
}

enum abstract CoinType(String) to String
{
	var COPPER = "copper";
	var SILVER = "silver";
	var GOLD = "gold";
}
