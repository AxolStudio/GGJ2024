package;

import objects.Coin.CoinType;
import js.html.Cache;
import ui.UpgradeSubState;
import interfaces.ICollider;
import interfaces.IShip;
import objects.Enemy;
import flixel.math.FlxRect;
import objects.Player.ShipCollider;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import flixel.FlxState;

class PlayState extends FlxState
{
	public static inline var WORLD_WIDTH:Int = 16920;
	public static inline var WORLD_HEIGHT:Int = 16920;
	public static inline var CHUNK_SIZE:Int = 1000;
	public static inline var CHUNK_BUFFER:Int = 64;

	public static inline var BOUNDS_BUFFER:Int = 64;

	public var colliders:FlxGroup;
	public var background:FlxGroup;
	public var islands:FlxTypedGroup<Island>;
	public var coins:FlxTypedGroup<Coin>;
	public var player:Player;
	public var enemies:FlxTypedGroup<Enemy>;
	public var playerAttacks:FlxTypedGroup<Pie>;
	public var gunPuffs:FlxTypedGroup<GunPuff>;
	// public var enemyAttacks:FlxTypedGroup<Attack>;

	public var hud:Hud;

	public var tileCollider:FlxSprite;
	public var collider:FlxSprite;

	public var PlayerMoney:Int = 0;
	public var PlayerUpgrades:Array<String> = [];

	override public function create()
	{
		Globals.PlayState = this;

		add(colliders = new FlxGroup());

		add(background = new FlxGroup());

		var backdrop:FlxBackdrop = new FlxBackdrop(GraphicsCache.loadGraphic("assets/images/water.png"));
		background.add(backdrop);

		add(islands = new FlxTypedGroup<Island>());
		add(coins = new FlxTypedGroup<Coin>());
		for (i in 0...100)
		{
			coins.add(new Coin());
		}
		add(enemies = new FlxTypedGroup<Enemy>());
		add(player = new Player());
		player.spawn(-player.width / 2, -player.height / 2);
		add(playerAttacks = new FlxTypedGroup<Pie>());
		// add(enemyAttacks = new FlxTypedGroup<Attack>());

		add(gunPuffs = new FlxTypedGroup<GunPuff>());
		for (i in 0...10)
		{
			gunPuffs.add(new GunPuff());
		}

		add(hud = new Hud());

		generateStuff();

		FlxG.camera.follow(player, FlxCameraFollowStyle.NO_DEAD_ZONE);

		tileCollider = new FlxSprite();
		tileCollider.makeGraphic(64, 64, 0xFF000000);

		super.create();
	}

	public function spawnCoin(X:Float, Y:Float, CType:CoinType):Void
	{
		var coin:Coin = coins.getFirstAvailable(Coin);
		if (coin == null)
		{
			coin = new Coin();
			coins.add(coin);
		}
		coin.spawn(X, Y, CType);
	}

	public function firePie(X:Float, Y:Float, Angle:Float, Rank:Int):Void
	{
		var pie:Pie = playerAttacks.recycle(Pie, Pie.new);
		pie.spawn(X, Y, Angle, 1 + Rank * 0.5, Rank * 2);
	}

	public function firePies(X:Float, Y:Float, Angle:Float, Rank:Int):Void
	{
		switch (Rank)
		{
			case 1:
				firePie(X, Y, Angle, Rank);
			case 2:
				firePie(X, Y, Angle - 10, Rank);
				firePie(X, Y, Angle + 10, Rank);
			case 3:
				firePie(X, Y, Angle - 20, Rank);
				firePie(X, Y, Angle, Rank);
				firePie(X, Y, Angle + 20, Rank);
		}
		// do a cloud of cannon smoke
		var puff:GunPuff = gunPuffs.getFirstAvailable(GunPuff);
		if (puff == null)
		{
			puff = new GunPuff();
			gunPuffs.add(puff);
		}
		puff.spawn(X, Y, Angle);
	}

	private function generateStuff():Void
	{
		// createIslands(80);
		// createEnemies();

		// split the world up into 'chunks' about 640x640px
		// each 'chunk' has a chance to contain the following:
		// 25% Nothing
		// 18% Enemy level 1 between 4-8 of them
		// 12% Enemy level 2 between 2-4 of them
		// 6% Enemy level 3 between 1-2 of them
		// 3% Enemy level 4 1 of them
		// 35% Island
		// when a chunk does spawn one of these things randomly place it in the

		var weights:Array<Float> = [0.25, 0.18, 0.12, 0.6, 0.03, 0.35];
		var things:Array<String> = ["nothing", "enemy1", "enemy2", "enemy3", "enemy4", "island"];

		var chunkSize:Int = CHUNK_SIZE + (CHUNK_BUFFER * 2);
		var chunkCount:Int = Std.int(WORLD_WIDTH / chunkSize);

		var startX:Float = -WORLD_WIDTH / 2;
		var startY:Float = -WORLD_HEIGHT / 2;

		var e:Enemy = null;
		for (x in 0...chunkCount)
		{
			for (y in 0...chunkCount)
			{
				// if  we are in the center  chunks, skip
				if (x >= chunkCount / 2 - 2 && x <= chunkCount / 2 + 2 && y >= chunkCount / 2 - 2 && y <= chunkCount / 2 + 2)
					continue;

				var pick:Int = FlxG.random.weightedPick(weights);
				var thing:String = things[pick];

				var posX:Float = startX + (chunkSize * x) + CHUNK_BUFFER;
				var posY:Float = startY + (chunkSize * y) + CHUNK_BUFFER;

				switch (thing)
				{
					case "nothing":

					case "enemy1":
						for (i in 0...FlxG.random.int(3, 6))
						{
							enemies.add(e = new Enemy());
							posX += FlxG.random.int(0, CHUNK_SIZE);
							posY += FlxG.random.int(0, CHUNK_SIZE);
							e.spawn(posX, posY, 1);
						}

					case "enemy2":
						for (i in 0...FlxG.random.int(2, 4))
						{
							enemies.add(e = new Enemy());
							posX += FlxG.random.int(0, CHUNK_SIZE);
							posY += FlxG.random.int(0, CHUNK_SIZE);
							e.spawn(posX, posY, 2);
						}
					case "enemy3":
						for (i in 0...FlxG.random.int(1, 2))
						{
							enemies.add(e = new Enemy());
							posX += FlxG.random.int(0, CHUNK_SIZE);
							posY += FlxG.random.int(0, CHUNK_SIZE);
							e.spawn(posX, posY, 3);
						}
					case "enemy4":
						enemies.add(e = new Enemy());
						posX += FlxG.random.int(0, CHUNK_SIZE);
						posY += FlxG.random.int(0, CHUNK_SIZE);
						e.spawn(posX, posY, 4);
					case "island":
						var island:Island = new Island();
						island.x = posX + FlxG.random.int(0, CHUNK_SIZE - Std.int(island.width));
						island.y = posY + FlxG.random.int(0, CHUNK_SIZE - Std.int(island.height));
						islands.add(island);

					default:
				}
			}
		}
	}


	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		updateWorldBounds();
		if (Actions.openShop.triggered)
		{
			openSubState(new UpgradeSubState());
			return;
		}

		player.movement();
		FlxG.collide(player.collider, islands);
		FlxG.collide(enemies, islands);
		FlxG.collide(enemies, enemies);

		FlxG.overlap(player.collider, enemies, null, checkPlayerCollideShip);
		FlxG.overlap(enemies, playerAttacks, pieHitShip, checkPieHitShip);
		FlxG.overlap(player.collider, coins, getCoin, checkGetCoin);
	}

	private function getCoin(P:ICollider, C:Coin):Void
	{
		C.kill();
		PlayerMoney += C.value;
		hud.UpdateUI();
		Sounds.playSound(Sounds.coins[Std.random(Sounds.coins.length)]);
	}

	private function checkGetCoin(P:ICollider, C:Coin):Bool
	{
		var p:Player = cast P.parent;
		if (p.alive && p.exists && C.alive && C.exists)
			return CustomCollision.pixelPerfectHitboxCheck(p.hull, C);

		return false;
	}

	private function checkPieHitShip(E:FlxSprite, P:Pie):Bool
	{
		if (E.alive && E.exists && P.alive && P.exists)
			return CustomCollision.pixelPerfectHitboxCheck(E, P);

		return false;
	}

	private function pieHitShip(E:FlxSprite, P:Pie):Void
	{
		E.hurt(P.damage);
		P.kill();
		Sounds.playSound(Sounds.impacts[Std.random(Sounds.impacts.length)]);

		// explosion?
	}

	private function checkPlayerCollideShip(ShipA:ICollider, ShipB:FlxSprite):Bool
	{
		var A:IShip = ShipA.parent;

		if (CustomCollision.pixelPerfectHitboxCheck(A.hull, ShipB))
		{
			return FlxObject.separate(cast ShipA, cast ShipB);
		}

		return false;
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
