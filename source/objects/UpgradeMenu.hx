package objects;

import objects.UpgradeHandler;

enum State
{
	OPENED;
	CLOSED;
}

class UpgradeMenu extends FlxTypedGroup<FlxSprite>
{
	var state:State;
	
	var upgradeButton_ClownHorn:UpgradeButton;
	var upgradeButton_Hull:UpgradeButton;
	var upgradeButton_SideCannons:UpgradeButton;
	
	public function new():Void
	{
		super();
		
		state = State.CLOSED;
		visible = false;
		
		upgradeButton_ClownHorn   = new UpgradeButton(UpgradeType.UPGRADE_CLOWNHORN);
		upgradeButton_Hull        = new UpgradeButton(UpgradeType.UPGRADE_HULL);
		upgradeButton_SideCannons = new UpgradeButton(UpgradeType.UPGRADE_SIDE_CANNONS);
		
	}
	
	public function UpdateUpgrades()
	{
		if (state == State.OPENED)
		{
			upgradeButton_ClownHorn.Update();
			upgradeButton_Hull.Update();
			upgradeButton_SideCannons.Update();
		}
	}
	
	
	public function Open()
	{
		state = State.OPENED;
		
		UpdateUpgrades();
		
		visible = true;
	}
	
	public function Close()
	{
		state = State.CLOSED;
		visible = false;
	}
	
	public function Toggle()
	{
		switch (state)
		{
			case State.OPENED:
				Close();
				
			case State.CLOSED:
				Open();
		}
	}
}