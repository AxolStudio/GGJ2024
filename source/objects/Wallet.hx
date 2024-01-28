package objects;

// Holds all the money for the player, not to be confused with 'Plunder' which details the coins an object should drop.
class Wallet
{
	public var value = 0;
	
	public function new():Void
	{
	
	}
	
	public function CanPurchase(cost:Int)
	{
		return value >= cost;
	}
	
	public function Purchase(cost:Int)
	{
		value -= cost;
		Globals.PlayState.hud.UpdateUI();
		Globals.PlayState.upgradeMenu.UpdateUpgrades();
	}
	
	public function AddValue(amount:Int)
	{
		value += amount;
		Globals.PlayState.hud.UpdateUI();
		Globals.PlayState.upgradeMenu.UpdateUpgrades();
	}
	
	public function AddCoin(coin:Coin)
	{
		AddValue(coin.value);
	}
}