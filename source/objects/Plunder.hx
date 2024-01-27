package objects;

class Plunder
{
	public var copper:Int;
	public var silver:Int;
	public var gold:Int;
	
	public var isPlunderDropped = false;
	
	
	public function new(c:Int, s:Int, g:Int)
	{
		copper = c;
		silver = s;
		gold   = g;
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
				Globals.PlayState.coins.add(
					Coin.GenerateCopper(
						FlxG.random.float(minX, maxX),
						FlxG.random.float(minY, maxY)
					)
				);
			}
			
			for (i in 0...silver)
			{
				Globals.PlayState.coins.add(
					Coin.GenerateSilver(
						FlxG.random.float(minX, maxX),
						FlxG.random.float(minY, maxY)
					)
				);
			}
			
			for (i in 0...gold)
			{
				Globals.PlayState.coins.add(
					Coin.GenerateGold(
						FlxG.random.float(minX, maxX),
						FlxG.random.float(minY, maxY)
					)
				);
			}
			
			isPlunderDropped = true;
		}
	}
}