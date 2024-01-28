package objects;

import flixel.ui.FlxBar;
import ui.GameText;
import flixel.text.FlxText;

class Hud extends FlxTypedGroup<FlxSprite>
{
	public var coinPileIcon:FlxSprite;
	public var coinPileCounter:GameText;

	public var shipHealthBar:FlxBar;
	public var playerXP:FLxBar;
	public var playerLevel:GameText;

	public function new():Void
	{
		super();

		coinPileIcon = new FlxSprite();
		coinPileIcon.loadGraphic(GraphicsCache.loadGraphic("assets/images/CoinPile.png"), false, 16, 16, false, "coin-pile-icon");
		coinPileIcon.x = FlxG.width / 2 - 32;

		coinPileCounter = new GameText("0");
		coinPileCounter.alignment = "center";

		coinPileCounter.x = FlxG.width / 2 - coinPileCounter.width / 2;
		coinPileCounter.y = coinPileIcon.y + coinPileIcon.height + 2;

		add(coinPileIcon);
		add(coinPileCounter);
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	public function UpdateUI()
	{
		coinPileCounter.text = Std.string(Globals.PlayState.PlayerMoney);
		coinPileCounter.x = FlxG.width / 2 - coinPileCounter.width / 2;
	}

	public function GetCoinPileMouthLoc():FlxPoint
	{
		return FlxPoint.weak(Globals.PlayState.player.x, Globals.PlayState.player.y - FlxG.height + 16);
	}
}
