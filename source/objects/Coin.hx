package objects;

class Coin extends FlxTypedSpriteGroup<FlxSprite>
{
	
	public var sprite:FlxSprite;
	public var value:Int;
	
	public function new(x:Float, y:Float):Void
	{
		super();
		this.x = x;
		this.y = y;
		
		sprite = new FlxSprite();
		
		FlxG.watch.add(this, "x");
		FlxG.watch.add(this, "y");
		
	}
	
	public static function GenerateCopper(x:Float, y:Float):Coin
	{
		var newCoin = new Coin(x, y);
		newCoin.value = 1;
		
		newCoin.sprite.loadGraphic(GraphicsCache.loadGraphic("assets/images/CopperCoin.png"), false, 16, 16, false, "copper-coin");
		newCoin.add(newCoin.sprite);
		
		return newCoin;
	}
	
	public static function GenerateSilver(x:Float, y:Float):Coin
	{
		var newCoin = new Coin(x, y);
		newCoin.value = 3;
		
		newCoin.sprite.loadGraphic(GraphicsCache.loadGraphic("assets/images/SilverCoin.png"), false, 16, 16, false, "silver-coin");
		newCoin.add(newCoin.sprite);
		
		return newCoin;
	}
	
	public static function GenerateGold(x:Float, y:Float):Coin
	{
		var newCoin = new Coin(x, y);
		newCoin.value = 5;
		
		newCoin.sprite.loadGraphic(GraphicsCache.loadGraphic("assets/images/GoldCoin.png"), false, 16, 16, false, "gold-coin");
		newCoin.add(newCoin.sprite);
		
		return newCoin;
	}
}