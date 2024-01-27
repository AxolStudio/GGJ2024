package;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var background:FlxGroup;
	public var player:Player;
	public var ocean:Ocean;
	public var enemies:FlxTypedGroup<Enemy>;
	public var playerAttacks:FlxTypedGroup<Attack>;
	public var enemyAttacks:FlxTypedGroup<Attack>;

	override public function create()
	{
		add(background = new FlxGroup());

		var backdrop:FlxBackdrop = new FlxBackdrop(GraphicsCache.loadGraphic("assets/images/water.png"));
		background.add(backdrop);

		add(enemies = new FlxTypedGroup<Enemy>());
		add(player = new Player());
		add(playerAttacks = new FlxTypedGroup<Attack>());
		add(enemyAttacks = new FlxTypedGroup<Attack>());

		FlxG.camera.follow(player, FlxCameraFollowStyle.NO_DEAD_ZONE);
		
		ocean = Ocean.Generate();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		player.movement();
	}

}
