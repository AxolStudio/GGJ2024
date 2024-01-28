package objects;

class Upgrade
{
	// The UI image for the upgrade
	public var sprite:FlxSprite;
	
	// The level the upgrade is at
	public var rank = 0;
	
	public var max_rank = 1;
	
	
	public function new():Void
	{
		sprite = new FlxSprite();
	}
	
	public function IsUnlocked():Bool
	{
		return rank > 0;
	}
	
	public function MaxRankUnlocked():Bool
	{
		return rank >= max_rank;
	}
	
	public function GetRank(): Int
	{
		return rank;
	}
	
	// Gives the player the next rank of this upgrade,
	// meant to be overridden in child classes.
	public function UnlockNextRank(player:Player)
	{
		null;
	}
	
	// The cost of the next rank, in terms of coins.
	// meant to be overridden.
	public function NextRankCost():Int
	{
		return 0;
	}
	
	// Checks if the player can unlock the next rank of this upgrade.
	// Child classes can override this to check additional constraints.
	// Remember to do a super(player) call though!
	public function CanUnlockNextRank(player:Player):Bool
	{
		if (MaxRankUnlocked())
		{
			return false;
		}
		else
		{
			return player.wallet.CanPurchase(NextRankCost());
		}
	}
	
	public function PayForNextRank(wallet:Wallet)
	{
		wallet.Purchase(NextRankCost());
	}
	
	// Attempts to unlock the next rank, performing all the usual checks.
	public function AttemptToUnlockNextRank(player:Player)
	{
		if (CanUnlockNextRank(player))
		{
			PayForNextRank(player.wallet);
			UnlockNextRank(player);
		}
	}
}

