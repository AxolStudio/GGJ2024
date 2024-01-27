package;

// I want Ocean.hx to be able to use this enum but it doesn't recognize it.
//enum Tile_GenType
//{
//	Ocean;
//	Random;
//}

class Tile
{
	

	public function new():Void
	{
	
	}
	
	static public function GenerateBlank():Tile
	{
		return new Tile();
	}
	
	static public function GenerateRandom():Tile
	{
		return new Tile();
	}
	
	

	//static public function Generate(genType:Tile_GenType):Tile
	//{
	//	var newTile: Tile;
	//
	//	switch genType
	//	{
	//		case Tile_GenType.Ocean:
	//			newTile = new Tile();
	//		
	//		case Tile_GenType.Random:
	//			newTile = new Tile();
	//	}
	//
	//	return newTile;
	//}
}