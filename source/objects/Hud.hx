package objects;

import flixel.text.FlxText;

class Hud extends FlxTypedGroup<FlxSprite>
{
	var coinPileIcon:FlxSprite;
	var coinPileCounter:FlxText;
	
	public function new():Void
	{
		super();
		
		coinPileIcon = new FlxSprite();
		coinPileIcon.loadGraphic(GraphicsCache.loadGraphic("assets/images/CoinPile.png"), false, 16, 16, false, "coin-pile-icon");
		coinPileIcon.x = FlxG.width / 2 - 32;
		
		coinPileCounter = new FlxText(FlxG.width / 2 - 6, coinPileIcon.height, "0", 12);
	
		add(coinPileIcon);
		add(coinPileCounter);
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}
	
	public function UpdateUI()
	{
		coinPileCounter.text = Std.string(Globals.PlayState.player.wallet.value);
	}
}