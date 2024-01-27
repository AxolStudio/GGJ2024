package;

import flixel.math.FlxRect;
import objects.Player.ShipCollider;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import flixel.FlxState;

class PlayState extends FlxState
{
	public static inline var WORLD_WIDTH:Int = 10000;
	public static inline var WORLD_HEIGHT:Int = 10000;

	public static inline var BOUNDS_BUFFER:Int = 64;

	public var background:FlxGroup;
	public var islands:FlxTypedGroup<Island>;
	public var player:Player;
	public var enemies:FlxTypedGroup<Enemy>;
	public var playerAttacks:FlxTypedGroup<Attack>;
	public var enemyAttacks:FlxTypedGroup<Attack>;
	public var coins:FlxTypedGroup<Coin>;
	public var hud:Hud;

	public var tileCollider:FlxSprite;
	public var collider:FlxSprite;

	override public function create()
	{
		Globals.PlayState = this;

		add(background = new FlxGroup());

		var backdrop:FlxBackdrop = new FlxBackdrop(GraphicsCache.loadGraphic("assets/images/water.png"));
		background.add(backdrop);

		add(islands = new FlxTypedGroup<Island>());

		add(enemies = new FlxTypedGroup<Enemy>());
		add(player = new Player());
		player.spawn(0, 0);
		add(playerAttacks = new FlxTypedGroup<Attack>());
		add(enemyAttacks = new FlxTypedGroup<Attack>());
		add(coins = new FlxTypedGroup<Coin>());
		
		add(hud = new Hud());

		createIslands(80);
		createEnemies();

		FlxG.camera.follow(player, FlxCameraFollowStyle.NO_DEAD_ZONE);

		tileCollider = new FlxSprite();
		tileCollider.makeGraphic(64, 64, 0xFF000000);

		
		super.create();
	}

	private function createIslands(Count:Int):Void
	{
		for (i in 0...Count)
		{
			var island:Island = new Island();
			// TODO: some clever stuff here to make sure islands don't overlap
			island.x = FlxG.random.float(-WORLD_WIDTH / 2, WORLD_WIDTH / 2) - island.width / 2;
			island.y = FlxG.random.float(-WORLD_HEIGHT / 2, WORLD_HEIGHT / 2) - island.height / 2;
			trace("island at " + island.x + ", " + island.y);
			islands.add(island);
		}
	}

	private function createEnemies():Void
	{
		for (i in 0...10)
		{
			enemies.add(Enemy.GenerateSloop(FlxG.random.float(-WORLD_WIDTH / 2, WORLD_WIDTH / 2), FlxG.random.float(-WORLD_WIDTH / 2, WORLD_WIDTH / 2)));
		}

		for (i in 0...5)
		{
			enemies.add(Enemy.GenerateFrigate(FlxG.random.float(-WORLD_WIDTH / 2, WORLD_WIDTH / 2), FlxG.random.float(-WORLD_WIDTH / 2, WORLD_WIDTH / 2)));
		}

		for (i in 0...4)
		{
			enemies.add(Enemy.GenerateShipOfLine(FlxG.random.float(-WORLD_WIDTH / 2, WORLD_WIDTH / 2), FlxG.random.float(-WORLD_WIDTH / 2, WORLD_WIDTH / 2)));
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		updateWorldBounds();
		player.movement();
		FlxG.collide(player.collider, islands);
	}

	private function updateWorldBounds():Void
	{
		var bounds:FlxRect = FlxRect.get(FlxG.camera.scroll.x, FlxG.camera.scroll.y, FlxG.camera.width, FlxG.camera.height);

		bounds.x -= BOUNDS_BUFFER;
		bounds.y -= BOUNDS_BUFFER;
		bounds.width += BOUNDS_BUFFER * 2;
		bounds.height += BOUNDS_BUFFER * 2;

		FlxG.worldBounds.copyFrom(bounds);
	}


}
