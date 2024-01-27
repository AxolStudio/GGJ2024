package objects;

class Upgrade_Hull extends Upgrade
{
	
	
	public function new():Void
	{
		super();
		max_rank = 2;
	}
	
	// Gives the player the next rank of this upgrade,
	// meant to be overridden in child classes.
	public override function UnlockNextRank(player:Player)
	{
		rank += 1;
		switch (rank)
		{
			case 1:
				// Put cannon on left
				null;
				
			case 2:
				// Put cannon on right
				null;
				
			case _:	// Should never happen
				null;
		}
	}
	
	public override function NextRankCost():Int
	{
		var next_rank = rank + 1;
		
		switch (next_rank)
		{
			case 1:
				return 10;
				
			case 2:
				return 12;
				
			case _:
				return 0;
		}
	}
}
