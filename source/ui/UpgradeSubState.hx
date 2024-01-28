package ui;

import ui.GameButton;
import flixel.util.FlxAxes;
import flixel.ui.FlxButton;
import flixel.FlxSubState;

class UpgradeSubState extends FlxSubState
{
	public var frame:Frame;

	public var titleText:GameText;

	public var upgrades:Array<UpgradeButton> = [];

	public var ready:Bool = false;

	public function new():Void
	{
		super();
		FlxG.mouse.visible = true;
	}

	override public function create():Void
	{
		add(frame = new Frame(FlxG.width * .85, FlxG.height * .85, BROWN));
		frame.scrollFactor.set();
		frame.screenCenter();
		add(titleText = new GameText("Upgrade Shop"));
		titleText.alignment = "center";
		titleText.screenCenter(FlxAxes.X);
		titleText.y = frame.y + 32;
		titleText.scrollFactor.set();
		var spacingX:Float = 32;
		var spacingY:Float = 32;
		var upgradeWidth:Float = 256;
		var upgradeHeight:Float = 192;

		var upgradesPerRow:Int = Std.int(frame.width / (upgradeWidth + spacingX));
		var upgradesPerCol:Int = Std.int(frame.height / (upgradeHeight + spacingY));
		var startX:Float = frame.x + (frame.width - (upgradesPerRow * (upgradeWidth + spacingX) - spacingX)) / 2;
		var startY:Float = titleText.y + titleText.height + 16;

		var sortedUpgrades:Array<String> = Globals.getUpgradeNamesSorted();

		for (u in sortedUpgrades)
		{
			if (Globals.PlayState.PlayerUpgrades.contains(u))
				continue;

			var upgrade:UpgradeButton = new UpgradeButton(u, boughtUpgrade);

			var x:Int = Std.int(upgrades.length % upgradesPerRow);
			var y:Int = Std.int(upgrades.length / upgradesPerRow);
			upgrade.x = startX + x * (upgradeWidth + spacingX);
			upgrade.y = startY + y * (upgradeHeight + spacingY);

			add(upgrade);
			upgrades.push(upgrade);

			if (Globals.PlayState.PlayerMoney < upgrade.upgradeData.cost
				|| (upgrade.upgradeData.requires != "" && !Globals.PlayState.PlayerUpgrades.contains(upgrade.upgradeData.requires)))
			{
				upgrade.button.toggled = true;
				upgrade.button.enabled = false;
			}
		}
		super.create();
	}

	private function boughtUpgrade(Which:String):Void
	{
		if (Globals.PlayState.PlayerMoney < Globals.upgradeOptions.get(Which).cost)
			return;
		if (Globals.PlayState.PlayerUpgrades == null)
			Globals.PlayState.PlayerUpgrades = [];
		Globals.PlayState.PlayerUpgrades.push(Which);
		Globals.PlayState.PlayerMoney -= Globals.upgradeOptions.get(Which).cost;
		switch (Which)
		{
			case "Pie-Cannons II":
				Globals.PlayState.player.gunLevel = 2;
			case "Pie-Cannons III":
				Globals.PlayState.player.gunLevel = 3;
			case "Plunder Puller":
				Globals.PlayState.player.pullPower = 256;
			case "Plunder Puller II":
				Globals.PlayState.player.pullPower = 320;
			case "Plunder Puller III":
				Globals.PlayState.player.pullPower = 384;
			case "Hull HP+":
				Globals.PlayState.player.maxHealth += 50;
				Globals.PlayState.player.health = Globals.PlayState.player.maxHealth;
			case "Hull HP++":
				Globals.PlayState.player.maxHealth += 100;
				Globals.PlayState.player.health = Globals.PlayState.player.maxHealth;
			case "Hull HP+++":
				Globals.PlayState.player.maxHealth += 150;
				Globals.PlayState.player.health = Globals.PlayState.player.maxHealth;
			default:
		}
		for (u in upgrades)
		{
			u.button.toggled = false;
			if (Globals.PlayState.PlayerMoney < u.upgradeData.cost
				|| (u.upgradeData.requires != "" && !Globals.PlayState.PlayerUpgrades.contains(u.upgradeData.requires)))
			{
				u.button.toggled = true;
				u.button.enabled = false;
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (Actions.openShop.triggered && ready)
		{
			ready = false;
			close();
		}

		super.update(elapsed);
		ready = true;
	}
}

class UpgradeButton extends GameTogglableButton
{
	public var upgradeData:Globals.UpgradeOption;
	public var costText:GameText;
	public var icon:FlxSprite;
	public var callback:String->Void;

	public function new(Which:String, Callback:String->Void):Void
	{
		upgradeData = Globals.upgradeOptions.get(Which);
		super(upgradeData.name, 0, 0, 256, 192, buttonPressed);
		callback = Callback;
		add(costText = new GameText('Buy? Ǒ ${upgradeData.cost}'));
		costText.alignment = "center";
		costText.scrollFactor.set();

		// label.y = y + 8;
		// costText.x = Std.int*x + width / 2 - costText.width / 2;
		// costText.y = y + height - costText.height - 8;
	}

	override function set_alpha(Value:Float):Float
	{
		super.set_alpha(Value);
		if (costText != null)
		{
			costText.alpha = Value;
		}
		return Value;
	}

	private function buttonPressed():Void
	{
		callback(upgradeData.name);
	}

	override public function draw():Void
	{
		if (!visible)
			return;

		if (costText != null)
		{
			costText.x = Std.int(button.x + button.width / 2 - costText.width / 2);
			costText.y = Std.int(button.y + button.height - costText.height - 8 + (button.status == FlxButton.PRESSED ? button.labelDownOffset : 0));
		}
		super.draw();
	}
}