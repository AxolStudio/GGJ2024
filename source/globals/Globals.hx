package globals;

class Globals
{
	public static var PlayState:PlayState;

	public static var initialized:Bool = false;

	public static var upgradeOptions:Map<String, UpgradeOption> = [];


	public static function initGame():Void
	{
		if (initialized)
			return;

		Actions.init();

		Sounds.loadSounds();

		createUpgradeOptions();

		initialized = true;
	}
	private static function createUpgradeOptions():Void
	{
		upgradeOptions.set("Pie-Cannons II", new UpgradeOption("Pie-Cannons II", 250, "pie-cannon-2", 1));
		upgradeOptions.set("Pie-Cannons III", new UpgradeOption("Pie-Cannons III", 500, "pie-cannon-3", "Pie-Cannons II", 2));
		upgradeOptions.set("Plunder Puller", new UpgradeOption("Plunder Puller", 50, "plunder-puller", "", 3));
		upgradeOptions.set("Plunder Puller II", new UpgradeOption("Plunder Puller II", 125, "plunder-puller-2", "Plunder Puller", 4));
		upgradeOptions.set("Plunder Puller III", new UpgradeOption("Plunder Puller III", 250, "plunder-puller-3", "Plunder Puller II", 5));
		upgradeOptions.set("Hull HP+", new UpgradeOption("Hull HP+", 75, "hull-hp", "", 6));
		upgradeOptions.set("Hull HP++", new UpgradeOption("Hull HP++", 150, "hull-hp-2", "Hull HP+", 7));
		upgradeOptions.set("Hull HP+++", new UpgradeOption("Hull HP+++", 300, "hull-hp-3", "Hull HP++", 8));
		upgradeOptions.set("Clown Horn", new UpgradeOption("Clown Horn", 500, "clown-horn", "", 9));
	}

	public static function getUpgradeNamesSorted():Array<String>
	{
		var sorted:Array<String> = [];
		for (upgrade in upgradeOptions.keys())
		{
			sorted.push(upgrade);
		}
		sorted.sort(function(a:String, b:String):Int
		{
			return upgradeOptions.get(a).order - upgradeOptions.get(b).order;
		});
		return sorted;
	}
}

class UpgradeOption
{
	public var name:String = "";
	public var cost:Int = 0;
	public var image:String = "";
	public var requires:String = "";
	public var order:Int = -1;

	public function new(Name:String = "", Cost:Int = 0, Image:String = "", Requires:String = "", Order:Int = -1):Void
	{
		name = Name;
		cost = Cost;
		image = Image;
		requires = Requires;
		order = Order;
	}
}