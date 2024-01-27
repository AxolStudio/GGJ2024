package;

class Ocean
{
	var tile_center: Tile;
	var tile_left:   Tile;
	var tile_right:  Tile;
	var tile_up:     Tile;
	var tile_down:   Tile;
	
	public function shift_left()
	{
		tile_left   = tile_center;
		tile_center = tile_right;
		tile_right  = Tile.GenerateRandom();
	}
	
	public function shift_right()
	{
		tile_right  = tile_center;
		tile_center = tile_left;
		tile_left   = Tile.GenerateRandom();
	}
	
	public function shift_up()
	{
		tile_up     = tile_center;
		tile_center = tile_down;
		tile_down   = Tile.GenerateRandom();
	}
	
	public function shift_down()
	{
		tile_down   = tile_center;
		tile_center = tile_up;
		tile_up     = Tile.GenerateRandom();
	}
	
	public function new():Void
	{
		
	}

	static public function Generate()
	{
		var newOcean = new Ocean();
		
		newOcean.tile_center = Tile.GenerateBlank();
		newOcean.tile_left   = Tile.GenerateBlank();
		newOcean.tile_right  = Tile.GenerateBlank();
		newOcean.tile_up     = Tile.GenerateBlank();
		newOcean.tile_down   = Tile.GenerateBlank();
		
		return newOcean;
	}
}