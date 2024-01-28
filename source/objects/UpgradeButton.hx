package objects;

import flixel.text.FlxText;
import flixel.ui.FlxButton;

import objects.UpgradeHandler;

class UpgradeButton extends FlxTypedGroup<FlxSprite>
{
	var upgrade:Upgrade;
	var upgradeIcon:FlxSprite;
	
	// Only one of these buttons/icons should display at a given time.
	var unlockButton:FlxButton;
	var unavailableIcon:FlxSprite;
	var maxedOutIcon:FlxSprite;
	
	var upgradeText:FlxText;
	
	public function new(type:UpgradeType):Void
	{
		super();
		
		upgrade = Globals.PlayState.player.upgradeHandler.Get(type);
		upgradeIcon = upgrade.sprite.clone();
		
		unlockButton = new FlxButton(0.0, 0.0, "", UnlockPressed);
		
		add(upgradeIcon);
		add(unlockButton);
		add(unavailableIcon);
		add(maxedOutIcon);
		add(upgradeText);
		
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}
	
	public function Update()
	{
		var max_rank_reached = upgrade.MaxRankUnlocked();
		var can_unlock_next_rank = upgrade.CanUnlockNextRank(Globals.PlayState.player);
		
		// Decide which button/icon+ to display below the upgradeIcon
		if (max_rank_reached)
		{
			unlockButton.visible = false;
			unavailableIcon.visible = false;
			maxedOutIcon.visible = true;
		}
		else
		{
			if (can_unlock_next_rank)
			{
				unlockButton.visible = true;
				unavailableIcon.visible = false;
				maxedOutIcon.visible = false;
			}
			else
			{
				unlockButton.visible = false;
				unavailableIcon.visible = true;
				maxedOutIcon.visible = false;
			}
		}
		
		
		
	}
	
	public function UnlockPressed():Void
	{
		upgrade.AttemptToUnlockNextRank(Globals.PlayState.player);
	}
}