package objects;

enum abstract UpgradeType(String)
{
	var UPGRADE_CLOWNHORN = "Clown Horn";
	var UPGRADE_HULL = "Hull";
	var UPGRADE_SIDE_CANNONS = "Side Cannons";
}


// Stores all the upgrades for the player.
class UpgradeHandler
{
	public var clownHorn:Upgrade_ClownHorn;
	public var hull:Upgrade_Hull;
	public var sideCannons:Upgrade_SideCannons;
	
	
	public function new():Void
	{
		clownHorn   = new Upgrade_ClownHorn();
		
		hull        = new Upgrade_Hull();
		
		sideCannons = new Upgrade_SideCannons();
	}
	
	public function Get(type:UpgradeType):Upgrade
	{
		switch (type)
		{
			case UpgradeType.UPGRADE_CLOWNHORN:
				return clownHorn;
				
			case UpgradeType.UPGRADE_HULL:
				return hull;
				
			case UpgradeType.UPGRADE_SIDE_CANNONS:
				return sideCannons;
		}
		
		
		
	}
}