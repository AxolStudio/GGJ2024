package objects;

class PlayerXP
{
	public var currentXP:Int = 0;
	public var currentLevel:Int = 1;
	
	public function new():Void
	{
	
	}
	
	public var NeededForNextLevel():Int
	{
		return currentLevel * 100;
	}
	
	public var EnoughForNextLevel():Bool
	{
		return currentXP >= NeededForNextLevel();
	}
	
	public var LevelUp()
	{
		currentXP -= NeedForNextLevel();
		
		currentLevel += 1;
	}
}