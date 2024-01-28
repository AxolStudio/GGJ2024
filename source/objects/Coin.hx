package objects;

import flixel.tweens.FlxTween;

enum CoinState
{
	Idle;
	Seeking;
	Acquired;
	ToCoinPile;
}

class Coin extends FlxTypedSpriteGroup<FlxSprite>
{
	
	public var sprite:FlxSprite;
	public var whiteStarSprite:FlxSprite;
	
	public var value:Int;
	
	public var state:CoinState = CoinState.Idle;
	
	public var seekTimeMS = 50;
	public var seekRange  = 100;
	
	public function new(x:Float, y:Float):Void
	{
		super();
		this.x = x;
		this.y = y;
		
		sprite = new FlxSprite();
		
		whiteStarSprite = new FlxSprite();
		whiteStarSprite.loadGraphic(GraphicsCache.loadGraphic("assets/images/WhiteStar.png"), false, 16, 16, false, "white-star");
		whiteStarSprite.visible = false;
		
		add(whiteStarSprite);
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
	
	
	public function IsPlayerInSight():Bool
	{
		return FlxMath.distanceBetween(this, Globals.PlayState.player) < seekRange;
	}
	
	public function SetState(newState:CoinState)
	{
		state = newState;
		
		switch(state)
		{
			case CoinState.Idle:
				null;
				
			case CoinState.Seeking:
				null;
				
			case CoinState.Acquired:
				// Globals.PlayState.player.wallet.AddCoin(this);
				Globals.PlayState.PlayerMoney+=value;
				FlxTween.tween(this,{alpha:0},.2, {onComplete:(_)->{this.kill();}});
				
			case CoinState.ToCoinPile:
				whiteStarSprite.visible = true;
				sprite.visible = false;
		}
	}
	
	public function HandleIdle()
	{
		if (IsPlayerInSight())
		{
			SetState(CoinState.Seeking);
		}
	}
	
	public function HandleSeeking()
	{
		FlxVelocity.moveTowardsObject(this, Globals.PlayState.player, 0, seekTimeMS);
		if (FlxMath.distanceBetween(this, Globals.PlayState.player) < 10)
		{
			SetState(CoinState.ToCoinPile);
		}
	}
	
	public function HandleToCoinPile()
	{
		FlxVelocity.moveTowardsPoint(this, Globals.PlayState.hud.GetCoinPileMouthLoc(), 0, seekTimeMS*10);
		if (FlxMath.distanceToPoint(this, Globals.PlayState.hud.GetCoinPileMouthLoc()) < 10)
		{
			SetState(CoinState.Acquired);
		}
	}
	
	public function ProcessState()
	{
		switch(state)
		{
			case CoinState.Idle:
				HandleIdle();
				
			case CoinState.Seeking:
				HandleSeeking();
				
			case CoinState.Acquired:
				null;
				
			case CoinState.ToCoinPile:
				HandleToCoinPile();
		}
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		ProcessState();
	}
}