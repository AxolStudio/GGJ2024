package objects;

import objects.Coin.CoinType;

class Plunder
{
	public var copper:Int;
	public var silver:Int;
	public var gold:Int;
	
	public var xp:Int;

	public var isPlunderDropped = false;

	public function new(c:Int, s:Int, g:Int, XP:Int)
	{
		copper = c;
		silver = s;
		gold = g;
		xp = XP;
	}

	public function Drop(x:Float, y:Float)
	{
		if (isPlunderDropped == false)
		{
			var minX = x - 64.0;
			var maxX = x + 64.0;

			var minY = y - 64.0;
			var maxY = y + 64.0;

			for (i in 0...copper)
			{
				Globals.PlayState.spawnCoin(FlxG.random.float(minX, maxX), FlxG.random.float(minY, maxY), CoinType.COPPER);
			}

			for (i in 0...silver)
			{
				Globals.PlayState.spawnCoin(FlxG.random.float(minX, maxX), FlxG.random.float(minY, maxY), CoinType.SILVER);
			}

			for (i in 0...gold)
			{
				Globals.PlayState.spawnCoin(FlxG.random.float(minX, maxX), FlxG.random.float(minY, maxY), CoinType.GOLD);
			}
			
			Globals.PlayState.xpBar.AddXP(xp);

			isPlunderDropped = true;
		}
	}
}
