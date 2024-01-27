package objects;

// Stores all the upgrades for the player.
class UpgradeHandler
{
	public var clownHorn:Upgrade_ClownHorn;
	
	public var hull:Upgrade_Hull;
	
	public var sideCannons:Upgrade_SideCannons;
	
	public function new():Void
	{
		clownHorn = new Upgrade_ClownHorn();
		
		hull = new Upgrade_Hull();
		
		sideCannons = new Upgrade_SideCannons();
	}
}